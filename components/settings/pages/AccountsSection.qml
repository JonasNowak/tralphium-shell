import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.themes
import qs.widgets
import qs.services

ColumnLayout {
    property string title: "Accounts"
    spacing: 12
    
    Text { text: title; font.pixelSize: 13; font.bold: true; color: Theme.accent; Layout.fillWidth: true; Layout.leftMargin: 4 }
    
    DialogPopup {
        id: accountsDialog
        title: "Sync and Online Accounts"
        
        SettingRow {
            icon: "sync"
            title: "Enable Sync"
            description: "Sync your settings and preferences"
            Switch {
                checked: Config.syncOnlineAccountsEnabled
                onToggled: { Config.syncOnlineAccountsEnabled = !Config.syncOnlineAccountsEnabled; Config.save(); }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true; implicitHeight: content.implicitHeight; color: Theme.alpha(Theme.buttonHover, 0.1); radius: 12; border.color: Theme.alpha(Theme.textForeground, 0.1); border.width: 1
        
        ColumnLayout {
            id: content; anchors.left: parent.left; anchors.right: parent.right; spacing: 0
            
            SettingRow { 
                icon: "sync"
                title: "Sync and Online Accounts"
                Button { text: "Open"; onClicked: accountsDialog.open() }
            }
        }
    }
}
