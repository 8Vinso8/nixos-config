pragma ComponentBehavior: Bound
import QtQuick
import "../components"
import "system"

Island {
    id: root

    spacing: 10

    IdleInhibitor {}
    Brightness {}
    Language {}
    Audio {}
}
