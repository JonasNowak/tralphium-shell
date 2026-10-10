import QtQuick
import QtQuick.Layouts
import qs.themes

Item {
    id: root
    
    property string title: ""
    property string description: ""
    property int leftMargin: 16
    
    property string icon: ""
    
    default property alias control: controlContainer.data
    
    Layout.fillWidth: true
    implicitHeight: 72
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        anchors.leftMargin: root.leftMargin
        spacing: 16
        
        MaterialIcon {
            visible: root.icon !== ""
            text: root.icon
            font.pixelSize: 20
            color: Theme.iconColor
            Layout.alignment: Qt.AlignVCenter
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 4
            
            Text { 
                text: root.title
                color: Theme.textForeground
                font.pixelSize: 14
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
            
            Text {
                visible: root.description !== ""
                text: root.description
                color: Theme.textSecondary
                font.pixelSize: 12
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
        }
        
        Item {
            id: controlContainer
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }
}
