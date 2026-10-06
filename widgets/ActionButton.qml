import QtQuick
import qs.themes

Rectangle {
    id: root
    property string text: ""
    property string icon: ""
    signal clicked()

    implicitWidth: textItem.implicitWidth + 24
    implicitHeight: 32
    radius: 16
    color: mouseArea.containsMouse ? Theme.hover : "transparent"
    border.color: Theme.alpha(Theme.textForeground, 0.2)
    border.width: 1

    Text {
        id: textItem
        anchors.centerIn: parent
        text: root.text
        color: Theme.textForeground
        font.pixelSize: 13
        font.bold: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
