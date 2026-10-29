pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import "../.."
import "../../components"

SystemItem {
    id: root

    property bool active: false

    // Нативный Wayland-протокол zwp_idle_inhibitor_v1
    IdleInhibitor {
        window: root.QsWindow.window
        enabled: root.active
    }

    BarText {
        width: 16
        horizontalAlignment: Text.AlignHCenter
        text: root.active ? "󰒳" : "󰒲"
        color: root.active ? Theme.red : Theme.mauve

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }

    TapHandler {
        onTapped: root.active = !root.active
    }
}
