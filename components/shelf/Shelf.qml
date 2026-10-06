import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.themes
import qs.widgets
import qs.services

// Bottom shelf: launcher button, centered taskbar and status area.
PanelWindow {
    id: root
    signal launcherClicked()
    signal statusClicked()
    signal backgroundClicked()
    signal toggleTopBarClicked()

    property alias launcherActive: launcherBtn.isActive
    property alias statusActive: statusArea.isActive

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

            LauncherButton {
                id: launcherBtn
                onClicked: root.launcherClicked()
            }
            Item { Layout.fillWidth: true }
            

            
            StatusArea {
                id: statusArea
                onClicked: root.statusClicked()
            }
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
                    Config.launchTerminal();
                    shelfContextMenu.visible = false;
                }
            }
            MenuItem {
                icon: "speed"
                text: "Task Manager"
                onClicked: {
                    Config.launchTaskManager();
                    shelfContextMenu.visible = false;
                }
            }
            MenuItem {
                icon: "folder"
                text: "Files"
                onClicked: {
                    Config.launchFileManager();
                    shelfContextMenu.visible = false;
                }
            }
            MenuItem {
                icon: "space_dashboard"
                text: Config.topBar ? "Hide Top Bar" : "Show Top Bar"
                onClicked: {
                    root.toggleTopBarClicked();
                    shelfContextMenu.visible = false;
                }
            }
        }
    }
}
