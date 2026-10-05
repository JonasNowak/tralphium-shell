import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.themes
import qs.widgets

// Pill on the right of the shelf: network, battery and clock.
Rectangle {
    id: root
    signal clicked()

    implicitHeight: 36
    implicitWidth: row.implicitWidth + 32
    radius: 18
    color: mouse.containsMouse ? Theme.hover : Theme.alpha(Theme.buttonHover, 0.3)

    SystemClock { id: clock; precision: SystemClock.Minutes }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 12

        MaterialIcon { text: "wifi"; font.pixelSize: 16 }

        BatteryIcon {}

        Text {
            text: Qt.formatTime(clock.date, "hh:mm")
            color: Theme.textForeground
            font.pixelSize: 14
            font.bold: true
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
