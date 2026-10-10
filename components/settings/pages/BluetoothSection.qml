import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.themes
import qs.widgets
import qs.services

ColumnLayout {
    property string title: "Bluetooth"
    spacing: 12
    
    Text {
        text: title
        font.pixelSize: 13
        font.bold: true
        color: Theme.accent
        Layout.fillWidth: true
        Layout.leftMargin: 4
    }
    
    DialogPopup {
        id: pairDialog
        title: "Pair new device"
        onOpened: Bluetooth.startScan()
        onClosed: Bluetooth.stopScan()
        
        Text {
            text: Bluetooth.scanning ? "Scanning for devices..." : "Scan stopped."
            color: Theme.textSecondary
            font.pixelSize: 13
        }
        
        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            clip: true
            
            ColumnLayout {
                width: parent.width
                spacing: 0
                
                Repeater {
                    model: Bluetooth.devices
                    delegate: Rectangle {
                        visible: !modelData.connected
                        width: parent.width
                        implicitHeight: visible ? 48 : 0
                        color: pairMouse.containsMouse ? Theme.hover : "transparent"
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12
                            
                            MaterialIcon { 
                                text: "bluetooth"
                                font.pixelSize: 20
                                color: Theme.textForeground 
                                Layout.alignment: Qt.AlignVCenter
                            }
                            
                            Text { 
                                text: modelData.name; 
                                color: Theme.textForeground; 
                                font.pixelSize: 13; 
                                Layout.fillWidth: true; 
                                elide: Text.ElideRight 
                            }
                            
                            Button {
                                text: "Pair"
                                onClicked: Bluetooth.pairDevice(modelData.mac)
                            }
                        }
                        
                        MouseArea {
                            id: pairMouse
                            z: -1
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: content.implicitHeight
        color: Theme.alpha(Theme.buttonHover, 0.1)
        radius: 12
        border.color: Theme.alpha(Theme.textForeground, 0.1)
        border.width: 1
        
        ColumnLayout {
            id: content
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 0
            
            SettingRow {
                icon: "bluetooth"
                title: "Bluetooth"
                description: Bluetooth.enabled ? "On" : "Off"
                
                Switch {
                    checked: Bluetooth.enabled
                    onToggled: Bluetooth.toggle()
                }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16; visible: Bluetooth.enabled }
            
            ColumnLayout {
                Layout.fillWidth: true
                visible: Bluetooth.enabled
                spacing: 0
                
                Repeater {
                    model: Bluetooth.devices
                    delegate: Rectangle {
                        visible: modelData.connected
                        Layout.fillWidth: true
                        implicitHeight: visible ? 56 : 0
                        color: devMouse.containsMouse ? Theme.hover : "transparent"
                        
                        MouseArea {
                            id: devMouse
                            z: -1
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (modelData.connected) {
                                    Bluetooth.disconnectDevice(modelData.mac)
                                } else {
                                    Bluetooth.connectDevice(modelData.mac)
                                }
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            
                            MaterialIcon { 
                                text: modelData.connected ? "bluetooth_connected" : "bluetooth"
                                font.pixelSize: 24
                                color: Theme.textForeground 
                                Layout.alignment: Qt.AlignVCenter
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Text { text: modelData.name; color: Theme.textForeground; font.pixelSize: 14; font.bold: modelData.connected; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.connected ? "Connected" : "Disconnected"; color: Theme.textSecondary; font.pixelSize: 12; Layout.fillWidth: true }
                            }
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16; visible: Bluetooth.enabled }
            
            SettingRow {
                icon: "add"
                title: "Pair new device"
                visible: Bluetooth.enabled
                Button {
                    text: "Open"
                    onClicked: pairDialog.open()
                }
            }
        }
    }
}
