pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Hyprland
import ".."
import "../components"

Island {
    id: root

    spacing: 6

    readonly property int maxTitleWidth: 320

    readonly property HyprlandToplevel activeTl: {
        const tl = Hyprland.activeToplevel;
        if (!tl?.activated || tl.workspace?.id !== Hyprland.focusedWorkspace?.id)
            return null;
        return tl;
    }

    readonly property string windowTitle: activeTl?.title.trim() ?? ""
    readonly property string appClass: (activeTl?.wayland ? activeTl.wayland.appId : (activeTl?.lastIpcObject?.class ?? "")).toLowerCase()
    readonly property bool hasWindow: windowTitle.length > 0

    // Подбор Nerd-иконки под активное приложение
    readonly property string appIcon: {
        const c = appClass;
        const t = windowTitle.toLowerCase();
        if (!c)
            return "󰖯";
        if (c.includes("zen") || c.includes("helium"))
            return "󰈹";
        if (c.includes("nvim") || (c.includes("kitty") && (t.includes("nvim") || t.includes("vim"))))
            return "";
        if (c.includes("kitty"))
            return "󰆍";
        if (c.includes("dolphin"))
            return "󰉋";
        if (c.includes("ark"))
            return "󰛫";
        if (c.includes("qbittorrent"))
            return "󰇚";
        if (c.includes("fooyin"))
            return "󰎈";
        if (c.includes("mpv"))
            return "󰕼";
        if (c.includes("pavucontrol"))
            return "󰕾";
        if (c.includes("steam") || c.includes("gamescope") || c.includes("beamng") || c.includes("boxflat"))
            return "󰊗";
        if (c.includes("throne"))
            return "󰒄";
        return "󰖯";
    }

    property string displayedTitle: ""
    property string displayedIcon: "󰖯"

    Component.onCompleted: {
        if (windowTitle.length > 0) {
            displayedTitle = windowTitle;
            displayedIcon = appIcon;
        }
    }

    onWindowTitleChanged: {
        if (windowTitle.length > 0) {
            if (!opacity || displayedTitle === "") {
                textSwitchAnim.stop();
                root.contentOpacity = 1.0;
                displayedTitle = windowTitle;
                displayedIcon = appIcon;
            } else if (displayedTitle !== windowTitle || displayedIcon !== appIcon) {
                textSwitchAnim.restart();
            }
        }
    }

    shown: root.hasWindow

    SequentialAnimation {
        id: textSwitchAnim

        NumberAnimation {
            target: root
            property: "contentOpacity"
            to: 0.0
            duration: 60
        }
        ScriptAction {
            script: {
                if (root.windowTitle.length > 0) {
                    root.displayedTitle = root.windowTitle;
                    root.displayedIcon = root.appIcon;
                }
            }
        }
        NumberAnimation {
            target: root
            property: "contentOpacity"
            to: 1.0
            duration: 120
        }
    }

    BarText {
        text: root.displayedIcon
        color: Theme.mauve
    }

    BarText {
        id: titleLabel
        text: root.displayedTitle
        color: Theme.subtext
        width: Math.min(implicitWidth, root.maxTitleWidth)
        elide: Text.ElideRight
    }

    BarTooltip {
        targetItem: root
        active: hoverHandler.hovered && root.hasWindow

        Column {
            spacing: 4

            Row {
                spacing: 6
                BarText {
                    text: root.displayedIcon
                    color: Theme.mauve
                }
                BarText {
                    text: root.appClass || "Окно"
                    font.bold: true
                    color: Theme.text
                }
            }

            BarText {
                width: Math.min(implicitWidth, 340)
                text: root.windowTitle
                color: Theme.subtext
                wrapMode: Text.WrapAnywhere
                maximumLineCount: 3
                elide: Text.ElideRight
            }
        }
    }

    // Курсор-пальчик при наведении
    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    // СКМ — закрыть окно, ПКМ — переключить плавающий режим (Lua-диспетчеры Hyprland)
    TapHandler {
        acceptedButtons: Qt.MiddleButton | Qt.RightButton
        onTapped: (eventPoint, button) => {
            if (button === Qt.MiddleButton) {
                Hyprland.dispatch("hl.dsp.window.close()");
            } else if (button === Qt.RightButton) {
                Hyprland.dispatch("hl.dsp.window.float({ action = 'toggle' })");
            }
        }
    }
}
