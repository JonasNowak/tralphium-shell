import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services
import qs.themes
import qs.widgets

// App launcher with search, web-search fallback and pin context menu.
Overlay {
    id: root

    readonly property string query: searchInput.text.trim().toLowerCase()
    
    property bool showHiddenApps: false
    property int _hiddenCount: HiddenApps.apps.count

    readonly property var visibleApps: {
        var dummy = _hiddenCount; // force dependency
        return Apps.apps.filter(app => {
            let matchesSearch = app.name.toLowerCase().includes(query) || app.id.toLowerCase().includes(query);
            if (!matchesSearch) return false;
            if (query === "" && HiddenApps.isHidden(app.id)) return false;
            return true;
        });
    }

    readonly property var hiddenAppsList: {
        var dummy = _hiddenCount; // force dependency
        return Apps.apps.filter(app => HiddenApps.isHidden(app.id));
    }
    
    property string menuAppId: ""

    function launch(app) {
        close();
        Quickshell.execDetached(["sh", "-c", `${app.exec} || ${app.id}`]);
    }

    function openMenu(appId, pos) {
        menuAppId = appId;
        appMenu.x = pos.x + appMenu.width > width ? pos.x - appMenu.width : pos.x;
        appMenu.y = pos.y + appMenu.height > height ? pos.y - appMenu.height : pos.y;
        appMenu.visible = true;
    }

    onVisibleChanged: {
        if (!visible) return;
        Apps.refresh();
        searchInput.text = "";
        searchInput.forceActiveFocus();
    }

    // First click outside closes the context menu, the next one the launchpad
    onBackgroundClicked: {
        if (appMenu.visible) appMenu.visible = false;
        else close();
    }

    Card {
        width: 590
        height: 654
        anchors { left: parent.left; bottom: parent.bottom; margins: 4 }
        onClicked: appMenu.visible = false

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            // Search bar
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 48
                radius: 24
                color: Theme.alpha(Theme.buttonHover, 0.4)

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 12

                    MaterialIcon { text: "search"; font.pixelSize: 24 }

                    TextField {
                        id: searchInput
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.textForeground
                        font.pixelSize: 16
                        background: Item {}
                        placeholderText: "Search apps or web..."
                        placeholderTextColor: Theme.alpha(Theme.textForeground, 0.5)

                        Keys.onEscapePressed: {
                            if (appMenu.visible) appMenu.visible = false;
                            else root.close();
                        }

                        onAccepted: {
                            if (root.visibleApps.length > 0) {
                                root.launch(root.visibleApps[0]);
                            } else if (text.trim()) {
                                root.close();
                                Qt.openUrlExternally("https://duckduckgo.com/?q=" + encodeURIComponent(text.trim()));
                            }
                        }
                    }
                }
            }

            ScrollView {
                id: scrollView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                
                ColumnLayout {
                    width: scrollView.availableWidth
                    spacing: 24
                    
                    AppGrid {
                        Layout.fillWidth: true
                        model: root.visibleApps
                        launch: root.launch
                        openMenu: root.openMenu
                    }
                    
                    AppDrawer {
                        Layout.fillWidth: true
                        visible: root.query === "" && root.hiddenAppsList.length > 0
                        text: expanded ? "Hide hidden apps" : "Show hidden apps"
                        expanded: root.showHiddenApps
                        onExpandedChanged: root.showHiddenApps = expanded
                        model: root.hiddenAppsList
                        launch: root.launch
                        openMenu: root.openMenu
                    }
                }
            }
        }
    }

    MenuCard {
        id: appMenu
        visible: false

        MenuItem {
            readonly property bool pinned: Pins.isPinned(root.menuAppId)
            icon: pinned ? "keep_off" : "keep"
            text: pinned ? "Unpin" : "Pin"
            onClicked: {
                Pins.toggle(root.menuAppId);
                appMenu.visible = false;
            }
        }
        
        MenuItem {
            readonly property bool hidden: HiddenApps.isHidden(root.menuAppId)
            icon: hidden ? "visibility" : "visibility_off"
            text: hidden ? "Unhide" : "Hide"
            onClicked: {
                HiddenApps.toggle(root.menuAppId);
                appMenu.visible = false;
            }
        }
    }
}
