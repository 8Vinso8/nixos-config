pragma Singleton
import QtQuick

QtObject {
    // Catppuccin Mocha Colors (1:1 with Waybar and AGS)
    readonly property color base: "#d9181825"       // rgba(24, 24, 37, 0.85)
    readonly property color text: "#cdd6f4"
    readonly property color subtext: "#a6adc8"
    readonly property color mauve: "#cba6f7"
    readonly property color surface: "#313244"
    readonly property color red: "#f38ba8"
    readonly property color blue: "#89b4fa"
    readonly property color teal: "#94e2d5"
    readonly property color yellow: "#f9e2af"
    readonly property color border: "#73cba6f7"     // rgba(203, 166, 247, 0.45)
    readonly property color darkText: "#11111b"

    // Typography
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 13
    readonly property bool fontBold: true

    // Dimensions
    readonly property int islandHeight: 24
    readonly property int islandRadius: 8
    readonly property int islandBorderWidth: 1
    readonly property int islandPaddingHorizontal: 10
    readonly property int islandSpacing: 6
    readonly property int barMarginTop: 8
    readonly property int barMarginLeft: 8
    readonly property int barMarginRight: 8
}
