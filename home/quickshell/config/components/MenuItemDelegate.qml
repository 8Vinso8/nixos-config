pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import ".."

Rectangle {
    id: delegateRoot

    property bool isCurrent: false
    property bool selectOnClick: false

    property string iconSource: ""
    property string fallbackIcon: "󰖯"
    property color iconColor: Theme.mauve
    property string title: ""
    property string subtitle: ""
    property string badge: ""

    signal activated
    signal selected

    width: ListView.view ? ListView.view.width : parent.width
    height: 48
    radius: 8

    color: (isCurrent || itemHover.hovered) ? Theme.surface : "transparent"
    border.color: isCurrent ? Theme.border : "transparent"
    border.width: 1

    HoverHandler {
        id: itemHover
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: {
            if (delegateRoot.selectOnClick) {
                delegateRoot.selected();
            } else {
                delegateRoot.activated();
            }
        }
        onDoubleTapped: delegateRoot.activated()
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 12
        spacing: 12

        // Иконка
        Item {
            width: 32
            height: 32
            anchors.verticalCenter: parent.verticalCenter

            Image {
                anchors.fill: parent
                visible: delegateRoot.iconSource.length > 0
                source: delegateRoot.iconSource
                fillMode: Image.PreserveAspectFit
                sourceSize.width: 64
                sourceSize.height: 64
                asynchronous: true
                cache: true
                smooth: true
            }

            BarText {
                anchors.centerIn: parent
                visible: delegateRoot.iconSource.length === 0
                text: delegateRoot.fallbackIcon
                font.pixelSize: 22
                color: delegateRoot.iconColor
            }
        }

        // Текстовый блок (Title + Subtitle)
        Column {
            width: parent.width - 32 - 12 - (badgeText.visible ? (badgeText.implicitWidth + 12) : 0)
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            BarText {
                width: parent.width
                text: delegateRoot.title
                font.bold: true
                font.pixelSize: 13
                color: delegateRoot.isCurrent ? Theme.mauve : Theme.text
                elide: Text.ElideRight
            }

            BarText {
                width: parent.width
                visible: text.length > 0
                text: delegateRoot.subtitle
                font.bold: false
                font.pixelSize: 10
                color: Theme.subtext
                elide: Text.ElideRight
            }
        }

        // Бейдж категории
        BarText {
            id: badgeText
            anchors.verticalCenter: parent.verticalCenter
            visible: text.length > 0
            text: delegateRoot.badge
            font.pixelSize: 10
            color: Theme.subtext
        }
    }
}
