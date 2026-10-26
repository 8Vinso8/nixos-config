pragma ComponentBehavior: Bound
import QtQuick

Row {
    id: root

    spacing: 4
    opacity: hoverHandler.hovered ? 0.75 : 1.0

    Behavior on opacity {
        NumberAnimation {
            duration: 150
        }
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }
}
