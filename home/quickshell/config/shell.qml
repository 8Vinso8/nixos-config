import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "modules"
import "modules/notifications"
import "modules/launcher"

ShellRoot {
    NotificationServer {
        id: notifServer

        keepOnReload: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyImagesSupported: true
        actionsSupported: true
        imageSupported: true
    }

    Variants {
        model: Quickshell.screens

        // qmllint disable uncreatable-type
        // qmllint disable missing-property
        PanelWindow {
            id: barWindow
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                top: Theme.barMarginTop
                left: Theme.barMarginLeft
                right: Theme.barMarginRight
            }

            implicitHeight: Theme.islandHeight
            color: "transparent"
            exclusiveZone: Theme.islandHeight

            // Левая группа (Workspaces, ActiveWindow)
            Row {
                id: leftGroup
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.islandSpacing

                Workspaces {}
                ActiveWindow {}
            }

            // Центральная группа (Часы)
            Row {
                id: centerGroup
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                Clock {}
            }

            // Правая группа (Mpris, System, Tray)
            Row {
                id: rightGroup
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.islandSpacing

                Mpris {}
                System {}
                Tray {}
            }
        }
    }

    NotificationOverlay {
        server: notifServer
    }

    OsdOverlay {
        server: notifServer
    }

    AppLauncher {
        id: appLauncher
        onActiveChanged: if (active) { powerMenu.closeMenu(); clipboardMenu.closeMenu(); }
    }

    PowerMenu {
        id: powerMenu
        onActiveChanged: if (active) { appLauncher.closeMenu(); clipboardMenu.closeMenu(); }
    }

    Clipboard {
        id: clipboardMenu
        onActiveChanged: if (active) { appLauncher.closeMenu(); powerMenu.closeMenu(); }
    }
}
