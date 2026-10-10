import QtQuick

Rectangle {
    id: effect
    property real targetRadius: 100
    
    width: 0
    height: 0
    radius: width / 2
    
    transform: Translate { x: -width / 2; y: -height / 2 }
    
    SequentialAnimation {
        running: true
        ParallelAnimation {
            NumberAnimation {
                target: effect
                property: "width"
                to: targetRadius * 2
                duration: 400
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: effect
                property: "height"
                to: targetRadius * 2
                duration: 400
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: effect
                property: "opacity"
                from: 0.5
                to: 0
                duration: 400
            }
        }
        ScriptAction { script: effect.destroy() }
    }
}
