import QtQuick
import QtQuick.Layouts
import qs.themes

ColumnLayout {
    id: root
    
    property string text: "Drawer"
    property bool expanded: false
    property var model: []
    
    property var launch: (app) => {}
    property var openMenu: (appId, pos) => {}
    
    spacing: 8
    
    // Header/Button
    Item {
        Layout.fillWidth: true
        implicitHeight: actionBtn.implicitHeight
        
        ActionButton {
            id: actionBtn
            anchors.centerIn: parent
            text: root.text
            onClicked: root.expanded = !root.expanded
        }
    }
    
    // Content
    AppGrid {
        Layout.fillWidth: true
        visible: root.expanded
        model: root.model
        launch: root.launch
        openMenu: root.openMenu
    }
}
