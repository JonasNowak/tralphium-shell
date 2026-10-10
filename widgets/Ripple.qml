import QtQuick
import qs.themes

Item {
    id: root
    anchors.fill: parent
    clip: true

    property color color: Theme.alpha(Theme.textForeground, 0.1)

    function start(x, y) {
        let maxRadius = Math.sqrt(Math.pow(width, 2) + Math.pow(height, 2))
        
        let comp = Qt.createComponent("RippleEffect.qml")
        if (comp.status === Component.Ready) {
            let obj = comp.createObject(root, {
                "x": x,
                "y": y,
                "color": root.color,
                "targetRadius": maxRadius
            })
        }
    }
}
