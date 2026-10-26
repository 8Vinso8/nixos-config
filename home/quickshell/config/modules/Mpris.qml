pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Hyprland
import ".."
import "../components"

Island {
    id: root

    // Поиск исключительно fooyin (или любого активного, если нужно)
    readonly property MprisPlayer player: {
        const list = Mpris.players.values ?? [];
        return list.find(p => p.identity?.toLowerCase().includes("fooyin") || p.desktopEntry?.toLowerCase().includes("fooyin")) ?? null;
    }

    readonly property bool isPlaying: player?.playbackState === MprisPlaybackState.Playing
    readonly property bool isPaused: player?.playbackState === MprisPlaybackState.Paused
    readonly property bool hasTrack: player !== null && (isPlaying || isPaused)

    clickable: true
    spacing: 6

    // Безопасная обрезка строки отдельно для трека и артиста
    function truncate(str: string, max: int): string {
        const chars = [...str.trim()];
        return chars.length > max ? chars.slice(0, max - 1).join("") + "…" : chars.join("");
    }

    readonly property string shortTitle: truncate(player?.trackTitle || "Неизвестно", 35)
    readonly property string shortArtist: truncate(player?.trackArtist || "", 25)

    readonly property string trackText: shortArtist.length > 0 ? `${shortTitle} - ${shortArtist}` : shortTitle

    // Храним текст и паузу, чтобы при закрытии плеера Fade Out не сжимал пустой островок
    property string displayedText: ""
    property bool displayedPaused: false

    Component.onCompleted: {
        if (hasTrack) {
            displayedText = trackText;
            displayedPaused = isPaused;
        }
    }

    onTrackTextChanged: {
        if (hasTrack) {
            if (!opacity || displayedText === "") {
                trackSwitchAnim.stop();
                root.contentOpacity = 1.0;
                displayedText = trackText;
                displayedPaused = isPaused;
            } else if (displayedText !== trackText) {
                trackSwitchAnim.restart();
            }
        }
    }

    onIsPausedChanged: {
        if (!trackSwitchAnim.running) {
            displayedPaused = isPaused;
        }
    }

    shown: root.hasTrack

    // Мягкий кроссфейд названия песни при переключении
    SequentialAnimation {
        id: trackSwitchAnim

        NumberAnimation {
            target: root
            property: "contentOpacity"
            to: 0.0
            duration: 60
        }
        ScriptAction {
            script: {
                if (root.hasTrack) {
                    root.displayedText = root.trackText;
                    root.displayedPaused = root.isPaused;
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

    // Иконка: играет (mauve нота) / пауза (subtext пауза)
    BarText {
        text: root.displayedPaused ? "󰏤" : "󰎈"
        color: root.displayedPaused ? Theme.subtext : Theme.mauve

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }

    // Название трека и артист
    BarText {
        id: trackLabel
        text: root.displayedText
        color: root.displayedPaused ? Theme.subtext : Theme.text
        font.italic: root.displayedPaused

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }

    // ЛКМ: play/pause (через стандартный onClicked островка)
    onClicked: root.player?.togglePlaying()

    // ПКМ: если окно открыто — фокусируем через Hyprland, если скрыто в трее — поднимаем через процесс
    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: {
            const isWindowOpen = Hyprland.toplevels.values.some(t => (t.wayland ? t.wayland.appId : t.lastIpcObject?.class) === "org.fooyin.fooyin");

            if (isWindowOpen) {
                Hyprland.dispatch("hl.dsp.focus({ window = 'class:org.fooyin.fooyin' })");
            } else {
                Quickshell.execDetached(["fooyin"]);
            }
        }
    }

    // Колесико мыши: следующий / предыдущий трек
    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: event => {
            if (!root.player)
                return;
            if (event.angleDelta.y < 0)
                root.player.next();
            else if (event.angleDelta.y > 0)
                root.player.previous();
        }
    }

    BarTooltip {
        targetItem: root
        active: root.hovered && root.hasTrack

        Column {
            spacing: 4

            // Трек
            Row {
                spacing: 8
                BarText {
                    text: "󰎈"
                    color: Theme.mauve
                }
                BarText {
                    text: root.player?.trackTitle || "Неизвестно"
                    color: Theme.text
                    font.bold: true
                }
            }

            // Исполнитель
            Row {
                spacing: 8
                visible: ((root.player?.trackArtist ?? "").trim().length) > 0
                BarText {
                    text: "󰠃"
                    color: Theme.mauve
                }
                BarText {
                    text: root.player?.trackArtist || ""
                    color: Theme.subtext
                }
            }

            // Альбом
            Row {
                spacing: 8
                visible: ((root.player?.trackAlbum ?? "").trim().length) > 0
                BarText {
                    text: "󰀥"
                    color: Theme.mauve
                }
                BarText {
                    text: root.player?.trackAlbum || ""
                    color: Theme.subtext
                }
            }
        }
    }
}
