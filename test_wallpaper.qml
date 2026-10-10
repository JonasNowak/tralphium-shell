import QtQuick
import Quickshell
import qs.services
import qs.widgets

ShellRoot {
    Wallpaper {
        source: Config.wallpaper
        visible: Config.wallpaper !== ""
    }
    
    Component.onCompleted: {
        console.log("Config.wallpaper is:", Config.wallpaper);
        Quickshell.exit(0);
    }
}
