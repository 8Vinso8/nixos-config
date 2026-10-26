pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import ".."

PanelWindow {
    id: rootWindow

    property bool shown: false
    property int cardWidth: 540
    property int cardHeight: 460
    property bool showSearch: true
    property Component sidePanel: null
    property int sidePanelWidth: 340

    property alias searchPlaceholder: searchInput.placeholderText
    property alias searchText: searchInput.text
    property alias listView: list
    default property alias content: list.data

    signal activated(int index)
    signal deleteRequested(int index)
    signal closedAndHidden

    Component.onCompleted: open()

    Timer {
        id: unloadTimer
        interval: 170
        onTriggered: rootWindow.closedAndHidden()
    }

    function open() {
        unloadTimer.stop();
        rootWindow.shown = true;
        searchInput.text = "";
        list.currentIndex = 0;
        list.positionViewAtBeginning();
        if (rootWindow.showSearch) {
            searchInput.forceActiveFocus();
        } else {
            keyScope.forceActiveFocus();
        }
    }

    function close() {
        if (!rootWindow.shown)
            return;
        rootWindow.shown = false;
        unloadTimer.restart();
    }

    function toggle() {
        if (rootWindow.shown)
            close();
        else
            open();
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: rootWindow.shown ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusiveZone: 0
    visible: rootWindow.shown || card.opacity > 0

    TapHandler {
        onTapped: eventPoint => {
            const pos = eventPoint.position;
            if (pos.x < card.x || pos.x > card.x + card.width || pos.y < card.y || pos.y > card.y + card.height) {
                rootWindow.close();
            }
        }
    }

    FocusScope {
        id: keyScope
        anchors.fill: parent
        focus: true

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                rootWindow.close();
                event.accepted = true;
            } else if (event.key === Qt.Key_Down || event.key === Qt.Key_Tab || (event.key === Qt.Key_J && (event.modifiers & Qt.ControlModifier))) {
                if (list.count > 0) {
                    list.incrementCurrentIndex();
                    list.positionViewAtIndex(list.currentIndex, ListView.Contain);
                }
                event.accepted = true;
            } else if (event.key === Qt.Key_Up || event.key === Qt.Key_Backtab || (event.key === Qt.Key_K && (event.modifiers & Qt.ControlModifier))) {
                if (list.count > 0) {
                    list.decrementCurrentIndex();
                    list.positionViewAtIndex(list.currentIndex, ListView.Contain);
                }
                event.accepted = true;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (list.currentIndex >= 0 && list.currentIndex < list.count) {
                    rootWindow.activated(list.currentIndex);
                }
                event.accepted = true;
            } else if (
                (event.key === Qt.Key_Delete && ((event.modifiers & Qt.ShiftModifier) || (event.modifiers & Qt.ControlModifier) || searchInput.text.length === 0)) ||
                (event.key === Qt.Key_D && (event.modifiers & Qt.AltModifier))
            ) {
                if (list.count > 0 && list.currentIndex >= 0 && list.currentIndex < list.count) {
                    rootWindow.deleteRequested(list.currentIndex);
                }
                event.accepted = true;
            }
        }

        Rectangle {
            id: card
            anchors.centerIn: parent
            width: rootWindow.cardWidth
            height: rootWindow.cardHeight
            radius: 16
            color: Theme.base
            border.color: Theme.border
            border.width: Theme.islandBorderWidth
            clip: true

            opacity: rootWindow.shown ? 1.0 : 0.0
            scale: rootWindow.shown ? 1.0 : 0.95

            Behavior on opacity {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }
            Behavior on scale {
                NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
            }

            Row {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                Column {
                    width: rootWindow.sidePanel ? (parent.width - rootWindow.sidePanelWidth - parent.spacing) : parent.width
                    height: parent.height
                    spacing: 10

                    Rectangle {
                        id: searchBar
                        visible: rootWindow.showSearch
                        width: parent.width
                        height: 42
                        radius: 10
                        color: Theme.surface
                        border.color: searchInput.activeFocus ? Theme.mauve : Theme.border
                        border.width: 1

                        Behavior on border.color {
                            ColorAnimation { duration: 150 }
                        }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 10
                            spacing: 10

                            BarText {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "󰍉"
                                font.pixelSize: 18
                                color: Theme.mauve
                            }

                            TextInput {
                                id: searchInput
                                Keys.forwardTo: [keyScope]
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 54
                                color: Theme.text
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.bold: true
                                clip: true
                                selectByMouse: true
                                selectionColor: Theme.mauve
                                selectedTextColor: Theme.base

                                property string placeholderText: "Поиск..."

                                BarText {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: searchInput.placeholderText
                                    color: Theme.subtext
                                    visible: searchInput.text.length === 0
                                    font.pixelSize: 13
                                    font.bold: false
                                }
                            }

                            BarText {
                                anchors.verticalCenter: parent.verticalCenter
                                visible: searchInput.text.length > 0
                                text: "󰅖"
                                font.pixelSize: 14
                                color: clearHover.hovered ? Theme.red : Theme.subtext

                                HoverHandler {
                                    id: clearHover
                                    cursorShape: Qt.PointingHandCursor
                                }

                                TapHandler {
                                    onTapped: {
                                        searchInput.text = "";
                                        searchInput.forceActiveFocus();
                                    }
                                }
                            }
                        }
                    }

                    ListView {
                        id: list
                        width: parent.width
                        height: parent.height - (searchBar.visible ? (searchBar.height + 10) : 0)
                        clip: true
                        spacing: 4
                        boundsBehavior: Flickable.StopAtBounds

                        WheelHandler {
                            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                            onWheel: event => {
                                const maxScroll = Math.max(0, list.contentHeight - list.height);
                                list.contentY = Math.max(0, Math.min(maxScroll, list.contentY - event.angleDelta.y * 1.5));
                            }
                        }

                        BarText {
                            anchors.centerIn: parent
                            visible: list.count === 0 && searchInput.text.length > 0
                            text: "Ничего не найдено"
                            color: Theme.subtext
                            font.pixelSize: 13
                        }
                    }
                }

                Loader {
                    id: sideLoader
                    visible: rootWindow.sidePanel !== null
                    width: rootWindow.sidePanelWidth
                    height: parent.height
                    sourceComponent: rootWindow.sidePanel
                }
            }
        }
    }
}
