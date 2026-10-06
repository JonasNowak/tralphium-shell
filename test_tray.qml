import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

ShellRoot {
    Window {
        width: 200; height: 200; visible: true
        Text {
            text: SystemTray ? "Tray present" : "No tray"
        }
    }
}
