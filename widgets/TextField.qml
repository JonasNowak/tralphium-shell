import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.themes

TextField {
    id: root
    
    Layout.fillWidth: true
    Layout.preferredHeight: 40
    
    color: Theme.textForeground
    placeholderTextColor: Theme.textSecondary
    leftPadding: 12
    rightPadding: 12
    
    background: Rectangle {
        color: Theme.alpha(Theme.buttonHover, 0.1)
        radius: 6
        border.color: root.activeFocus ? Theme.activeTint : Theme.alpha(Theme.textForeground, 0.2)
        border.width: root.activeFocus ? 2 : 1
    }
}
