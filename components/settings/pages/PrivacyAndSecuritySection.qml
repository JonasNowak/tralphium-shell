import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.themes
import qs.widgets
import qs.services

ColumnLayout {
    property string title: "Privacy and security"
    spacing: 12
    Text { text: title; font.pixelSize: 13; font.bold: true; color: Theme.accent; Layout.fillWidth: true; Layout.leftMargin: 4 }
    
    DialogPopup {
        id: privacyDialog
        title: "Privacy hub"
        
        SettingRow {
            icon: "videocam"
            title: "Camera access"
            description: "Allow apps to use your camera"
            Switch {
                checked: Config.privacyCameraAccess
                onToggled: { Config.privacyCameraAccess = !Config.privacyCameraAccess; Config.save(); }
            }
        }
        SettingRow {
            icon: "mic"
            title: "Microphone access"
            description: "Allow apps to use your microphone"
            Switch {
                checked: Config.privacyMicAccess
                onToggled: { Config.privacyMicAccess = !Config.privacyMicAccess; Config.save(); }
            }
        }
        SettingRow {
            icon: "location_on"
            title: "Location access"
            description: "Allow apps to use your location"
            Switch {
                checked: Config.privacyLocationAccess
                onToggled: { Config.privacyLocationAccess = !Config.privacyLocationAccess; Config.save(); }
            }
        }
    }

    DialogPopup {
        id: securityDialog
        title: "Security and sign-in"
        
        SettingRow {
            icon: "password"
            title: "Change password"
            Button { text: "Change"; onClicked: Config.launchTerminal("passwd") }
        }
        SettingRow {
            icon: "lock"
            title: "Lock screen when sleeping"
            Switch { checked: true }
        }
    }

    Rectangle {
        Layout.fillWidth: true; implicitHeight: content.implicitHeight; color: Theme.alpha(Theme.buttonHover, 0.1); radius: 12; border.color: Theme.alpha(Theme.textForeground, 0.1); border.width: 1
        ColumnLayout {
            id: content; anchors.left: parent.left; anchors.right: parent.right; spacing: 0
            
            SettingRow { 
                icon: "shield"
                title: "Privacy hub"
                
                Button { text: "Open"; onClicked: privacyDialog.open() }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            
            SettingRow { 
                icon: "lock"
                title: "Security and sign-in"
                
                Button { text: "Open"; onClicked: securityDialog.open() }
            }
        }
    }
}
