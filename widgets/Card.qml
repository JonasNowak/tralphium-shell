import QtQuick
import qs.themes

// Themed surface (panels, menus, tooltips). Swallows clicks so they
// don't fall through to an Overlay's dismiss area; emits clicked().
Rectangle {
    id: root
    signal clicked()
    signal rightClicked(var mouse)

    color: Theme.panelBackground
    radius: Theme.panelRadius
    border.color: Theme.panelBorder
    border.width: Theme.panelBorderWidth

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                root.rightClicked(mouse)
            } else {
                root.clicked()
            }
        }
    }
}
