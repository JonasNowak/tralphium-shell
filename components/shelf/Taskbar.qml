import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.themes
import qs.widgets

// Centered task list: pinned apps first, then running apps that aren't pinned.
Item {
    id: root
    property var panelWindow

    // Target of the open context menu
    property string menuAppId: ""
    property var menuToplevel: null // null for pinned apps

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    function closeMenu() { contextMenu.visible = false; }

    function windowsOf(appId) {
        const id = appId.toLowerCase();
        return ToplevelManager.toplevels.values.filter(t => (t.appId || "").toLowerCase() === id);
    }

    function capitalize(s) { return s.charAt(0).toUpperCase() + s.slice(1); }

    function anchorPopup(popup, item) {
        const p = item.mapToItem(null, 0, 0);
        popup.anchor.rect = Qt.rect(p.x, p.y, item.width, item.height);
    }

    function showTooltip(item, show) {
        tooltip.visible = false;
        if (!show) return;
        tooltipText.text = item.name;
        anchorPopup(tooltip, item);
        tooltip.visible = true;
    }

    // Right click opens/toggles the context menu, left click runs `activate`
    function handleClick(item, button, toplevel, activate) {
        tooltip.visible = false;
        if (button !== Qt.RightButton) {
            closeMenu();
            activate();
        } else if (contextMenu.visible && menuAppId === item.appId && menuToplevel === toplevel) {
            closeMenu();
        } else {
            menuAppId = item.appId;
            menuToplevel = toplevel;
            anchorPopup(contextMenu, item);
            contextMenu.visible = true;
        }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 8

        ListView {
            id: pinnedList
            implicitWidth: contentWidth
            implicitHeight: 44
            orientation: ListView.Horizontal
            spacing: 8
            interactive: false

            displaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 200; easing.type: Easing.OutQuad }
            }

            model: Pins.apps
            delegate: TaskButton {
                id: pinned
                readonly property int pinIndex: index
                readonly property var windows: root.windowsOf(model.appId)
                readonly property var resolvedApp: Apps.findApp(model.appId)
                
                onAppEntered: (draggedAppId) => {
                    Pins.insertPin(draggedAppId, pinIndex);
                }
                
                appId: model.appId
                name: resolvedApp ? resolvedApp.name : root.capitalize(model.appId)
                icon: resolvedApp ? resolvedApp.icon : ""
                running: windows.length > 0
                active: Boolean(ToplevelManager.activeToplevel && (ToplevelManager.activeToplevel.appId || "").toLowerCase() === model.appId.toLowerCase())
                onHoveredChanged: root.showTooltip(pinned, hovered)
                onClicked: button => root.handleClick(pinned, button, windows.length > 0 ? windows[0] : null, () => {
                    if (pinned.running) {
                        const activeIdx = windows.findIndex(w => w.activated);
                        if (activeIdx >= 0 && windows.length > 1) {
                            windows[(activeIdx + 1) % windows.length].activate();
                        } else {
                            windows[0].activate();
                        }
                    } else {
                        Quickshell.execDetached(["sh", "-c", `gtk-launch ${pinned.appId} || ${pinned.appId}`]);
                    }
                })
            }
        }

        Repeater {
            model: ToplevelManager.toplevels
            delegate: TaskButton {
                id: task
                readonly property var resolvedApp: Apps.findApp(modelData.appId || modelData.title)
                appId: modelData.appId || ""
                name: resolvedApp ? resolvedApp.name : root.capitalize(modelData.appId || modelData.title || "?")
                icon: resolvedApp ? resolvedApp.icon : ""
                visible: !Pins.isPinned(appId)
                running: true
                active: modelData.activated
                onHoveredChanged: root.showTooltip(task, hovered)
                onClicked: button => root.handleClick(task, button, modelData, () => {
                    if (!modelData.activated) modelData.activate();
                })
            }
        }
    }

    PopupWindow {
        id: contextMenu
        anchor.window: root.panelWindow
        anchor.edges: Edges.Top | Edges.Right
        grabFocus: true
        color: "transparent"
        visible: false
        implicitWidth: menu.implicitWidth
        implicitHeight: menu.implicitHeight

        MenuCard {
            id: menu
            anchors.fill: parent

            MenuItem {
                readonly property bool pinned: Pins.isPinned(root.menuAppId)
                icon: pinned ? "keep_off" : "keep"
                text: pinned ? "Unpin" : "Pin"
                onClicked: {
                    Pins.toggle(root.menuAppId);
                    root.closeMenu();
                }
            }

            MenuItem {
                visible: root.menuToplevel !== null
                icon: "close"
                text: "Close"
                onClicked: {
                    root.menuToplevel.close();
                    root.closeMenu();
                }
            }
        }
    }

    PopupWindow {
        id: tooltip
        anchor.window: root.panelWindow
        anchor.edges: Edges.Top | Edges.Right
        color: "transparent"
        visible: false
        implicitWidth: tooltipText.implicitWidth + 24
        implicitHeight: tooltipText.implicitHeight + 16

        Card {
            anchors.fill: parent

            Text {
                id: tooltipText
                anchors.centerIn: parent
                color: Theme.textForeground
                font.pixelSize: 14
            }
        }
    }
}
