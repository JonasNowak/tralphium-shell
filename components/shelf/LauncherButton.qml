import QtQuick
import qs.themes
import qs.widgets

// Chrome OS style launcher: a ring with a dot.
IconButton {
    baseColor: Theme.buttonBackground

    Rectangle {
        anchors.centerIn: parent
        width: 14
        height: 14
        radius: 7
        color: "transparent"
        border.color: Theme.iconColor
        border.width: 2

        Rectangle {
            anchors.centerIn: parent
            width: 4
            height: 4
            radius: 2
            color: Theme.iconColor
        }
    }
}
