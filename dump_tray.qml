import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

ShellRoot {
    Window {
        width: 200; height: 200; visible: true
        Component.onCompleted: {
            for (var i = 0; i < SystemTray.items.length; i++) {
                var item = SystemTray.items[i];
                console.log("Tray item keys:");
                for (var key in item) {
                    console.log(" - " + key + ": " + item[key]);
                }
            }
            Qt.quit();
        }
    }
}
