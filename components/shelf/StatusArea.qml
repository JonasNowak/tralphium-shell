import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.themes
import qs.widgets
import qs.services

GridLayout {
    id: root
    property bool isVertical: false
    flow: isVertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
    signal clicked()
    rowSpacing: 3.5; columnSpacing: 3.5

    readonly property bool isHovered: dateMouse.containsMouse || mainMouse.containsMouse

    property bool isActive: false
    readonly property bool _highlight: isHovered || isActive

    SystemClock { id: clock; precision: SystemClock.Minutes }

    Rectangle {
        id: datePill
        implicitHeight: root.isVertical ? dateText.implicitHeight + 24 : 36
        implicitWidth: root.isVertical ? 36 : dateText.implicitWidth + 24
        
        topLeftRadius: 18
        topRightRadius: root.isVertical ? 18 : 4
        bottomLeftRadius: root.isVertical ? 4 : 18
        bottomRightRadius: 4
        
        color: root._highlight ? Theme.hover : Theme.alpha(Theme.buttonHover, 0.3)

        Text {
            id: dateText
            anchors.centerIn: parent
            text: Qt.formatDate(clock.date, root.isVertical ? "dd\nMMM" : "MMM d")
            color: Theme.textForeground
            font.pixelSize: 13
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
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
        implicitHeight: root.isVertical ? row.implicitHeight + 24 : 36
        implicitWidth: root.isVertical ? 36 : row.implicitWidth + 24
        
        topLeftRadius: root.isVertical ? 4 : 4
        topRightRadius: root.isVertical ? 4 : 18
        bottomLeftRadius: root.isVertical ? 18 : 4
        bottomRightRadius: 18
        
        color: root._highlight ? Theme.hover : Theme.alpha(Theme.buttonHover, 0.3)

        GridLayout {
            id: row
            anchors.centerIn: parent
            flow: root.isVertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
            rowSpacing: 12; columnSpacing: 12

            Text {
                text: Qt.formatTime(clock.date, root.isVertical ? "hh\nmm" : "h:mm")
                color: Theme.textForeground
                font.pixelSize: 13
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
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
