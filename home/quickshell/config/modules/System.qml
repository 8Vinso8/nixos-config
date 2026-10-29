pragma ComponentBehavior: Bound
import QtQuick
import "../components"
import "system"

Island {
    id: root

    spacing: 6

    IdleInhibitor {}
    Brightness {}
    Language {}
    Audio {}
}
