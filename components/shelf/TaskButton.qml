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
    property string icon: ""
    readonly property alias hovered: mouse.containsMouse

    signal clicked(int button)
    signal appEntered(string draggedAppId)


    implicitWidth: 44
    implicitHeight: 44
    radius: 22
    color: hovered ? Theme.hover : "transparent"

    AppIcon {
        anchors.centerIn: parent
        width: 32
        height: 32
        name: root.name
        source: root.icon ? root.icon : (root.appId ? "image://icon/" + root.appId.toLowerCase() : "")
        fallbackSource: root.appId ? "image://icon/" + root.appId : ""
        opacity: mouse.drag.active ? 0.3 : 1.0
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
        drag.target: dragItem
        drag.threshold: 0
        onClicked: event => root.clicked(event.button)
    }

    Item {
        id: dragItem
        width: root.width
        height: root.height
        Drag.active: mouse.drag.active
        Drag.keys: ["taskbar-app"]
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2
        property string appId: root.appId
        
        AppIcon {
            anchors.centerIn: parent
            width: 32
            height: 32
            name: root.name
            source: root.icon ? root.icon : (root.appId ? "image://icon/" + root.appId.toLowerCase() : "")
            fallbackSource: root.appId ? "image://icon/" + root.appId : ""
            visible: mouse.drag.active
            opacity: 1.0
        }

        Behavior on x { enabled: !mouse.drag.active; NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
        Behavior on y { enabled: !mouse.drag.active; NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

        states: State {
            name: "dragging"
            when: mouse.drag.active
        }
        
        onStateChanged: {
            if (state === "") {
                x = 0;
                y = 0;
            }
        }
    }

    DropArea {
        anchors.fill: parent
        keys: ["taskbar-app"]
        onEntered: (drag) => {
            if (drag.source && drag.source.appId && drag.source.appId !== root.appId) {
                root.appEntered(drag.source.appId)
            }
        }
    }
}
