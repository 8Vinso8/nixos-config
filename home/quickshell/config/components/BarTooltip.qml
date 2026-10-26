pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Item {
    id: root

    required property bool active
    property Item targetItem: parent
    default property Component content

    visible: false
    width: 0
    height: 0

    Timer {
        id: delayTimer
        interval: 400
        running: root.active
    }

    LazyLoader {
        active: !delayTimer.running && root.active

        // qmllint disable unqualified
        PopupWindow {
            readonly property var win: root.QsWindow.window

            anchor.window: win ?? null
            anchor.rect.x: win && root.targetItem ? Math.min(Math.max(8, Math.round(root.targetItem.mapToItem(null, 0, 0).x + (root.targetItem.width - card.implicitWidth) / 2)), win.width - card.implicitWidth - 8) : 0
            anchor.rect.y: win ? win.height : 0
            anchor.margins.top: 6

            color: "transparent"
            visible: true
            implicitWidth: card.implicitWidth
            implicitHeight: card.implicitHeight

            PopupCard {
                id: card
                implicitWidth: Math.max(140, contentLoader.implicitWidth + 20)
                implicitHeight: contentLoader.implicitHeight + 14

                Loader {
                    id: contentLoader
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: root.content
                }
            }
        }
    }
}
