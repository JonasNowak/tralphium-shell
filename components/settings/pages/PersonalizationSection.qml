import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls
import qs.themes
import qs.widgets

import qs.services

ColumnLayout {
    property string title: "Personalization"
    spacing: 12
    Text { text: title; font.pixelSize: 13; font.bold: true; color: Theme.accent; Layout.fillWidth: true; Layout.leftMargin: 4 }
    
    FileDialog {
        id: wallpaperDialog
        title: "Choose a wallpaper"
        nameFilters: ["Images (*.png *.jpg *.jpeg)"]
        onAccepted: {
            Config.setWallpaper(decodeURIComponent(selectedFile.toString().replace("file://", "")));
        }
    }
    
    Rectangle {
        Layout.fillWidth: true; implicitHeight: content.implicitHeight; color: Theme.alpha(Theme.buttonHover, 0.1); radius: 12; border.color: Theme.alpha(Theme.textForeground, 0.1); border.width: 1
        ColumnLayout {
            id: content; anchors.left: parent.left; anchors.right: parent.right; spacing: 0
            
            SettingRow { 
                icon: "wallpaper"
                title: "Wallpaper"
                description: Config.wallpaper !== "" ? Config.wallpaper : "Default"
                
                Button {
                    text: "Change"
                    onClicked: wallpaperDialog.open()
                }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            
            SettingRow {
                icon: "palette"
                title: "System Theme"
                description: "Choose colors that match your style"
                
                ComboBox {
                    id: themeCombo
                    model: ["Nord", "Catppuccin Mocha", "Catppuccin Macchiato", "Catppuccin Frappe", "Catppuccin Latte", "Kanagawa", "One Dark", "One Light"]
                    readonly property var themeIds: ["nord", "catppuccin-mocha", "catppuccin-macchiato", "catppuccin-frappe", "catppuccin-latte", "kanagawa", "one-dark", "one-light"]
                    
                    currentIndex: Math.max(0, themeIds.indexOf(Config.theme))
                    onActivated: (index) => Config.setTheme(themeIds[index])
                    
                    background: Rectangle {
                        implicitWidth: 160
                        implicitHeight: 32
                        color: Theme.alpha(Theme.buttonHover, 0.1)
                        border.color: Theme.alpha(Theme.textForeground, 0.2)
                        border.width: 1
                        radius: 6
                    }
                    
                    contentItem: Text {
                        leftPadding: 12
                        rightPadding: themeCombo.indicator.width + themeCombo.spacing
                        text: themeCombo.displayText
                        font.pixelSize: 13
                        color: Theme.textForeground
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    
                    indicator: MaterialIcon {
                        x: themeCombo.width - width - themeCombo.rightPadding
                        y: themeCombo.topPadding + (themeCombo.availableHeight - height) / 2
                        text: "expand_more"
                        font.pixelSize: 20
                        color: Theme.iconColor
                    }
                }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            
            SettingRow {
                icon: "dock"
                title: "Menu Bar"
                description: "Show a panel at the top of the screen"
                Switch { checked: Config.menuBar; onToggled: Config.toggleMenuBar() }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }

            SettingRow {
                icon: "call_to_action"
                title: "Auto-hide shelf"
                description: "Automatically hide the shelf when not in use"
                Switch { 
                    checked: Config.shelfAutoHide; 
                    onToggled: {
                        Config.shelfAutoHide = !Config.shelfAutoHide;
                        Config.save();
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }

            SettingRow {
                icon: "align_horizontal_center"
                title: "Shelf Position"
                description: "Where to show the shelf"
                
                ComboBox {
                    id: positionCombo
                    model: ["Bottom", "Left", "Right"]
                    readonly property var positionIds: ["bottom", "left", "right"]
                    
                    currentIndex: Math.max(0, positionIds.indexOf(Config.shelfPosition))
                    onActivated: (index) => {
                        Config.shelfPosition = positionIds[index];
                        Config.save();
                    }
                    
                    background: Rectangle {
                        implicitWidth: 160
                        implicitHeight: 32
                        color: Theme.alpha(Theme.buttonHover, 0.1)
                        border.color: Theme.alpha(Theme.textForeground, 0.2)
                        border.width: 1
                        radius: 6
                    }
                    
                    contentItem: Text {
                        leftPadding: 12
                        rightPadding: positionCombo.indicator.width + positionCombo.spacing
                        text: positionCombo.displayText
                        font.pixelSize: 13
                        color: Theme.textForeground
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    
                    indicator: MaterialIcon {
                        x: positionCombo.width - width - positionCombo.rightPadding
                        y: positionCombo.topPadding + (positionCombo.availableHeight - height) / 2
                        text: "expand_more"
                        font.pixelSize: 20
                        color: Theme.iconColor
                    }
                }
            }
        }
    }
}
