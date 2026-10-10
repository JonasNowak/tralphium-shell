import QtQuick
import QtQuick.Layouts
import qs.themes
import qs.widgets
import qs.services

ColumnLayout {
    property string title: "About Tralphium"
    spacing: 12
    Text { text: title; font.pixelSize: 13; font.bold: true; color: Theme.accent; Layout.fillWidth: true; Layout.leftMargin: 4 }
    
    DialogPopup {
        id: updateDialog
        title: "System Update"
        Text { text: "Your system is up to date.\nVersion 0.10.0 (Alpha)"; color: Theme.textForeground; font.pixelSize: 13 }
    }
    
    Rectangle {
        Layout.fillWidth: true; implicitHeight: content.implicitHeight; color: Theme.alpha(Theme.buttonHover, 0.1); radius: 12; border.color: Theme.alpha(Theme.textForeground, 0.1); border.width: 1
        ColumnLayout {
            id: content; anchors.left: parent.left; anchors.right: parent.right; spacing: 0
            
            // Header with OS logo
            Item {
                Layout.fillWidth: true
                implicitHeight: 180
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 24
                    
                    // Tralphium Logo placeholder
                    Rectangle {
                        width: 96
                        height: 96
                        radius: 48
                        color: "transparent"
                        border.color: Theme.alpha(Theme.textForeground, 0.1)
                        border.width: 1
                        MaterialIcon { anchors.centerIn: parent; text: "terminal"; font.pixelSize: 64; color: Theme.accent }
                    }
                    
                    ColumnLayout {
                        spacing: 4
                        Text { text: "Tralphium Shell"; font.pixelSize: 28; font.bold: true; color: Theme.textForeground }
                        Text { text: "Version 0.10.0 (Alpha) (64-bit)"; font.pixelSize: 13; color: Theme.textSecondary }
                        Item { height: 8 }
                        Button { text: "Check for updates"; primary: false; onClicked: updateDialog.open() }
                    }
                }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            
            SettingRow {
                icon: "fiber_new"
                title: "See what's new"
                Button { text: "Open"; onClicked: Config.launchBrowser("https://github.com/jonasnowak/tralphium") }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            
            SettingRow {
                icon: "bug_report"
                title: "Report an issue"
                Button { text: "Open"; onClicked: Config.launchBrowser("https://github.com/jonasnowak/tralphium/issues") }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            
            SettingRow {
                icon: "health_and_safety"
                title: "Diagnostics"
                description: "Open the Diagnostics app to run tests and check device health."
                Button { text: "Open"; onClicked: Config.launchTerminal("btop") }
            }
        }
    }
    
    Item { height: 12 }
    
    Text { text: "System Fetch"; font.pixelSize: 13; font.bold: true; color: Theme.accent; Layout.fillWidth: true; Layout.leftMargin: 4 }
    
    Rectangle {
        Layout.fillWidth: true; implicitHeight: fetchContent.implicitHeight; color: Theme.alpha(Theme.buttonHover, 0.1); radius: 12; border.color: Theme.alpha(Theme.textForeground, 0.1); border.width: 1
        
        RowLayout {
            id: fetchContent
            anchors.fill: parent
            anchors.margins: 24
            spacing: 32
            
            MaterialIcon {
                Layout.alignment: Qt.AlignTop
                text: "terminal"
                font.pixelSize: 100
                color: Theme.accent
            }
            
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                
                Text { text: "jonasnowak@tralphium"; font.pixelSize: 16; font.bold: true; color: Theme.activeTint }
                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.2) }
                
                GridLayout {
                    columns: 2
                    columnSpacing: 16
                    rowSpacing: 4
                    
                    Text { text: "Host OS:"; font.pixelSize: 13; font.bold: true; color: Theme.accent }
                    Text { text: "Linux x86_64"; font.pixelSize: 13; color: Theme.textForeground }
                    
                    Text { text: "Kernel:"; font.pixelSize: 13; font.bold: true; color: Theme.accent }
                    Text { text: "6.6.10-desktop"; font.pixelSize: 13; color: Theme.textForeground }
                    
                    Text { text: "Uptime:"; font.pixelSize: 13; font.bold: true; color: Theme.accent }
                    Text { text: "2 hours, 14 mins"; font.pixelSize: 13; color: Theme.textForeground }
                    
                    Text { text: "Shell:"; font.pixelSize: 13; font.bold: true; color: Theme.accent }
                    Text { text: "bash 5.2.21"; font.pixelSize: 13; color: Theme.textForeground }
                    
                    Text { text: "DE:"; font.pixelSize: 13; font.bold: true; color: Theme.accent }
                    Text { text: "Quickshell (Wayland)"; font.pixelSize: 13; color: Theme.textForeground }
                    
                    Text { text: "CPU:"; font.pixelSize: 13; font.bold: true; color: Theme.accent }
                    Text { text: "Intel(R) Core(TM) i7-10510U (8) @ 4.90GHz"; font.pixelSize: 13; color: Theme.textForeground }
                    
                    Text { text: "Memory:"; font.pixelSize: 13; font.bold: true; color: Theme.accent }
                    Text { text: "4192MiB / 15886MiB"; font.pixelSize: 13; color: Theme.textForeground }
                }
            }
        }
    }
}
