pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "../.."
import "../../components"

SystemItem {
    id: root

    property string layout: "EN"

    function setLayoutFromKeymap(keymap: string) {
        const k = keymap.toLowerCase();
        root.layout = (k.includes("rus") || k.includes("ru")) ? "RU" : "EN";
    }

    // Определение раскладки при старте панели
    Process {
        command: ["hyprctl", "devices", "-j"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const dev = JSON.parse(text);
                    const kb = dev.keyboards?.find(k => k.main) ?? dev.keyboards?.[0];
                    if (kb?.active_keymap) {
                        root.setLayoutFromKeymap(kb.active_keymap);
                    }
                } catch (e) {
                    console.warn("Language init failed:", e);
                }
            }
        }
    }

    // Отслеживание смены раскладки в реальном времени (от Hyprland)
    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent) {
            if (event.name === "activelayout") {
                const idx = event.data.indexOf(",");
                if (idx !== -1) {
                    root.setLayoutFromKeymap(event.data.slice(idx + 1));
                }
            }
        }
    }

    BarText {
        text: "󰌌"
        color: Theme.mauve
    }

    BarText {
        text: root.layout
        color: Theme.text
    }

    TapHandler {
        onTapped: Quickshell.execDetached(["hyprctl", "switchxkblayout", "all", "next"])
    }
}
