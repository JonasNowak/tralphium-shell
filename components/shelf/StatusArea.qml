import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.themes
import qs.widgets
import qs.services

// Pills on the right of the shelf: date, and network/battery/clock.
RowLayout {
    id: root
    signal clicked()
    spacing: 3.5

    readonly property bool isHovered: dateMouse.containsMouse || mainMouse.containsMouse

    property bool isActive: false
    readonly property bool _highlight: isHovered || isActive

    SystemClock { id: clock; precision: SystemClock.Minutes }

    Rectangle {
        id: datePill
        implicitHeight: 36
        implicitWidth: dateText.implicitWidth + 24
        
        topLeftRadius: 18
        bottomLeftRadius: 18
        topRightRadius: 4
        bottomRightRadius: 4
        
        color: root._highlight ? Theme.hover : Theme.alpha(Theme.buttonHover, 0.3)

        Text {
            id: dateText
            anchors.centerIn: parent
            text: Qt.formatDate(clock.date, "MMM d")
            color: Theme.textForeground
            font.pixelSize: 13
            font.bold: true
        }

        MouseArea {
            id: dateMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.clicked()
        }
    }

    Rectangle {
        id: mainPill
        implicitHeight: 36
        implicitWidth: row.implicitWidth + 24
        
        topLeftRadius: 4
        bottomLeftRadius: 4
        topRightRadius: 18
        bottomRightRadius: 18
        
        color: root._highlight ? Theme.hover : Theme.alpha(Theme.buttonHover, 0.3)

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: 12

            Text {
                text: Qt.formatTime(clock.date, "h:mm")
                color: Theme.textForeground
                font.pixelSize: 13
                font.bold: true
            }

            Rectangle {
                visible: NotificationService.server.trackedNotifications.values.length > 0
                width: 20
                height: 20
                radius: 10
                color: Theme.textForeground
                
                Text {
                    anchors.centerIn: parent
                    text: NotificationService.server.trackedNotifications.values.length.toString()
                    color: Theme.panelBackground
                    font.pixelSize: 12
                    font.bold: true
                }
            }

            MaterialIcon { text: "wifi"; font.pixelSize: 16 }

            BatteryIcon {}
        }

        MouseArea {
            id: mainMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.clicked()
        }
    }
}
