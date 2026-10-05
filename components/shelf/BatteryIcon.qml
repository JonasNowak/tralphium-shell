import QtQuick
import qs.services
import qs.themes

// Battery glyph; the fill animates towards full while charging.
Item {
    implicitWidth: 20
    implicitHeight: 12

    // Body
    Rectangle {
        anchors.fill: parent
        anchors.rightMargin: 2
        color: "transparent"
        border.color: Theme.textForeground
        border.width: 1
        radius: 2

        Rectangle {
            id: level
            readonly property real fullWidth: parent.width - 2
            readonly property real levelWidth: Math.max(0, fullWidth * Battery.capacity / 100)
            property real chargeWidth: levelWidth

            anchors { left: parent.left; top: parent.top; bottom: parent.bottom; margins: 1 }
            radius: 1
            width: Battery.charging ? chargeWidth : levelWidth
            color: Battery.capacity <= 20 && !Battery.charging ? Theme.danger : Theme.textForeground

            SequentialAnimation on chargeWidth {
                running: Battery.charging
                loops: Animation.Infinite
                NumberAnimation { from: level.levelWidth; to: level.fullWidth; duration: 1500; easing.type: Easing.InOutQuad }
                PauseAnimation { duration: 500 }
            }
        }
    }

    // Tip
    Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 2
        height: 4
        radius: 1
        color: Theme.textForeground
    }
}
