import QtQuick
import QtQuick.Layouts
import qs.themes
import qs.widgets

// Round quick-settings tile with a title and subtitle underneath.
Item {
    id: root
    property string icon
    property string title
    property string subtitle
    property bool active: false
    signal clicked()

    Layout.fillWidth: true
    Layout.preferredWidth: 100
    Layout.alignment: Qt.AlignTop
    implicitHeight: column.implicitHeight

    ColumnLayout {
        id: column
        anchors { left: parent.left; right: parent.right; top: parent.top }
        spacing: 8

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 56
            implicitHeight: 56
            radius: 28
            color: root.active ? Theme.activeTint : Theme.alpha(Theme.buttonHover, 0.2)
            border.color: Theme.hover
            border.width: 1

            MaterialIcon { anchors.centerIn: parent; text: root.icon; font.pixelSize: 24 }

            // Hover overlay
            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: mouse.containsMouse ? Theme.alpha(Theme.buttonHover, 0.2) : "transparent"
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.clicked()
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                Layout.fillWidth: true
                text: root.title
                color: Theme.textForeground
                font.pixelSize: 13
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                text: root.subtitle || " " // keep row height when empty
                color: Theme.textSecondary
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }
        }
    }
}
