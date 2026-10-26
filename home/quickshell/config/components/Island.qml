pragma ComponentBehavior: Bound
import QtQuick
import ".."

Rectangle {
    id: root

    default property alias content: contentRow.data
    property alias spacing: contentRow.spacing
    property alias contentOpacity: contentRow.opacity
    property int horizontalPadding: Theme.islandPaddingHorizontal
    property bool hoverable: false
    property bool clickable: false
    property bool shown: true
    readonly property bool hovered: (hoverable || clickable) && hoverHandler.hovered

    signal clicked

    implicitHeight: Theme.islandHeight
    implicitWidth: shown ? contentRow.implicitWidth + horizontalPadding * 2 : 0

    clip: true
    radius: Theme.islandRadius
    color: ((hoverable || clickable) && hovered) ? Theme.surface : Theme.base
    border.color: Theme.border
    border.width: Theme.islandBorderWidth

    opacity: shown ? 1.0 : 0.0
    visible: opacity > 0

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutCubic
        }
    }
    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    HoverHandler {
        id: hoverHandler
        enabled: root.hoverable || root.clickable
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    TapHandler {
        enabled: root.clickable
        acceptedButtons: Qt.LeftButton
        onTapped: root.clicked()
    }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 4
    }
}
