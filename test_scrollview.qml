import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 600
    height: 400
    visible: true

    ScrollView {
        id: sv
        anchors.fill: parent
        
        ColumnLayout {
            width: sv.width - 64
            anchors.horizontalCenter: parent.horizontalCenter
            
            Rectangle {
                Layout.fillWidth: true
                height: 100
                color: "red"
            }
        }
    }
    
    Timer {
        interval: 1000
        running: true
        onTriggered: {
            console.log("ColumnLayout width -> " + sv.contentItem.children[0].width)
            Qt.quit()
        }
    }
}
