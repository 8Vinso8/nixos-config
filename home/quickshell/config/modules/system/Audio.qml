pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../.."
import "../../components"

SystemItem {
    id: root

    spacing: 4

    // Обязательно привязываем узлы, чтобы работали .audio.muted и .audio.volume
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    readonly property bool sinkMuted: Pipewire.defaultAudioSink?.audio?.muted ?? false
    readonly property bool sourceMuted: Pipewire.defaultAudioSource?.audio?.muted ?? false

    BarText {
        width: 16
        horizontalAlignment: Text.AlignHCenter
        text: root.sinkMuted ? "󰝟" : "󰕾"
        color: root.sinkMuted ? Theme.red : Theme.mauve

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }

    BarText {
        width: 16
        horizontalAlignment: Text.AlignHCenter
        text: root.sourceMuted ? "󰍭" : "󰍬"
        color: root.sourceMuted ? Theme.red : Theme.mauve

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onTapped: (eventPoint, button) => {
            if (button === Qt.LeftButton) {
                Quickshell.execDetached(["pavucontrol"]);
            } else if (button === Qt.RightButton) {
                Quickshell.execDetached(["toggle-audio"]);
            } else if (button === Qt.MiddleButton) {
                Quickshell.execDetached(["toggle-microphone"]);
            }
        }
    }
}
