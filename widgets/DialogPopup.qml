import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.themes

Popup {
    id: root
    
    property string title: ""
    property var parentWindow: null
    default property alias content: contentItemLayout.data
    
    anchors.centerIn: Overlay.overlay
    
    width: 320
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    padding: 24
    
    background: Rectangle {
        color: Theme.panelBackground
        radius: 12
        border.color: Theme.panelBorder
        border.width: Theme.panelBorderWidth
    }

    contentItem: ColumnLayout {
        id: contentContainer
        spacing: 16

        Text {
            visible: root.title !== ""
            text: root.title
            font.pixelSize: 18
            font.bold: true
            color: Theme.textForeground
            Layout.fillWidth: true
        }

        ColumnLayout {
            id: contentItemLayout
            Layout.fillWidth: true
            spacing: 16
        }
    }
}
