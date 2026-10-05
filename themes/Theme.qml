pragma Singleton
import QtQuick
import Quickshell

// Global theme access: `import qs.themes` then use e.g. `Theme.textForeground`.
Singleton {
    id: root

    // Change this to switch themes: "nord" or "cappuccino"
    property string activeThemeName: "nord"

    readonly property ThemePalette nord: Nord {}
    readonly property ThemePalette cappuccino: Cappuccino {}
    readonly property ThemePalette current: activeThemeName === "cappuccino" ? cappuccino : nord

    // Palette colors of the active theme
    readonly property color shelfBackground: current.shelfBackground
    readonly property real shelfOpacity: current.shelfOpacity
    readonly property color buttonBackground: current.buttonBackground
    readonly property color buttonHover: current.buttonHover
    readonly property real buttonHoverOpacity: current.buttonHoverOpacity
    readonly property color iconColor: current.iconColor
    readonly property color textForeground: current.textForeground
    readonly property color accent: current.accent
    readonly property color indicatorActive: current.indicatorActive
    readonly property color indicatorInactive: current.indicatorInactive

    // Derived colors used throughout the shell
    readonly property color hover: alpha(buttonHover, buttonHoverOpacity)
    readonly property color textSecondary: alpha(textForeground, 0.7)
    readonly property color activeTint: Qt.rgba(0.2, 0.5, 1.0, 0.3)
    readonly property color danger: "#ff5252"

    // Uniform panel styling
    readonly property color panelBackground: alpha(shelfBackground, shelfOpacity)
    readonly property color panelBorder: hover
    readonly property int panelBorderWidth: current.panelBorderWidth
    readonly property int panelRadius: current.panelRadius

    // Material Symbols icon font, loaded once for the whole shell
    readonly property FontLoader iconFontLoader: FontLoader { source: "../assets/fonts/MaterialSymbolsRounded.ttf" }
    readonly property string iconFont: iconFontLoader.name

    function alpha(c, a) {
        return Qt.rgba(c.r, c.g, c.b, a);
    }
}
