import QtQuick
import QtQuick.Layouts
import qs.themes
import qs.widgets
import qs.services

ColumnLayout {
    property string title: "Accessibility"
    spacing: 12
    Text { text: title; font.pixelSize: 13; font.bold: true; color: Theme.accent; Layout.fillWidth: true; Layout.leftMargin: 4 }
    
    DialogPopup {
        id: accessibilityDialog
        title: "Accessibility features"
        
        SettingRow {
            icon: "contrast"
            title: "High contrast"
            Switch {
                checked: Config.accessibilityHighContrast
                onToggled: { Config.accessibilityHighContrast = !Config.accessibilityHighContrast; Config.save(); }
            }
        }
        SettingRow {
            icon: "mouse"
            title: "Large mouse cursor"
            Switch {
                checked: Config.accessibilityLargeCursor
                onToggled: { Config.accessibilityLargeCursor = !Config.accessibilityLargeCursor; Config.save(); }
            }
        }
        SettingRow {
            icon: "record_voice_over"
            title: "Screen reader"
            Switch {
                checked: Config.accessibilityScreenReader
                onToggled: { Config.accessibilityScreenReader = !Config.accessibilityScreenReader; Config.save(); }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true; implicitHeight: content.implicitHeight; color: Theme.alpha(Theme.buttonHover, 0.1); radius: 12; border.color: Theme.alpha(Theme.textForeground, 0.1); border.width: 1
        ColumnLayout {
            id: content; anchors.left: parent.left; anchors.right: parent.right; spacing: 0
            SettingRow { 
                icon: "accessibility"
                title: "Manage accessibility features"
                Button { text: "Open"; onClicked: accessibilityDialog.open() }
            }
        }
    }
}
