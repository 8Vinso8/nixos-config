pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "../.."

PanelWindow {
    id: overlayWindow

    required property NotificationServer server

    ListModel {
        id: cardsModel
    }

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

    function getSyncKey(n: Notification): string {
        if (!n)
            return "";
        const hintKey = n.hints["x-canonical-private-synchronous"] ?? n.hints["synchronous"] ?? n.hints["tag"] ?? "";
        if (hintKey)
            return `sync:${hintKey}`;
        if (n.appName === "notify-send" && n.summary)
            return `notify-send:${n.summary}`;
        return "";
    }

    Connections {
        target: overlayWindow.server

        function onNotification(notification: Notification) {
            if (overlayWindow.isOsdNotification(notification)) {
                return; // OSD отображается в отдельном OsdOverlay снизу
            }
            notification.tracked = true;
            const key = overlayWindow.getSyncKey(notification);

            if (key.length > 0) {
                for (let i = 0; i < cardsModel.count; i++) {
                    if (cardsModel.get(i).syncKey === key) {
                        const oldId = cardsModel.get(i).notifId;
                        cardsModel.setProperty(i, "notifId", notification.id);

                        const oldNotif = overlayWindow.server.trackedNotifications.values.find(n => n.id === oldId);
                        if (oldNotif && oldNotif !== notification) {
                            oldNotif.dismiss();
                        }
                        return;
                    }
                }
            }

            cardsModel.append({
                syncKey: key,
                notifId: notification.id
            });
        }
    }

    function removeById(id: int) {
        for (let i = cardsModel.count - 1; i >= 0; i--) {
            if (cardsModel.get(i).notifId === id) {
                cardsModel.remove(i);
            }
        }
        const n = overlayWindow.server.trackedNotifications.values.find(item => item.id === id);
        if (n)
            n.dismiss();
    }

    WlrLayershell.layer: WlrLayer.Overlay

    anchors {
        top: true
        right: true
    }

    margins {
        top: 6
        right: Theme.barMarginRight
    }

    color: "transparent"
    exclusiveZone: 0

    implicitWidth: 320
    implicitHeight: Math.max(1, notifCol.implicitHeight)
    visible: cardsModel.count > 0

    mask: Region {
        item: notifCol
    }

    Column {
        id: notifCol
        width: 320
        spacing: 8

        move: Transition {
            NumberAnimation {
                properties: "y"
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        Repeater {
            id: notifRepeater
            model: cardsModel

            NotificationCard {
                required property int notifId
                required property string syncKey

                notification: overlayWindow.server.trackedNotifications.values.find(n => n.id === notifId) ?? null

                onDismissRequested: overlayWindow.removeById(notifId)

                onDismissAllRequested: {
                    const list = [...overlayWindow.server.trackedNotifications.values];
                    cardsModel.clear();
                    for (const n of list) {
                        n.dismiss();
                    }
                }
            }
        }
    }
}
