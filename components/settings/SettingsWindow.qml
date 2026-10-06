import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services
import qs.themes
import qs.widgets

Overlay {
    id: root
    
    // Consume clicks to close when clicking outside the card
    onBackgroundClicked: close()

    property int currentTab: 0
    Card {
        width: 800
        height: 600
        anchors.centerIn: parent
        onClicked: {} // Consume clicks inside the window so it doesn't close

        RowLayout {
            anchors.fill: parent
            spacing: 0

            // Left Sidebar
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: 240
                color: Theme.alpha(Theme.buttonHover, 0.05) // subtle background
                radius: Theme.panelRadius
                
                // hide right radius to blend with content
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: Theme.panelRadius
                    color: parent.color
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8

                    Text {
                        text: "Settings"
                        font.pixelSize: 22
                        font.bold: true
                        color: Theme.textForeground
                        Layout.bottomMargin: 16
                        Layout.leftMargin: 8
                    }

                    Repeater {
                        model: [
                            { name: "Shell", icon: "terminal" }
                        ]
                        delegate: Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 48
                            radius: 24
                            color: root.currentTab === index ? Theme.alpha(Theme.activeTint, 0.2) : "transparent"
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 12
                                MaterialIcon { text: modelData.icon; color: root.currentTab === index ? Theme.accent : Theme.textForeground; font.pixelSize: 22 }
                                Text { 
                                    text: modelData.name
                                    color: root.currentTab === index ? Theme.accent : Theme.textForeground
                                    font.pixelSize: 14
                                    font.bold: true
                                    Layout.fillWidth: true
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: root.currentTab = index
                            }
                        }
                    }

                    Item { Layout.fillHeight: true } // spacer
                }
            }

            // Vertical Divider
            Rectangle {
                Layout.fillHeight: true
                width: 1
                color: Theme.alpha(Theme.textForeground, 0.1)
            }

            // Right Content
            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 24
                
                // Top area with search
                RowLayout {
                    Layout.fillWidth: true
                    implicitHeight: 72
                    spacing: 0

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    IconButton {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: 16
                        icon: "close"
                        onClicked: root.close()
                    }
                }

                StackLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: root.currentTab

                    // Tab 0: Shell Settings
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                        
                        ColumnLayout {
                            width: parent.width - 64
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 24
                            
                            // Expandable Appearance section
                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: appearanceCol.implicitHeight
                                color: Theme.alpha(Theme.buttonHover, 0.1)
                                radius: 12
                                border.color: Theme.alpha(Theme.textForeground, 0.1)
                                border.width: 1
                                clip: true
                                
                                ColumnLayout {
                                    id: appearanceCol
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    spacing: 0
                                    
                                    // Expandable Header
                                    Rectangle {
                                        id: appearanceHeader
                                        Layout.fillWidth: true
                                        implicitHeight: 64
                                        color: appearanceMouse.containsMouse ? Theme.hover : "transparent"
                                        
                                        property bool expanded: true
                                        
                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: 16
                                            spacing: 16
                                            
                                            MaterialIcon { 
                                                text: "palette" 
                                                font.pixelSize: 24 
                                                color: Theme.accent 
                                                Layout.alignment: Qt.AlignVCenter 
                                            }
                                            
                                            ColumnLayout {
                                                Layout.fillWidth: true
                                                Layout.alignment: Qt.AlignVCenter
                                                spacing: 4
                                                Text { text: "Appearance & Behavior"; color: Theme.textForeground; font.pixelSize: 14; font.bold: true }
                                                Text { text: "Theme and top bar visibility"; color: Theme.textSecondary; font.pixelSize: 12 }
                                            }
                                            
                                            MaterialIcon { 
                                                text: appearanceHeader.expanded ? "expand_less" : "expand_more"
                                                font.pixelSize: 24 
                                                color: Theme.iconColor
                                                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                                            }
                                        }
                                        
                                        MouseArea {
                                            id: appearanceMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onClicked: appearanceHeader.expanded = !appearanceHeader.expanded
                                        }
                                    }
                                    
                                    // Expandable Content
                                    Item {
                                        Layout.fillWidth: true
                                        implicitHeight: appearanceHeader.expanded ? appearanceContent.implicitHeight : 0
                                        visible: appearanceHeader.expanded
                                        clip: true
                                        Behavior on implicitHeight { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
                                        
                                        ColumnLayout {
                                            id: appearanceContent
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            spacing: 0
                                            
                                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1) }
                                            
                                            // Theme Setting Row
                                            Item {
                                                Layout.fillWidth: true
                                                implicitHeight: 72
                                                
                                                RowLayout {
                                                    anchors.fill: parent
                                                    anchors.margins: 16
                                                    anchors.leftMargin: 56 // align with text
                                                    spacing: 16
                                                    
                                                    Text { 
                                                        text: "System Theme"
                                                        color: Theme.textForeground
                                                        font.pixelSize: 14
                                                        Layout.fillWidth: true
                                                    }
                                                    
                                                    ComboBox {
                                                        id: themeCombo
                                                        model: [
                                                            "Nord", 
                                                            "Catppuccin Mocha", 
                                                            "Catppuccin Macchiato", 
                                                            "Catppuccin Frappe", 
                                                            "Catppuccin Latte", 
                                                            "Kanagawa", 
                                                            "One Dark", 
                                                            "One Light"
                                                        ]
                                                        
                                                        readonly property var themeIds: [
                                                            "nord",
                                                            "catppuccin-mocha",
                                                            "catppuccin-macchiato",
                                                            "catppuccin-frappe",
                                                            "catppuccin-latte",
                                                            "kanagawa",
                                                            "one-dark",
                                                            "one-light"
                                                        ]
                                                        
                                                        currentIndex: Math.max(0, themeIds.indexOf(Config.theme))
                                                        onActivated: (index) => Config.setTheme(themeIds[index])
                                                        
                                                        background: Rectangle {
                                                            implicitWidth: 190
                                                            implicitHeight: 32
                                                            radius: 16
                                                            color: themeCombo.pressed ? Theme.hover : Theme.alpha(Theme.buttonHover, 0.2)
                                                            border.color: Theme.alpha(Theme.textForeground, 0.2)
                                                            border.width: 1
                                                        }
                                                        
                                                        contentItem: Text {
                                                            leftPadding: 16
                                                            rightPadding: 32
                                                            text: themeCombo.displayText
                                                            color: Theme.textForeground
                                                            font.pixelSize: 13
                                                            font.bold: true
                                                            verticalAlignment: Text.AlignVCenter
                                                        }

                                                        indicator: MaterialIcon {
                                                            x: themeCombo.width - width - 8
                                                            y: (themeCombo.height - height) / 2
                                                            text: "expand_more"
                                                            color: Theme.textForeground
                                                        }

                                                        delegate: ItemDelegate {
                                                            width: themeCombo.width - 16
                                                            height: 32
                                                            contentItem: Text {
                                                                text: modelData
                                                                color: Theme.textForeground
                                                                font.pixelSize: 13
                                                                font.bold: parent.highlighted
                                                                verticalAlignment: Text.AlignVCenter
                                                                leftPadding: 8
                                                            }
                                                            background: Rectangle {
                                                                color: parent.highlighted ? Theme.hover : "transparent"
                                                                radius: 8
                                                            }
                                                        }

                                                        popup: Popup {
                                                            y: themeCombo.height + 4
                                                            width: themeCombo.width
                                                            padding: 8
                                                            
                                                            contentItem: ListView {
                                                                clip: true
                                                                implicitHeight: contentHeight
                                                                model: themeCombo.popup.visible ? themeCombo.delegateModel : null
                                                                currentIndex: themeCombo.highlightedIndex
                                                            }
                                                            
                                                            background: Rectangle {
                                                                color: Theme.panelBackground
                                                                border.color: Theme.panelBorder
                                                                border.width: Theme.panelBorderWidth
                                                                radius: Theme.panelRadius
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 56 }
                                            
                                            // Top Bar Setting Row
                                            Item {
                                                Layout.fillWidth: true
                                                implicitHeight: 72
                                                
                                                RowLayout {
                                                    anchors.fill: parent
                                                    anchors.margins: 16
                                                    anchors.leftMargin: 56
                                                    spacing: 16
                                                    
                                                    Text { 
                                                        text: "Menu Bar"
                                                        color: Theme.textForeground
                                                        font.pixelSize: 14
                                                        Layout.fillWidth: true
                                                    }
                                                    
                                                    // Custom Switch
                                                    Rectangle {
                                                        width: 44
                                                        height: 24
                                                        radius: 12
                                                        color: Config.menuBar ? Theme.activeTint : Theme.alpha(Theme.textForeground, 0.2)
                                                        
                                                        Rectangle {
                                                            width: 20
                                                            height: 20
                                                            radius: 10
                                                            color: Theme.textForeground
                                                            x: Config.menuBar ? 22 : 2
                                                            y: 2
                                                            Behavior on x { NumberAnimation { duration: 150 } }
                                                        }
                                                        
                                                        MouseArea {
                                                            anchors.fill: parent
                                                            onClicked: Config.toggleMenuBar()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Item { height: 32 } // Bottom padding
                        }
                    }

                }
            }
        }
    }
}
