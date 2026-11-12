pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../.."
import "../../components"

Item {
    id: root

    property bool active: false

    readonly property var powerActions: [
        {
            icon: "󰤄",
            color: Theme.blue,
            cmd: ["systemctl", "suspend"]
        },
        {
            icon: "󰐥",
            color: Theme.red,
            cmd: ["systemctl", "poweroff"]
        },
        {
            icon: "󰜉",
            color: Theme.yellow,
            cmd: ["systemctl", "reboot"]
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

        PanelWindow {
            id: win

            property bool shown: false
            property int currentIndex: 0

            Component.onCompleted: open()

            Timer {
                id: unloadTimer
                interval: 170
                onTriggered: root.active = false
            }

            function open() {
                unloadTimer.stop();
                win.shown = true;
                win.currentIndex = 0;
                keyScope.forceActiveFocus();
            }

            function close() {
                if (!win.shown)
                    return;
                win.shown = false;
                unloadTimer.restart();
            }

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: win.shown ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            color: "transparent"
            exclusiveZone: 0
            visible: win.shown || card.opacity > 0

            TapHandler {
                onTapped: eventPoint => {
                    const pos = eventPoint.position;
                    if (pos.x < card.x || pos.x > card.x + card.width || pos.y < card.y || pos.y > card.y + card.height) {
                        win.close();
                    }
                }
            }

            FocusScope {
                id: keyScope
                anchors.fill: parent
                focus: true

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape || event.key === Qt.Key_Q) {
                        win.close();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Left || event.key === Qt.Key_H) {
                        win.currentIndex = (win.currentIndex - 1 + root.powerActions.length) % root.powerActions.length;
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Right || event.key === Qt.Key_L || event.key === Qt.Key_Tab) {
                        win.currentIndex = (win.currentIndex + 1) % root.powerActions.length;
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Backtab) {
                        win.currentIndex = (win.currentIndex - 1 + root.powerActions.length) % root.powerActions.length;
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                        root.executeAction(win.currentIndex);
                        event.accepted = true;
                    } else if (event.key === Qt.Key_1 || event.key === Qt.Key_S) {
                        root.executeAction(0);
                        event.accepted = true;
                    } else if (event.key === Qt.Key_2 || event.key === Qt.Key_P) {
                        root.executeAction(1);
                        event.accepted = true;
                    } else if (event.key === Qt.Key_3 || event.key === Qt.Key_R) {
                        root.executeAction(2);
                        event.accepted = true;
                    }
                }

                Rectangle {
                    id: card
                    anchors.centerIn: parent
                    width: 226
                    height: 165
                    radius: 16
                    color: Theme.base
                    border.color: Theme.border
                    border.width: Theme.islandBorderWidth
                    clip: true

                    opacity: win.shown ? 1.0 : 0.0
                    scale: win.shown ? 1.0 : 0.95

                    Behavior on opacity {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                    Behavior on scale {
                        NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 10

                        // 3 horizontal icon buttons
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 12

                            Repeater {
                                model: root.powerActions

                                Rectangle {
                                    id: btn
                                    required property int index
                                    required property var modelData

                                    readonly property bool isCurrent: win.currentIndex === btn.index
                                    readonly property bool isHovered: btnHover.hovered

                                    width: 54
                                    height: 54
                                    radius: 14

                                    color: (isCurrent || isHovered) ? Theme.surface : "transparent"
                                    border.color: isCurrent ? btn.modelData.color : (isHovered ? Theme.border : "transparent")
                                    border.width: isCurrent ? 2 : 1

                                    Behavior on color { ColorAnimation { duration: 120 } }
                                    Behavior on border.color { ColorAnimation { duration: 120 } }

                                    HoverHandler {
                                        id: btnHover
                                        cursorShape: Qt.PointingHandCursor
                                        onHoveredChanged: if (hovered) win.currentIndex = btn.index
                                    }

                                    TapHandler {
                                        onTapped: root.executeAction(btn.index)
                                    }

                                    BarText {
                                        anchors.centerIn: parent
                                        text: btn.modelData.icon
                                        font.pixelSize: 28
                                        color: btn.modelData.color
                                        opacity: (btn.isCurrent || btn.isHovered) ? 1.0 : 0.85
                                    }
                                }
                            }
                        }

                        // Divider line
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 160
                            height: 1
                            color: Theme.border
                            opacity: 0.35
                        }

                        // Footer quote
                        Column {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 2

                            BarText {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Where do we go from here?"
                                font.pixelSize: 11
                                font.bold: false
                                font.italic: true
                                color: Theme.subtext
                                opacity: 0.85
                            }

                            BarText {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "And should we really care?"
                                font.pixelSize: 11
                                font.bold: false
                                font.italic: true
                                color: Theme.subtext
                                opacity: 0.85
                            }

                            BarText {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "The end is finally here"
                                font.pixelSize: 11
                                font.bold: false
                                font.italic: true
                                color: Theme.subtext
                                opacity: 0.85
                            }

                            BarText {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "God have mercy"
                                font.pixelSize: 12
                                font.bold: true
                                font.italic: true
                                color: Theme.mauve
                                opacity: 0.95
                            }
                        }
                    }
                }
            }
        }
    }
}
