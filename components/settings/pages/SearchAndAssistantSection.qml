import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.themes
import qs.widgets
import qs.services

ColumnLayout {
    property string title: "Search and Assistant"
    spacing: 12
    Text { text: title; font.pixelSize: 13; font.bold: true; color: Theme.accent; Layout.fillWidth: true; Layout.leftMargin: 4 }
    
    Rectangle {
        Layout.fillWidth: true; implicitHeight: content.implicitHeight; color: Theme.alpha(Theme.buttonHover, 0.1); radius: 12; border.color: Theme.alpha(Theme.textForeground, 0.1); border.width: 1
        ColumnLayout {
            id: content; anchors.left: parent.left; anchors.right: parent.right; spacing: 0
            
            SettingRow { 
                icon: "search"
                title: "Preferred search engine"
                description: Config.searchEngine
                
                ComboBox {
                    id: searchCombo
                    model: ["Google", "DuckDuckGo", "Bing", "Yahoo"]
                    
                    currentIndex: Math.max(0, model.indexOf(Config.searchEngine))
                    onActivated: (index) => {
                        Config.searchEngine = model[index];
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
                        rightPadding: searchCombo.indicator.width + searchCombo.spacing
                        text: searchCombo.displayText
                        font.pixelSize: 13
                        color: Theme.textForeground
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    
                    indicator: MaterialIcon {
                        x: searchCombo.width - width - searchCombo.rightPadding
                        y: searchCombo.topPadding + (searchCombo.availableHeight - height) / 2
                        text: "expand_more"
                        font.pixelSize: 20
                        color: Theme.iconColor
                    }
                }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            
            SettingRow { 
                icon: "mic"
                title: "Voice Assistant"
                description: Config.voiceAssistantEnabled ? "On" : "Off"
                
                Switch {
                    checked: Config.voiceAssistantEnabled
                    onToggled: {
                        Config.voiceAssistantEnabled = !Config.voiceAssistantEnabled;
                        Config.save();
                    }
                }
            }
        }
    }
}
