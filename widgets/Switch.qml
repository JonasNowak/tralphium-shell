import QtQuick
import qs.themes

Rectangle {
    id: root
    
    property bool checked: false
    signal toggled()
    
    width: 44
    height: 24
    radius: 12
    color: checked ? Theme.activeTint : Theme.alpha(Theme.textForeground, 0.2)
    
    Rectangle {
        width: 20
        height: 20
        radius: 10
        color: Theme.textForeground
        x: root.checked ? 22 : 2
        y: 2
        
        Behavior on x { 
            NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } 
        }
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.toggled();
        }
    }
}
