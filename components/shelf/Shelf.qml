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
    implicitHeight: 48 + 8 // add some space for bottom margin
    color: "transparent"

    Card {
        anchors.fill: parent
        anchors.bottomMargin: 8
        anchors.leftMargin: 8
        anchors.rightMargin: 8

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
