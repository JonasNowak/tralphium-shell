import QtQuick
import qs.themes
import qs.widgets

// Single taskbar entry: app icon, running/active indicator, hover highlight.
Rectangle {
    id: root
    property string appId
    property string name
    property bool running: false
    property bool active: false
    readonly property alias hovered: mouse.containsMouse
    signal clicked(int button)

    implicitWidth: 44
    implicitHeight: 44
    radius: 22
    color: hovered ? Theme.hover : "transparent"

    AppIcon {
        anchors.centerIn: parent
        width: 32
        height: 32
        name: root.name
        source: root.appId ? "image://icon/" + root.appId.toLowerCase() : ""
        fallbackSource: root.appId ? "image://icon/" + root.appId : ""
    }

    // Running indicator
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        anchors.horizontalCenter: parent.horizontalCenter
        visible: root.running
        width: root.active ? 12 : 4
        height: 2
        radius: 1
        color: root.active ? Theme.indicatorActive : Theme.indicatorInactive
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: event => root.clicked(event.button)
    }
}
