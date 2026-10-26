pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import ".."
import "../components"

Island {
    id: root

    spacing: 8
    shown: SystemTray.items.values.length > 0

    // Текущий открытый элемент трея и координата X для поповера
    property SystemTrayItem activeMenuItem: null
    property int menuX: 0

    function getIconSource(item: SystemTrayItem): string {
        const id = (item.id ?? "").toLowerCase();
        const title = (item.title ?? "").toLowerCase();

        if (id.includes("boxflat") || title.includes("boxflat")) {
            return `file://${Quickshell.env("HOME")}/.config/icons/boxflat/steering-wheel.png`;
        }

        return item.icon ?? "";
    }

    function openContextMenu(item: SystemTrayItem, delegateItem: Item) {
        if (!item.hasMenu)
            return;

        if (root.activeMenuItem === item) {
            root.activeMenuItem = null;
            return;
        }

        const pos = delegateItem.mapToItem(null, 0, 0);
        root.menuX = Math.round(pos.x);
        root.activeMenuItem = item;
    }

    Repeater {
        model: SystemTray.items.values

        Item {
            id: trayItemDelegate
            required property SystemTrayItem modelData

            readonly property bool isThrone: {
                const key = `${modelData.id ?? ""} ${modelData.title ?? ""}`.toLowerCase();
                return key.includes("throne") || key.includes("nekoray");
            }

            width: 16
            height: 16
            opacity: iconHover.hovered ? 0.75 : 1.0

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }

            Image {
                anchors.centerIn: parent
                width: trayItemDelegate.isThrone ? 14 : 16
                height: trayItemDelegate.isThrone ? 14 : 16
                sourceSize.width: 32
                sourceSize.height: 32
                mipmap: true
                smooth: true
                fillMode: Image.PreserveAspectFit
                source: root.getIconSource(trayItemDelegate.modelData)
            }

            HoverHandler {
                id: iconHover
                cursorShape: Qt.PointingHandCursor
            }

            TapHandler {
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                onTapped: (eventPoint, button) => {
                    const item = trayItemDelegate.modelData;

                    if (button === Qt.LeftButton) {
                        if (item.onlyMenu) {
                            root.openContextMenu(item, trayItemDelegate);
                        } else {
                            root.activeMenuItem = null;
                            item.activate();
                        }
                    } else if (button === Qt.RightButton) {
                        root.openContextMenu(item, trayItemDelegate);
                    } else if (button === Qt.MiddleButton) {
                        root.activeMenuItem = null;
                        item.secondaryActivate();
                    }
                }
            }

            WheelHandler {
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: event => {
                    trayItemDelegate.modelData.scroll(event.angleDelta.y, false);
                }
            }
        }
    }

    // Кастомное меню трея в стиле Catppuccin (работает без UseQApplication)
    LazyLoader {
        active: root.activeMenuItem !== null

        // qmllint disable unqualified
        PopupWindow {
            id: trayMenuPopup

            readonly property var win: root.QsWindow.window
            readonly property bool hasItems: menuOpener.children.values.length > 0
            property bool hasOpened: false

            anchor.window: win ?? null
            anchor.rect.x: win ? Math.min(Math.max(8, root.menuX), win.width - menuCard.implicitWidth - 8) : root.menuX
            anchor.rect.y: win ? win.height : 30
            anchor.margins.top: 6

            color: "transparent"
            visible: hasItems
            grabFocus: true

            onVisibleChanged: {
                if (visible) {
                    hasOpened = true;
                } else if (hasOpened) {
                    root.activeMenuItem = null;
                }
            }

            Timer {
                interval: 2000
                running: !trayMenuPopup.hasOpened
                onTriggered: {
                    if (!trayMenuPopup.hasOpened) {
                        root.activeMenuItem = null;
                    }
                }
            }

            implicitWidth: menuCard.implicitWidth
            implicitHeight: menuCard.implicitHeight

            QsMenuOpener {
                id: menuOpener
                menu: root.activeMenuItem?.menu ?? null
            }

            PopupCard {
                id: menuCard
                implicitWidth: Math.max(160, menuColumn.implicitWidth + 16)
                implicitHeight: menuColumn.implicitHeight + 16

                Column {
                    id: menuColumn
                    anchors.centerIn: parent
                    spacing: 2

                    Repeater {
                        model: menuOpener.children

                        Item {
                            id: entryItem
                            required property QsMenuEntry modelData

                            readonly property bool isCheckable: modelData.buttonType !== QsMenuButtonType.None
                            readonly property bool isRadio: modelData.buttonType === QsMenuButtonType.RadioButton
                            readonly property bool isChecked: modelData.checkState === Qt.Checked

                            width: Math.max(144, entryRow.implicitWidth + 24)
                            height: modelData.isSeparator ? 9 : 26

                            // Разделитель
                            Rectangle {
                                visible: entryItem.modelData.isSeparator
                                x: 6
                                width: menuColumn.width - 12
                                height: 1
                                anchors.verticalCenter: parent.verticalCenter
                                color: Theme.border
                            }

                            // Кнопка пункта меню
                            Rectangle {
                                visible: !entryItem.modelData.isSeparator
                                x: 0
                                width: menuColumn.width
                                height: parent.height
                                radius: 6
                                color: (entryHover.hovered && entryItem.modelData.enabled) ? Theme.surface : "transparent"

                                Row {
                                    id: entryRow
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    spacing: 8

                                    // Индикатор чекбокса / радио (если пункт переключаемый)
                                    BarText {
                                        visible: entryItem.isCheckable
                                        text: entryItem.isRadio ? (entryItem.isChecked ? "󰄵" : "󰄱") : (entryItem.isChecked ? "󰄴" : "󰄱")
                                        color: entryItem.isChecked ? Theme.mauve : Theme.subtext
                                        opacity: entryItem.modelData.enabled ? 1.0 : 0.4
                                        font.pixelSize: 11
                                    }

                                    BarText {
                                        id: entryLabel
                                        text: (entryItem.modelData.text ?? "").replace(/[_&]/g, "")
                                        color: entryItem.modelData.enabled ? Theme.text : Theme.subtext
                                        opacity: entryItem.modelData.enabled ? 1.0 : 0.4
                                    }
                                }

                                HoverHandler {
                                    id: entryHover
                                    cursorShape: entryItem.modelData.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                }

                                TapHandler {
                                    enabled: entryItem.modelData.enabled
                                    onTapped: {
                                        entryItem.modelData.triggered();
                                        root.activeMenuItem = null;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
