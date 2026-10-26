pragma ComponentBehavior: Bound
import QtQuick
import ".."

Rectangle {
    id: root

    color: Theme.base
    border.color: Theme.border
    border.width: Theme.islandBorderWidth
    radius: Theme.islandRadius

    transformOrigin: Item.Top
    opacity: 0.0
    scale: 0.96

    Component.onCompleted: {
        opacity = 1.0;
        scale = 1.0;
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 160
            easing.type: Easing.OutCubic
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }
}
