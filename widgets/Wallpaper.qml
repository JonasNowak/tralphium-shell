import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    WlrLayershell.layer: WlrLayer.Background
    color: "black"
    
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    
    property string source: ""
    
    Rectangle {
        anchors.fill: parent
        color: "black"
        
        Image {
            anchors.fill: parent
            source: root.source !== "" ? "file://" + root.source : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            onStatusChanged: {
                if (status === Image.Error) {
                    console.log("Failed to load wallpaper:", source);
                } else if (status === Image.Ready) {
                    console.log("Wallpaper loaded successfully:", source);
                }
            }
        }
    }
}
