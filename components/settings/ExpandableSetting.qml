import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.themes
import qs.widgets

Rectangle {
    id: root
    property string icon: "settings"
    property string title: "Setting"
    property string subtitle: ""
    property bool expanded: false
    default property alias content: contentItem.data

    Layout.fillWidth: true
    implicitHeight: layout.implicitHeight
    
    color: Theme.alpha(Theme.buttonHover, 0.1)
    radius: 12
    border.color: Theme.alpha(Theme.textForeground, 0.1)
    border.width: 1
    clip: true

    ColumnLayout {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 64
            color: mouseArea.containsMouse ? Theme.hover : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                MaterialIcon { 
                    text: root.icon; 
                    font.pixelSize: 24; 
                    color: Theme.accent 
                    Layout.alignment: Qt.AlignVCenter
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 4
                    Text { text: root.title; color: Theme.textForeground; font.pixelSize: 14; font.bold: true }
                    Text { 
                        text: root.subtitle; 
                        color: Theme.textSecondary; 
                        font.pixelSize: 12;
                        visible: root.subtitle !== ""
                    }
                }

                MaterialIcon { 
                    text: root.expanded ? "expand_less" : "expand_more"
                    font.pixelSize: 24 
                    color: Theme.iconColor
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.expanded = !root.expanded
            }
        }

        Item {
            id: contentWrapper
            Layout.fillWidth: true
            implicitHeight: root.expanded ? contentItem.implicitHeight : 0
            visible: root.expanded
            clip: true
            
            Behavior on implicitHeight {
                NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }

            ColumnLayout {
                id: contentItem
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 0
                // children will be inserted here
            }
        }
    }
}
