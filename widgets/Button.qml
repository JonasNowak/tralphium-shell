import QtQuick
import qs.themes

Rectangle {
    id: root
    
    property string text: ""
    property bool primary: false
    property bool danger: false
    property alias textColor: textItem.color
    
    signal clicked()
    
    implicitWidth: Math.max(80, textItem.implicitWidth + 32)
    implicitHeight: 32
    radius: height / 2
    color: danger ? Theme.accent : (primary ? Theme.activeTint : "transparent")
    border.color: (primary || danger) ? "transparent" : Theme.alpha(Theme.textForeground, 0.2)
    border.width: (primary || danger) ? 0 : 1
    
    Text {
        id: textItem
        anchors.centerIn: parent
        text: root.text
        color: danger ? Theme.shelfBackground : Theme.textForeground
        font.pixelSize: 13
        font.bold: true
    }
    
    Ripple {
        id: ripple
        color: Theme.alpha(danger ? Theme.shelfBackground : Theme.textForeground, 0.2)
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: (mouse) => {
            ripple.start(mouse.x, mouse.y)
            root.clicked()
        }
    }
    
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: mouseArea.containsMouse ? Theme.alpha(Theme.textForeground, 0.1) : "transparent"
        visible: mouseArea.containsMouse
    }
}
