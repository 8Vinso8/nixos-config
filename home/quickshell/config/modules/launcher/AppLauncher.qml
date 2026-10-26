pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import "../.."
import "../../components"

Item {
    id: root

    property bool active: false
    property var indexedApps: []

    function resolveIcon(iconName: string): string {
        if (!iconName)
            return "";
        if (iconName.startsWith("/") || iconName.startsWith("file://") || iconName.startsWith("image://"))
            return iconName.startsWith("/") ? "file://" + iconName : iconName;
        const resolved = Quickshell.iconPath(iconName, true);
        if (!resolved)
            return "";
        return (resolved.startsWith("image://") || resolved.startsWith("file://")) ? resolved : "file://" + resolved;
    }

    function reloadApps() {
        const apps = DesktopEntries.applications.values;
        if (!apps || apps.length === 0)
            return;

        root.indexedApps = apps.filter(app => app && !app.noDisplay && app.name && app.name.length > 0).map(app => {
            const nameLower = app.name.toLowerCase();
            const sub = app.genericName || app.comment || "";
            const kw = (app.keywords ?? []).join(" ");
            return {
                entry: app,
                name: app.name,
                nameLower: nameLower,
                subtitle: sub,
                badge: (app.categories && app.categories.length > 0) ? app.categories[0] : "",
                iconSource: root.resolveIcon(app.icon ?? ""),
                searchBlob: `${nameLower} ${sub.toLowerCase()} ${(app.id ?? "").toLowerCase()} ${kw.toLowerCase()}`
            };
        }).sort((a, b) => a.name.localeCompare(b.name));
    }

    Component.onCompleted: reloadApps()

    Connections {
        target: DesktopEntries
        function onApplicationsChanged() {
            root.reloadApps();
        }
    }

    function closeMenu() {
        if (loader.item)
            loader.item.close();
        else
            root.active = false;
    }

    IpcHandler {
        target: "launcher"

        function open(): void {
            if (loader.item)
                loader.item.open();
            else
                root.active = true;
        }

        function close(): void {
            root.closeMenu();
        }

        function toggle(): void {
            if (root.active && loader.item?.shown)
                root.closeMenu();
            else
                open();
        }
    }

    LazyLoader {
        id: loader
        active: root.active

        MenuOverlay {
            id: launcher
            searchPlaceholder: "Запуск приложения..."
            cardWidth: 540
            cardHeight: 460

            onClosedAndHidden: root.active = false

            readonly property var filteredApps: {
                const q = launcher.searchText.trim().toLowerCase();
                if (q.length === 0)
                    return root.indexedApps;

                return root.indexedApps.filter(item => item.searchBlob.includes(q)).sort((a, b) => {
                    const aStarts = a.nameLower.startsWith(q);
                    const bStarts = b.nameLower.startsWith(q);
                    if (aStarts !== bStarts)
                        return aStarts ? -1 : 1;
                    return a.name.localeCompare(b.name);
                });
            }

            function launchIndex(idx: int) {
                if (idx >= 0 && idx < filteredApps.length) {
                    const entry = filteredApps[idx].entry;
                    launcher.close();

                    if (entry.runInTerminal) {
                        Quickshell.execDetached(["xdg-terminal-exec", ...entry.command]);
                    } else {
                        entry.execute();
                    }
                }
            }
            onActivated: idx => launchIndex(idx)

            onSearchTextChanged: {
                listView.currentIndex = 0;
                listView.positionViewAtBeginning();
            }

            listView.model: launcher.filteredApps

            listView.delegate: MenuItemDelegate {
                required property int index
                required property var modelData

                isCurrent: launcher.listView.currentIndex === index
                title: modelData.name
                subtitle: modelData.subtitle
                iconSource: modelData.iconSource
                badge: modelData.badge

                onActivated: launcher.launchIndex(index)
            }
        }
    }
}
