import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.themes
import qs.widgets
import qs.services

ColumnLayout {
    property string title: "Connected devices"
    spacing: 12
    
    Text { text: title; font.pixelSize: 13; font.bold: true; color: Theme.accent; Layout.fillWidth: true; Layout.leftMargin: 4 }
    
    DialogPopup {
        id: phoneHubDialog
        title: "Phone Hub"
        
        SettingRow {
            icon: "smartphone"
            title: "Enable Phone Hub"
            description: "Connect your phone for notifications"
            Switch {
                checked: Config.phoneHubEnabled
                onToggled: { Config.phoneHubEnabled = !Config.phoneHubEnabled; Config.save(); }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true; implicitHeight: content.implicitHeight; color: Theme.alpha(Theme.buttonHover, 0.1); radius: 12; border.color: Theme.alpha(Theme.textForeground, 0.1); border.width: 1
        
        ColumnLayout {
            id: content; anchors.left: parent.left; anchors.right: parent.right; spacing: 0
            
            SettingRow { 
                icon: "smartphone"
                title: "Phone Hub"
                description: "Connect your phone"
                Button { text: "Open"; onClicked: phoneHubDialog.open() }
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            SettingRow { 
                icon: "share"
                title: "LocalSend"
                description: "Share files easily"
                Button { text: "Open"; onClicked: Config.launchShare("") }
            }
        }
    }
}
