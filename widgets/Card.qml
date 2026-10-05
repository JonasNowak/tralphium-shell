import QtQuick
import qs.themes

// Themed surface (panels, menus, tooltips). Swallows clicks so they
// don't fall through to an Overlay's dismiss area; emits clicked().
Rectangle {
    id: root
    signal clicked()

    color: Theme.alpha(Theme.shelfBackground, Theme.shelfOpacity)
    radius: 12
    border.color: Theme.hover
    border.width: 1

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
