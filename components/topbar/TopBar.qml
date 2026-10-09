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
                
                
            }

            // Spacer
            Item { Layout.fillWidth: true }

            // Right side: virtual desktops overview with numbers and window controls
            RowLayout {
                spacing: 8
                
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

                // Window Controls
                RowLayout {
                    spacing: 4
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 8

                    readonly property var activeToplevel: ToplevelManager.activeToplevel

                    IconButton {
                        icon: "remove"
                        iconSize: 14
                        implicitWidth: 20
                        implicitHeight: 20
                        visible: parent.activeToplevel !== null
                        onClicked: {
                            if (parent.activeToplevel) {
                                if (parent.activeToplevel.setMinimized) {
                                    parent.activeToplevel.setMinimized(true);
                                } else {
                                    parent.activeToplevel.minimized = true;
                                }
                            }
                        }
                    }
                    IconButton {
                        icon: "crop_square"
                        iconSize: 14
                        implicitWidth: 20
                        implicitHeight: 20
                        visible: parent.activeToplevel !== null
                        onClicked: {
                            if (parent.activeToplevel) {
                                if (parent.activeToplevel.setMaximized) {
                                    parent.activeToplevel.setMaximized(!parent.activeToplevel.maximized);
                                } else {
                                    parent.activeToplevel.maximized = !parent.activeToplevel.maximized;
                                }
                            }
                        }
                    }
                    IconButton {
                        icon: "close"
                        iconSize: 14
                        implicitWidth: 20
                        implicitHeight: 20
                        visible: parent.activeToplevel !== null
                        onClicked: {
                            if (parent.activeToplevel) {
                                parent.activeToplevel.close();
                            }
                        }
                    }
                }
            }
        }
    }
}
