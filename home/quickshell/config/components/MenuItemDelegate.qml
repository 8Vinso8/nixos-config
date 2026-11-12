pragma ComponentBehavior: Bound
import QtQuick
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
    height: delegateRoot.subtitle.length > 0 ? 48 : 38
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

        Item {
            id: iconBox
            width: delegateRoot.subtitle.length > 0 ? 32 : 24
            height: width
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
                font.pixelSize: delegateRoot.subtitle.length > 0 ? 22 : 18
                color: delegateRoot.iconColor
            }
        }

        Column {
            width: parent.width - iconBox.width - 12 - (badgeText.visible ? (badgeText.implicitWidth + 12) : 0)
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
