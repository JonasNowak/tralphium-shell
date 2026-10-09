pragma Singleton
import QtQuick
import Quickshell
import qs.services

// Global theme access: `import qs.themes` then use e.g. `Theme.textForeground`.
Singleton {
    id: root

    // Synchronized with ~/.config/tralphium/config.json via Config service
    property string activeThemeName: Config.theme

    Connections {
        target: Config
        function onThemeChanged() {
            if (root.activeThemeName !== Config.theme) {
                root.activeThemeName = Config.theme;
            }
        }
    }

    function colorToMango(c) {
        let r = Math.round(c.r * 255).toString(16).padStart(2, '0');
        let g = Math.round(c.g * 255).toString(16).padStart(2, '0');
        let b = Math.round(c.b * 255).toString(16).padStart(2, '0');
        let a = Math.round(c.a * 255).toString(16).padStart(2, '0');
        return "0x" + r + g + b + a;
    }

    onActiveThemeNameChanged: {
        if (Config.theme !== activeThemeName) {
            Config.setTheme(activeThemeName);
        }
    }

    function setTheme(name) {
        Config.setTheme(name);
    }

    readonly property ThemePalette nord: Nord {}
    readonly property ThemePalette catppuccinMocha: CatppuccinMocha {}
    readonly property ThemePalette catppuccinMacchiato: CatppuccinMacchiato {}
    readonly property ThemePalette catppuccinFrappe: CatppuccinFrappe {}
    readonly property ThemePalette catppuccinLatte: CatppuccinLatte {}
    readonly property ThemePalette kanagawa: Kanagawa {}
    readonly property ThemePalette oneDark: OneDark {}
    readonly property ThemePalette oneLight: OneLight {}

    readonly property ThemePalette current: {
        if (activeThemeName === "catppuccin-mocha") return catppuccinMocha;
        if (activeThemeName === "catppuccin-macchiato") return catppuccinMacchiato;
        if (activeThemeName === "catppuccin-frappe") return catppuccinFrappe;
        if (activeThemeName === "catppuccin-latte") return catppuccinLatte;
        if (activeThemeName === "kanagawa") return kanagawa;
        if (activeThemeName === "one-dark") return oneDark;
        if (activeThemeName === "one-light") return oneLight;
        return nord;
    }

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
