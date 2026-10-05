import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.themes

import qs.widgets

// Bottom shelf: launcher button, centered taskbar and status area.
PanelWindow {
    id: root
    signal launcherClicked()
    signal statusClicked()
    signal backgroundClicked()

    anchors {
        bottom: true
        left: true
        right: true
    }
    implicitHeight: 48
    color: "transparent"

    Card {
        anchors.fill: parent

        // Square off the bottom corners
        Rectangle {
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
            height: Theme.panelRadius
            color: parent.color
        }

        onClicked: {
            taskbar.closeMenu();
            root.backgroundClicked();
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            spacing: 8

            LauncherButton { onClicked: root.launcherClicked() }
            Item { Layout.fillWidth: true }
            StatusArea { onClicked: root.statusClicked() }
        }

        Taskbar {
            id: taskbar
            anchors.centerIn: parent
            panelWindow: root
        }
    }
}
