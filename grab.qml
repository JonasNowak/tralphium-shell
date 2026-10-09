import QtQuick
import QtQuick.Window
import "components/settings"
import qs.themes

SettingsWindow {
    id: win
    color: "black"
    Component.onCompleted: {
        open()
        currentTab = 0
    }
    
    Timer {
        interval: 1000
        running: true
        onTriggered: {
            win.contentItem.grabToImage(function(result) {
                result.saveToFile("screenshot.png");
                Qt.quit();
            });
        }
    }
}
