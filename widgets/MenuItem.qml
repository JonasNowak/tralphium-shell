import QtQuick
import QtQuick.Layouts
import qs.themes

// Single row in a MenuCard: optional icon, label and optional check mark.
Rectangle {
    id: root
    property alias icon: glyph.text
    property alias text: label.text
    property bool checked: false
    signal clicked()

    Layout.fillWidth: true
    implicitHeight: 36
    radius: 8
    color: mouse.containsMouse ? Theme.hover : "transparent"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        MaterialIcon { id: glyph; visible: text !== "" }

        Text {
            id: label
            Layout.fillWidth: true
            color: Theme.textForeground
            font.pixelSize: 14
            font.bold: root.checked
            elide: Text.ElideRight
        }

        MaterialIcon { text: "check"; font.pixelSize: 18; visible: root.checked }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
