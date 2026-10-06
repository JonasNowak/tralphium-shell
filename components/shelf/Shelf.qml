import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
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
            shelfContextMenu.visible = false;
            root.backgroundClicked();
        }

        onRightClicked: (mouse) => {
            taskbar.closeMenu();
            shelfContextMenu.anchor.rect = Qt.rect(mouse.x, mouse.y, 1, 1);
            shelfContextMenu.visible = !shelfContextMenu.visible;
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

    PopupWindow {
        id: shelfContextMenu
        anchor.window: root
        anchor.edges: Edges.Top
        grabFocus: true
        color: "transparent"
        visible: false
        implicitWidth: shelfMenu.implicitWidth
        implicitHeight: shelfMenu.implicitHeight

        MenuCard {
            id: shelfMenu
            anchors.fill: parent

            MenuItem {
                icon: "terminal"
                text: "Terminal"
                onClicked: {
                    Quickshell.execDetached(["kitty"]);
                    shelfContextMenu.visible = false;
                }
            }
            MenuItem {
                icon: "speed"
                text: "Task Manager"
                onClicked: {
                    Quickshell.execDetached(["kitty", "-e", "btop"]);
                    shelfContextMenu.visible = false;
                }
            }
            MenuItem {
                icon: "folder"
                text: "Files"
                onClicked: {
                    Quickshell.execDetached(["kitty", "-e", "yazi"]);
                    shelfContextMenu.visible = false;
                }
            }
        }
    }
}
