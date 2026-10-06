import QtQuick
import qs.themes

// Circular button with a hover highlight and an optional icon glyph.
Rectangle {
    id: root
    property alias icon: glyph.text
    property alias iconSize: glyph.font.pixelSize
    property alias iconColor: glyph.color
    property color baseColor: "transparent"
    readonly property alias hovered: mouse.containsMouse
    signal clicked()

    implicitWidth: 36
    implicitHeight: 36
    radius: width / 2
    color: hovered ? Theme.hover : baseColor

    MaterialIcon { id: glyph; anchors.centerIn: parent }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
