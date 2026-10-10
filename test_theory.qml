import QtQuick
import Quickshell

PanelWindow {
    property string source: "HELLO"
    
    Component.onCompleted: {
        console.log("PanelWindow source:", source);
    }
    
    Item {
        Component.onCompleted: {
            console.log("Item parent.source:", parent.source);
        }
    }
}
