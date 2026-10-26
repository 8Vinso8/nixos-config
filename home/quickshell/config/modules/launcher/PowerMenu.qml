pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import "../.."
import "../../components"

Item {
    id: root

    property bool active: false

    readonly property var powerActions: [
        {
            name: "Выключение",
            subtitle: "Завершить работу системы",
            icon: "󰐥",
            color: Theme.red,
            badge: "Poweroff",
            cmd: ["systemctl", "poweroff"]
        },
        {
            name: "Перезагрузка",
            subtitle: "Перезапустить систему",
            icon: "󰜉",
            color: Theme.yellow,
            badge: "Reboot",
            cmd: ["systemctl", "reboot"]
        },
        {
            name: "Спящий режим",
            subtitle: "Перевести ПК в режим сна",
            icon: "󰤄",
            color: Theme.blue,
            badge: "Suspend",
            cmd: ["systemctl", "suspend"]
        },
        {
            name: "Выход из сессии",
            subtitle: "Завершить сеанс Hyprland",
            icon: "󰍃",
            color: Theme.mauve,
            badge: "Exit",
            cmd: ["hyprctl", "dispatch", "exit"]
        }
    ]

    function closeMenu() {
        if (loader.item)
            loader.item.close();
        else
            root.active = false;
    }

    function executeAction(index: int) {
        if (index >= 0 && index < powerActions.length) {
            const act = powerActions[index];
            root.closeMenu();
            Quickshell.execDetached(act.cmd);
        }
    }

    IpcHandler {
        target: "powermenu"

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
            id: powerOverlay
            showSearch: false
            cardWidth: 320
            cardHeight: 228

            onClosedAndHidden: root.active = false
            onActivated: idx => root.executeAction(idx)

            listView.model: root.powerActions

            listView.delegate: MenuItemDelegate {
                required property int index
                required property var modelData

                isCurrent: powerOverlay.listView.currentIndex === index
                title: modelData.name
                subtitle: modelData.subtitle
                fallbackIcon: modelData.icon
                iconColor: modelData.color
                badge: modelData.badge

                onActivated: root.executeAction(index)
            }
        }
    }
}
