import QtQuick
import qs.themes
import qs.widgets

GridView {
    id: grid
    
    // Make the grid size to its content
    implicitHeight: contentHeight
    interactive: false // Let the parent scroll view handle scrolling
    
    cellWidth: 110
    cellHeight: 110
    
    property var launch: (app) => {}
    property var openMenu: (appId, pos) => {}
    
    delegate: Item {
        width: grid.cellWidth
        height: grid.cellHeight

        Rectangle {
            anchors.fill: parent
            anchors.margins: 8
            radius: 8
            color: mouse.containsMouse ? Theme.hover : "transparent"

            AppIcon {
                id: icon
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.horizontalCenter: parent.horizontalCenter
                width: 48
                height: 48
                source: modelData.icon
                name: modelData.name
                initialsSize: 20
            }

            Text {
                anchors { top: icon.bottom; left: parent.left; right: parent.right; topMargin: 8; leftMargin: 4; rightMargin: 4 }
                text: modelData.name
                color: Theme.textForeground
                font.pixelSize: 13
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: event => {
                    if (event.button === Qt.RightButton) {
                        grid.openMenu(modelData.id, mapToItem(null, event.x, event.y));
                    } else {
                        grid.launch(modelData);
                    }
                }
            }
        }
    }
}
