import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.themes
import qs.widgets
import qs.services

ColumnLayout {
    property string title: "Apps"
    spacing: 12
    Text { text: title; font.pixelSize: 13; font.bold: true; color: Theme.accent; Layout.fillWidth: true; Layout.leftMargin: 4 }
    
    Rectangle {
        Layout.fillWidth: true; implicitHeight: content.implicitHeight; color: Theme.alpha(Theme.buttonHover, 0.1); radius: 12; border.color: Theme.alpha(Theme.textForeground, 0.1); border.width: 1
        ColumnLayout {
            id: content; anchors.left: parent.left; anchors.right: parent.right; spacing: 0
            
            SettingRow { 
                icon: "apps"
                title: "Manage your apps"
                Button {
                    text: "Open Terminal"
                    onClicked: Config.launchTerminal()
                }
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            SettingRow { 
                icon: "shop"
                title: "Flathub Packages"
                description: "Install Linux Apps"
                Button { 
                    text: "Open"
                    onClicked: Config.launchBrowser("https://flathub.org") 
                } 
            }
        }
    }
}
