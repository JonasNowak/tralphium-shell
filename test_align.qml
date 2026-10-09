import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Window {
    width: 400
    height: 300
    visible: true

    ColumnLayout {
        anchors.fill: parent
        
        RowLayout {
            Layout.fillWidth: true
            
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                
                Text { text: "Short"; Layout.fillWidth: true; color: "red" }
                Text { text: "Longer text here"; Layout.fillWidth: true; color: "blue" }
                Text { text: "Very very very long text"; Layout.fillWidth: true; color: "green" }
            }
        }
    }
    
    Component.onCompleted: {
        Qt.quit()
    }
}
