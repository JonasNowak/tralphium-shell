import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.WindowManager
import Quickshell.Wayland
import qs.themes
import qs.widgets
import qs.services

// Top bar: Global menu (left) and virtual desktop pager (right)
PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 20
    color: "transparent"

    Item {
        anchors.fill: parent

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 8

            // Left side: Active Application Name
            RowLayout {
                spacing: 4
                
                Text {
                    readonly property var activeToplevel: ToplevelManager.activeToplevel
                    readonly property string activeAppId: activeToplevel ? (activeToplevel.appId || activeToplevel.title || "") : ""
                    readonly property var resolvedApp: Apps.findApp(activeAppId)
                    text: {
                        if (resolvedApp && resolvedApp.name) {
                            return resolvedApp.name;
                        } else if (activeAppId) {
                            return activeAppId.charAt(0).toUpperCase() + activeAppId.slice(1);
                        } else {
                            return "Tralphium";
                        }
                    }
                    font.bold: true
                    font.pixelSize: 12
                    color: Theme.textForeground
                    Layout.rightMargin: 12
                }
            }

            // Spacer
            Item { Layout.fillWidth: true }

            // Right side: virtual desktops overview with numbers
            RowLayout {
                spacing: 4
                
                Repeater {
                    model: WindowManager.windowsets
                    delegate: Item {
                        readonly property bool isActive: modelData.active
                        
                        implicitWidth: 20
                        implicitHeight: 20
                        Layout.alignment: Qt.AlignVCenter
                        
                        Rectangle {
                            anchors.fill: parent
                            color: isActive ? Theme.textForeground : (maDesk.containsMouse ? Theme.hover : "transparent")
                            radius: 10
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: modelData.name || (index + 1)
                            font.pixelSize: 12
                            font.weight: isActive ? Font.Bold : Font.Normal
                            color: isActive ? Theme.panelBackground : Theme.textForeground
                        }
                        
                        MouseArea {
                            id: maDesk
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (modelData.canActivate) {
                                    modelData.activate();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
