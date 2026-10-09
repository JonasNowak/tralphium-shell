import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Window {
    width: 600
    height: 400
    visible: true

    Rectangle {
        id: rect
        width: 300
        implicitHeight: networkCol.implicitHeight
        color: "blue"
        
        ColumnLayout {
            id: networkCol
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 0
            
            Item { Layout.fillWidth: true; implicitHeight: 72; Rectangle { anchors.fill: parent; color: "red" } }
            Item { Layout.fillWidth: true; implicitHeight: 72; Rectangle { anchors.fill: parent; color: "green" } }
        }
    }
    
    Timer {
        interval: 500
        running: true
        onTriggered: {
            console.log("Rectangle height -> " + rect.height)
            console.log("networkCol height -> " + networkCol.height)
            console.log("networkCol implicitHeight -> " + networkCol.implicitHeight)
            Qt.quit()
        }
    }
}
