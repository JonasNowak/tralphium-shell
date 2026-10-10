import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.themes
import qs.widgets
import qs.services

ColumnLayout {
    property string title: "Device"
    spacing: 12
    Text { text: title; font.pixelSize: 13; font.bold: true; color: Theme.accent; Layout.fillWidth: true; Layout.leftMargin: 4 }
    
    DialogPopup {
        id: displaysDialog
        title: "Displays"
        
        SettingRow {
            icon: "aspect_ratio"
            title: "Resolution"
            
            ComboBox {
                id: resCombo
                model: ["1920x1080", "2560x1440", "3840x2160"]
                currentIndex: Math.max(0, model.indexOf(Config.displaysResolution))
                onActivated: (index) => {
                    Config.displaysResolution = model[index];
                    Config.save();
                }
                
                background: Rectangle {
                    implicitWidth: 160; implicitHeight: 32; color: Theme.alpha(Theme.buttonHover, 0.1); border.color: Theme.alpha(Theme.textForeground, 0.2); border.width: 1; radius: 6
                }
                contentItem: Text {
                    leftPadding: 12; rightPadding: resCombo.indicator.width + resCombo.spacing; text: resCombo.displayText; font.pixelSize: 13; color: Theme.textForeground; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight
                }
                indicator: MaterialIcon {
                    x: resCombo.width - width - resCombo.rightPadding; y: resCombo.topPadding + (resCombo.availableHeight - height) / 2; text: "expand_more"; font.pixelSize: 20; color: Theme.iconColor
                }
            }
        }
    }

    DialogPopup {
    DialogPopup {
        id: mouseDialog
        title: "Mouse and touchpad"
        SettingRow {
            icon: "mouse"
            title: "Swap primary mouse button"
            Switch {
                checked: Config.mouseSwapButtons
                onToggled: { Config.mouseSwapButtons = !Config.mouseSwapButtons; Config.save(); }
            }
        }
    }

        id: keyboardDialog
        title: "Keyboard"
        
        SettingRow {
            icon: "language"
            title: "Layout"
            
            ComboBox {
                id: layoutCombo
                model: ["us", "gb", "de", "fr"]
                currentIndex: Math.max(0, model.indexOf(Config.keyboardLayout))
                onActivated: (index) => {
                    Config.keyboardLayout = model[index];
                    Config.save();
                }
                
                background: Rectangle {
                    implicitWidth: 160; implicitHeight: 32; color: Theme.alpha(Theme.buttonHover, 0.1); border.color: Theme.alpha(Theme.textForeground, 0.2); border.width: 1; radius: 6
                }
                contentItem: Text {
                    leftPadding: 12; rightPadding: layoutCombo.indicator.width + layoutCombo.spacing; text: layoutCombo.displayText; font.pixelSize: 13; color: Theme.textForeground; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight
                }
                indicator: MaterialIcon {
                    x: layoutCombo.width - width - layoutCombo.rightPadding; y: layoutCombo.topPadding + (layoutCombo.availableHeight - height) / 2; text: "expand_more"; font.pixelSize: 20; color: Theme.iconColor
                }
            }
        }
    }

    DialogPopup {
        id: powerDialog
        title: "Power"
        
        SettingRow {
            icon: "schedule"
            title: "Sleep when idle"
            
            ComboBox {
                id: sleepCombo
                model: ["Never", "15 minutes", "30 minutes", "1 hour"]
                readonly property var sleepVals: [0, 15, 30, 60]
                currentIndex: Math.max(0, sleepVals.indexOf(Config.powerSleepTimeout))
                onActivated: (index) => {
                    Config.powerSleepTimeout = sleepVals[index];
                    Config.save();
                }
                
                background: Rectangle {
                    implicitWidth: 160; implicitHeight: 32; color: Theme.alpha(Theme.buttonHover, 0.1); border.color: Theme.alpha(Theme.textForeground, 0.2); border.width: 1; radius: 6
                }
                contentItem: Text {
                    leftPadding: 12; rightPadding: sleepCombo.indicator.width + sleepCombo.spacing; text: sleepCombo.displayText; font.pixelSize: 13; color: Theme.textForeground; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight
                }
                indicator: MaterialIcon {
                    x: sleepCombo.width - width - sleepCombo.rightPadding; y: sleepCombo.topPadding + (sleepCombo.availableHeight - height) / 2; text: "expand_more"; font.pixelSize: 20; color: Theme.iconColor
                }
            }
        }
    }
    
    Rectangle {
        Layout.fillWidth: true; implicitHeight: content.implicitHeight; color: Theme.alpha(Theme.buttonHover, 0.1); radius: 12; border.color: Theme.alpha(Theme.textForeground, 0.1); border.width: 1
        ColumnLayout {
            id: content; anchors.left: parent.left; anchors.right: parent.right; spacing: 0
            
            SettingRow { 
                icon: "monitor"
                title: "Displays"
                Button { text: "Open"; onClicked: displaysDialog.open() }
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            
            SettingRow { 
            SettingRow { 
                icon: "mouse"
                title: "Mouse and touchpad"
                Button { text: "Open"; onClicked: mouseDialog.open() }
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }

                icon: "keyboard"
                title: "Keyboard"
                Button { text: "Open"; onClicked: keyboardDialog.open() }
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            
            SettingRow { 
                icon: "battery_full"
                title: "Power"
                Button { text: "Open"; onClicked: powerDialog.open() }
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            
            SettingRow {
                icon: "folder"
                title: "Storage management"
                Button {
                    text: "Open Files"
                    onClicked: Config.launchFileManager()
                }
            }
        }
    }
}
