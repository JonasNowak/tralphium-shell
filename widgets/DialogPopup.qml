import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.themes

Popup {
    id: root
    
    property string title: ""
    property var parentWindow: null
    default property alias content: contentItemLayout.data
    
    // Automatically center in parentWindow if provided, else use parent
    x: parentWindow ? (parentWindow.width - width) / 2 : (parent ? (parent.width - width) / 2 : 0)
    y: parentWindow ? (parentWindow.height - height) / 2 : (parent ? (parent.height - height) / 2 : 0)
    
    width: 320
    height: contentContainer.implicitHeight + 48
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    background: Rectangle {
        color: Theme.panelBackground
        radius: 12
        border.color: Theme.panelBorder
        border.width: Theme.panelBorderWidth
    }

    contentItem: ColumnLayout {
        id: contentContainer
        anchors.fill: parent
        anchors.margins: 24
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
