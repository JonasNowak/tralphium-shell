import QtQuick
import QtQuick.Window
import Quickshell
import qs.widgets

Window {
    width: 600
    height: 400
    visible: true
    color: "black"
    Column {
        anchors.centerIn: parent
        spacing: 10
        Row {
            spacing: 10
            MaterialIcon { text: "wifi"; font.pixelSize: 24; color: "white" }
            Text { text: "wifi"; color: "white" }
        }
        Row {
            spacing: 10
            MaterialIcon { text: "network_wifi"; font.pixelSize: 24; color: "white" }
            Text { text: "network_wifi"; color: "white" }
        }
        Row {
            spacing: 10
            MaterialIcon { text: "network_wifi_3_bar"; font.pixelSize: 24; color: "white" }
            Text { text: "network_wifi_3_bar"; color: "white" }
        }
        Row {
            spacing: 10
            MaterialIcon { text: "signal_wifi_4_bar"; font.pixelSize: 24; color: "white" }
            Text { text: "signal_wifi_4_bar"; color: "white" }
        }
        Row {
            spacing: 10
            MaterialIcon { text: "wifi_lock"; font.pixelSize: 24; color: "white" }
            Text { text: "wifi_lock"; color: "white" }
        }
        Row {
            spacing: 10
            MaterialIcon { text: "network_locked"; font.pixelSize: 24; color: "white" }
            Text { text: "network_locked"; color: "white" }
        }
    }
}
