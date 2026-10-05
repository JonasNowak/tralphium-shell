import QtQuick
import Quickshell

// Fullscreen transparent layer used by popups (launchpad, control panel,
// power menu). Clicking outside the content emits backgroundClicked().
PanelWindow {
    id: root
    signal backgroundClicked()

    function open() { visible = true; }
    function close() { visible = false; }
    function toggle() { visible = !visible; }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"
    visible: false
    focusable: true

    MouseArea {
        anchors.fill: parent
        onClicked: root.backgroundClicked()
        onWheel: wheel => {} // Don't scroll windows beneath
    }
}
