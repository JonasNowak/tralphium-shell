import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.themes
import qs.widgets
import qs.services

PanelWindow {
    id: root
    signal launcherClicked()
    signal statusClicked()
    signal backgroundClicked()
    signal toggleTopBarClicked()

    property alias launcherActive: launcherBtn.isActive
    property alias statusActive: statusArea.isActive
    property bool isVertical: Config.shelfPosition === "left" || Config.shelfPosition === "right"
    property bool isHidden: Config.shelfAutoHide && !cardMouse.containsMouse && !launcherActive && !statusActive && !shelfContextMenu.visible

    anchors {
        bottom: true
        left: Config.shelfPosition !== "right"
        right: Config.shelfPosition !== "left"
        top: Config.shelfPosition !== "bottom"
    }
    
    // Autohide logic: when hidden, we keep a tiny 4px sliver visible to catch mouse events
    margins {
        bottom: Config.shelfPosition === "bottom" && isHidden ? (4 - root.height) : 0
        left: Config.shelfPosition === "left" && isHidden ? (4 - root.width) : 0
        right: Config.shelfPosition === "right" && isHidden ? (4 - root.width) : 0
    }

    Behavior on margins.bottom { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    Behavior on margins.left { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    Behavior on margins.right { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    implicitHeight: isVertical ? -1 : 48
    implicitWidth: isVertical ? 48 : -1
    color: "transparent"
    
    // When hidden, we don't reserve space for maximized windows
    exclusionMode: isHidden ? ExclusionMode.Ignore : ExclusionMode.Normal

    Card {
        anchors.fill: parent

        // Square off the corner touching the screen edge
        Rectangle {
            anchors { 
                bottom: Config.shelfPosition === "bottom" ? parent.bottom : undefined
                left: Config.shelfPosition === "left" ? parent.left : undefined
                right: Config.shelfPosition === "right" ? parent.right : undefined
                top: Config.shelfPosition !== "bottom" ? parent.top : undefined
            }
            height: Config.shelfPosition === "bottom" ? Theme.panelRadius : parent.height
            width: Config.shelfPosition !== "bottom" ? Theme.panelRadius : parent.width
            color: parent.color
        }
        
        MouseArea {
            id: cardMouse
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    taskbar.closeMenu();
                    shelfContextMenu.visible = false;
                    root.backgroundClicked();
                } else if (mouse.button === Qt.RightButton) {
                    taskbar.closeMenu();
                    shelfContextMenu.anchor.rect = Qt.rect(mouse.x, mouse.y, 1, 1);
                    shelfContextMenu.visible = !shelfContextMenu.visible;
                }
            }
        }

        GridLayout {
            anchors.fill: parent
            anchors.margins: 8
            
            flow: root.isVertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
            
            LauncherButton {
                id: launcherBtn
                Layout.alignment: root.isVertical ? Qt.AlignHCenter : Qt.AlignVCenter
                onClicked: root.launcherClicked()
            }
            
            Item { Layout.fillWidth: !root.isVertical; Layout.fillHeight: root.isVertical }
            
            StatusArea {
                id: statusArea
                Layout.alignment: root.isVertical ? Qt.AlignHCenter : Qt.AlignVCenter
                isVertical: root.isVertical
                onClicked: root.statusClicked()
            }
        }

        Taskbar {
            id: taskbar
            anchors.centerIn: parent
            isVertical: root.isVertical
            panelWindow: root
        }
    }

    PopupWindow {
        id: shelfContextMenu
        anchor.window: root
        anchor.edges: root.isVertical ? (Config.shelfPosition === "left" ? Edges.Right : Edges.Left) : Edges.Top
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
