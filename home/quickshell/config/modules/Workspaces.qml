pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Hyprland
import ".."
import "../components"

Island {
    id: root

    readonly property int btnSize: 18
    readonly property int btnSpacing: 4

    horizontalPadding: 4
    spacing: 0

    readonly property var workspaceIds: {
        const ids = new Set([1, 2, 3, 4, 5]);
        for (const ws of Hyprland.workspaces.values) {
            if (ws.id > 0)
                ids.add(ws.id);
        }
        const focusedId = Hyprland.focusedWorkspace?.id ?? -1;
        if (focusedId > 0)
            ids.add(focusedId);

        return [...ids].sort((a, b) => a - b);
    }

    readonly property int activeIndex: root.workspaceIds.indexOf(Hyprland.focusedWorkspace?.id ?? 1)

    Item {
        id: container

        implicitWidth: buttonsRow.implicitWidth
        implicitHeight: root.btnSize
        clip: true

        // Плавное расширение/сужение островка при добавлении/удалении 6+ воркспейса
        Behavior on implicitWidth {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        // Скользящая активная плашка с эффектом растяжения (liquid pill)
        Rectangle {
            id: activeIndicator

            readonly property bool isValid: root.activeIndex >= 0
            readonly property real targetX: isValid ? root.activeIndex * (root.btnSize + root.btnSpacing) : 0

            // Две точки привязки с разной скоростью движения
            property real headX: targetX
            property real tailX: targetX

            Behavior on headX {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutExpo
                }
            }

            Behavior on tailX {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }

            visible: opacity > 0
            opacity: isValid ? 1.0 : 0.0

            // Всегда берем крайнюю левую точку как X, а разницу между ними — как растяжение ширины
            x: Math.min(headX, tailX)
            y: 0
            width: root.btnSize + Math.abs(headX - tailX)
            height: root.btnSize
            radius: root.btnSize / 2
            color: Theme.mauve

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }
        }

        // Ряд круглых кнопок воркспейсов
        Row {
            id: buttonsRow
            spacing: root.btnSpacing
            anchors.verticalCenter: parent.verticalCenter

            Repeater {
                model: root.workspaceIds

                Rectangle {
                    id: wsBtn
                    required property int modelData

                    readonly property HyprlandWorkspace wsObject: Hyprland.workspaces.values.find(ws => ws.id === modelData) ?? null

                    readonly property bool isFocused: Hyprland.focusedWorkspace?.id === modelData
                    readonly property bool isOccupied: (wsObject?.toplevels.values.length ?? 0) > 0

                    width: root.btnSize
                    height: root.btnSize
                    radius: root.btnSize / 2

                    color: (hoverHandler.hovered && !isFocused) ? Theme.surface : "transparent"

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }

                    BarText {
                        id: wsLabel
                        anchors.centerIn: parent
                        text: wsBtn.modelData
                        font.pixelSize: 11
                        font.bold: wsBtn.isFocused || wsBtn.isOccupied

                        color: wsBtn.isFocused ? Theme.darkText : Theme.text
                        opacity: (wsBtn.isFocused || wsBtn.isOccupied) ? 1.0 : 0.4

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                    }

                    HoverHandler {
                        id: hoverHandler
                        cursorShape: Qt.PointingHandCursor
                    }

                    TapHandler {
                        onTapped: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${wsBtn.modelData} })`)
                    }
                }
            }
        }
    }
}
