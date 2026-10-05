import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services
import qs.themes
import qs.widgets
import "AppList.js" as AppList

// App launcher with search, web-search fallback and pin context menu.
Overlay {
    id: root

    readonly property string query: searchInput.text.trim().toLowerCase()
    readonly property var filteredApps: AppList.apps.filter(app =>
        app.name.toLowerCase().includes(query) || app.id.toLowerCase().includes(query))
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
                            if (root.filteredApps.length > 0) {
                                root.launch(root.filteredApps[0]);
                            } else if (text.trim()) {
                                root.close();
                                Qt.openUrlExternally("https://duckduckgo.com/?q=" + encodeURIComponent(text.trim()));
                            }
                        }
                    }
                }
            }

            GridView {
                id: grid
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                cellWidth: 110
                cellHeight: 110
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: ScrollBar { active: true }
                model: root.filteredApps

                delegate: Item {
                    width: grid.cellWidth
                    height: grid.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 8
                        radius: 8
                        color: mouse.containsMouse ? Theme.hover : "transparent"

                        AppIcon {
                            id: icon
                            anchors.top: parent.top
                            anchors.topMargin: 12
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 48
                            height: 48
                            source: modelData.icon
                            name: modelData.name
                            initialsSize: 20
                        }

                        Text {
                            anchors { top: icon.bottom; left: parent.left; right: parent.right; topMargin: 8; leftMargin: 4; rightMargin: 4 }
                            text: modelData.name
                            color: Theme.textForeground
                            font.pixelSize: 13
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }

                        MouseArea {
                            id: mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: event => {
                                if (event.button === Qt.RightButton) {
                                    root.openMenu(modelData.id, mapToItem(null, event.x, event.y));
                                } else {
                                    appMenu.visible = false;
                                    root.launch(modelData);
                                }
                            }
                        }
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
    }
}
