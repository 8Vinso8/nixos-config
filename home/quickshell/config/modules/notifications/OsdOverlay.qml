pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "../.."
import "../../components"

PanelWindow {
    id: osdWindow

    required property NotificationServer server

    property bool shown: false
    property string iconGlyph: "󰕾"
    property int levelValue: -1
    property bool isMuted: false

    function isOsdNotification(n: Notification): bool {
        if (!n)
            return false;
        const sync = n.hints["x-canonical-private-synchronous"] ?? n.hints["synchronous"] ?? n.hints["tag"] ?? "";
        if (sync === "osd")
            return true;
        const app = (n.appName ?? "").toLowerCase();
        const sum = (n.summary ?? "").toLowerCase();
        return app === "notify-send" && (sum === "brightness" || sum === "audio" || sum === "mic" || sum === "volume");
    }

    function parseOsd(n: Notification) {
        const sum = (n.summary ?? "").toLowerCase();
        const body = (n.body ?? "").toLowerCase();

        const isMic = sum.includes("mic") || sum.includes("микро");
        const isBrightness = sum.includes("bright") || sum.includes("ярк");

        if (isBrightness) {
            let val = parseInt(n.hints["value"], 10);
            if (isNaN(val) || val < 0) {
                const m = `${n.summary} ${n.body}`.match(/(\d{1,3})\s*%/);
                if (m)
                    val = parseInt(m[1], 10);
            }
            osdWindow.levelValue = isNaN(val) ? 0 : Math.max(0, Math.min(100, val));
            osdWindow.isMuted = false;
            osdWindow.iconGlyph = "󰃠";
            return;
        }

        osdWindow.levelValue = -1;
        const muted = body.includes("muted") && !body.includes("unmuted");
        const isHeadphones = body.includes("headphone") || body.includes("наушн");
        const isSpeakers = body.includes("speaker") || body.includes("динам") || body.includes("колонк");

        osdWindow.isMuted = muted;

        if (isMic) {
            osdWindow.iconGlyph = muted ? "󰍭" : "󰍬";
        } else if (isHeadphones) {
            osdWindow.iconGlyph = "󰋋";
        } else if (isSpeakers) {
            osdWindow.iconGlyph = "󰓃";
        } else {
            osdWindow.iconGlyph = muted ? "󰝟" : "󰕾";
        }
    }

    Connections {
        target: osdWindow.server

        function onNotification(notification: Notification) {
            if (!osdWindow.isOsdNotification(notification))
                return;

            osdWindow.parseOsd(notification);
            notification.dismiss();

            osdWindow.shown = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1200
        onTriggered: osdWindow.shown = false
    }

    WlrLayershell.layer: WlrLayer.Overlay

    anchors {
        bottom: true
    }

    margins {
        bottom: 80
    }

    color: "transparent"
    exclusiveZone: 0

    implicitWidth: osdCard.width
    implicitHeight: osdCard.height
    visible: osdCard.opacity > 0

    // Пропускаем клики мыши сквозь OSD
    mask: Region {}

    Rectangle {
        id: osdCard
        anchors.centerIn: parent
        width: 130
        height: 120
        radius: 16

        color: Theme.base
        border.color: osdWindow.isMuted ? Theme.red : Theme.border
        border.width: osdWindow.isMuted ? 2 : Theme.islandBorderWidth

        opacity: osdWindow.shown ? 1.0 : 0.0
        scale: osdWindow.shown ? 1.0 : 0.94

        Behavior on opacity {
            NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
        }
        Behavior on scale {
            NumberAnimation { duration: 170; easing.type: Easing.OutCubic }
        }

        Column {
            anchors.centerIn: parent
            spacing: 12

            BarText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: osdWindow.iconGlyph
                font.pixelSize: 48
                color: osdWindow.isMuted ? Theme.red : Theme.mauve
            }

            Rectangle {
                visible: osdWindow.levelValue >= 0
                anchors.horizontalCenter: parent.horizontalCenter
                width: 90
                height: 6
                radius: 3
                color: Theme.surface

                Rectangle {
                    height: parent.height
                    radius: parent.radius
                    color: Theme.mauve
                    width: parent.width * (Math.max(0, osdWindow.levelValue) / 100.0)

                    Behavior on width {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
        }
    }
}
