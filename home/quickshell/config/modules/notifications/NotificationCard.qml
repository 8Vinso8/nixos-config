pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "../.."
import "../../components"

Rectangle {
    id: root

    property Notification notification: null

    signal dismissRequested
    signal dismissAllRequested

    readonly property bool isCritical: (root.notification?.urgency ?? 0) === NotificationUrgency.Critical
    readonly property int duration: isCritical ? 0 : ((root.notification?.expireTimeout ?? -1) > 0 ? root.notification.expireTimeout : 4500)

    readonly property bool showAppName: {
        const name = (root.notification?.appName ?? "").toLowerCase();
        return name.length > 0 && name !== "notify-send";
    }

    onNotificationChanged: {
        if (root.notification && !slideOutAnim.running && root.duration > 0) {
            progressAnim.restart();
        }
    }

    Connections {
        target: root.notification
        function onClosed() {
            root.closeWithAnim();
        }
    }

    function closeWithAnim() {
        if (slideOutAnim.running)
            return;
        progressAnim.stop();
        slideOutAnim.start();
    }

    width: 320
    height: implicitHeight
    implicitHeight: Math.max(56, cardContent.implicitHeight + 20)

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
        }
    }

    radius: Theme.islandRadius
    color: Theme.base
    border.color: isCritical ? Theme.red : Theme.border
    border.width: isCritical ? 2 : Theme.islandBorderWidth
    clip: true

    transform: Translate {
        id: slideTrans
        x: 40
    }
    opacity: 0.0

    Component.onCompleted: slideInAnim.start()

    ParallelAnimation {
        id: slideInAnim
        NumberAnimation {
            target: slideTrans
            property: "x"
            to: 0
            duration: 220
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: root
            property: "opacity"
            to: 1.0
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    ParallelAnimation {
        id: slideOutAnim
        NumberAnimation {
            target: slideTrans
            property: "x"
            to: 40
            duration: 160
            easing.type: Easing.InCubic
        }
        NumberAnimation {
            target: root
            property: "opacity"
            to: 0.0
            duration: 150
            easing.type: Easing.InCubic
        }
        onFinished: root.dismissRequested()
    }

    property real progress: 1.0

    NumberAnimation {
        id: progressAnim
        target: root
        property: "progress"
        from: 1.0
        to: 0.0
        duration: Math.max(100, root.duration)
        running: root.duration > 0
        paused: cardHover.hovered
        onFinished: root.closeWithAnim()
    }

    function getIconSource(iconName: string, imgPath: string): string {
        if (imgPath && imgPath.length > 0) {
            return imgPath.startsWith("/") ? "file://" + imgPath : imgPath;
        }
        if (iconName && iconName.length > 0) {
            if (iconName.startsWith("/") || iconName.startsWith("file://")) {
                return iconName.startsWith("/") ? "file://" + iconName : iconName;
            }
            const resolved = Quickshell.iconPath(iconName, true);
            if (resolved && resolved.length > 0) {
                return "file://" + resolved;
            }
        }
        return "";
    }

    readonly property string iconSource: getIconSource(root.notification?.appIcon ?? "", root.notification?.image ?? "")

    readonly property string fallbackGlyph: root.isCritical ? "󰀨" : "󰂚"

    readonly property var actionList: {
        const raw = root.notification?.actions ?? [];
        return raw.filter(a => a && a.identifier !== "default");
    }

    HoverHandler {
        id: cardHover
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onTapped: (eventPoint, button) => {
            if (!root.notification)
                return;

            if (button === Qt.LeftButton) {
                const defAction = root.notification.actions?.find(a => a?.identifier === "default");
                defAction?.invoke();
                root.closeWithAnim();
            } else if (button === Qt.RightButton) {
                root.dismissAllRequested();
            }
        }
    }

    Item {
        id: closeBtn
        width: 16
        height: 16
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        z: 2

        BarText {
            anchors.centerIn: parent
            text: "󰅖"
            font.pixelSize: 11
            color: closeHover.hovered ? Theme.red : Theme.subtext
        }

        HoverHandler {
            id: closeHover
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            onTapped: root.closeWithAnim()
        }
    }

    Column {
        id: cardContent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        spacing: 6

        BarText {
            visible: root.showAppName
            text: root.notification?.appName ?? ""
            color: Theme.subtext
            font.pixelSize: 10
            font.bold: false
            elide: Text.ElideRight
            width: parent.width - 24
        }

        Row {
            width: parent.width
            spacing: 10

            Item {
                width: 32
                height: 32
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    anchors.fill: parent
                    visible: root.iconSource.length > 0
                    source: root.iconSource
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: 64
                    sourceSize.height: 64
                    mipmap: true
                    smooth: true
                }

                BarText {
                    anchors.centerIn: parent
                    visible: root.iconSource.length === 0
                    text: root.fallbackGlyph
                    font.pixelSize: 22
                    color: root.isCritical ? Theme.red : Theme.mauve
                }
            }

            Column {
                width: parent.width - 42
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                BarText {
                    width: parent.width
                    text: root.notification?.summary ?? ""
                    font.bold: true
                    font.pixelSize: 13
                    color: Theme.text
                    wrapMode: Text.Wrap
                    textFormat: Text.StyledText
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }

                BarText {
                    width: parent.width
                    visible: text.length > 0
                    text: root.notification?.body ?? ""
                    font.bold: false
                    font.pixelSize: 11
                    color: Theme.subtext
                    wrapMode: Text.Wrap
                    textFormat: Text.StyledText
                    maximumLineCount: 4
                    elide: Text.ElideRight
                }
            }
        }

        Row {
            width: parent.width
            spacing: 6
            visible: root.actionList.length > 0

            Repeater {
                model: root.actionList

                Rectangle {
                    id: actionBtn
                    required property NotificationAction modelData

                    implicitWidth: btnText.implicitWidth + 16
                    implicitHeight: 22
                    radius: 5
                    color: btnHover.hovered ? Theme.surface : Theme.base
                    border.color: Theme.border
                    border.width: 1

                    BarText {
                        id: btnText
                        anchors.centerIn: parent
                        text: actionBtn.modelData?.text ?? ""
                        font.pixelSize: 10
                        font.bold: false
                        color: Theme.text
                    }

                    HoverHandler {
                        id: btnHover
                        cursorShape: Qt.PointingHandCursor
                    }

                    TapHandler {
                        onTapped: {
                            actionBtn.modelData?.invoke();
                            root.closeWithAnim();
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: progressBar
        visible: root.duration > 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 8
        height: 2
        radius: 1
        color: root.isCritical ? Theme.red : Theme.mauve
        opacity: 0.8
        width: Math.max(0, (root.width - 16) * root.progress)
    }
}
