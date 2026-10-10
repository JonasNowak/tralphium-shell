import QtQuick
import QtQuick.Window
import qs.widgets

Window {
    id: win
    width: 200
    height: 600
    visible: true
    color: "black"
    Column {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 10
        spacing: 10
        MaterialIcon { text: "network_wifi"; font.pixelSize: 32; color: "white" }
        MaterialIcon { text: "signal_wifi_4_bar"; font.pixelSize: 32; color: "white" }
        MaterialIcon { text: "wifi_lock"; font.pixelSize: 32; color: "white" }
        MaterialIcon { text: "network_locked"; font.pixelSize: 32; color: "white" }
        MaterialIcon { text: "network_wifi_locked"; font.pixelSize: 32; color: "white" }
    }
    Timer {
        interval: 1000
        running: true
        onTriggered: {
            win.contentItem.grabToImage(function(result) {
                result.saveToFile("screenshot_icons4.png");
                Qt.quit();
            });
        }
    }
}
