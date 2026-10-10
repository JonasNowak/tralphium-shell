import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls
import qs.themes
import qs.widgets

import qs.services

ColumnLayout {
    property string title: "Network"
    spacing: 12
    
    Text {
        text: title
        font.pixelSize: 13
        font.bold: true
        color: Theme.accent
        Layout.fillWidth: true
        Layout.leftMargin: 4
    }

    FileDialog {
        id: vpnDialog
        title: "Import WireGuard config"
        nameFilters: ["WireGuard config (*.conf)"]
        onAccepted: {
            Vpn.importVpn(decodeURIComponent(selectedFile.toString().replace("file://", "")));
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
            
            // Wi-Fi Header
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 72
                color: wifiMouse.containsMouse ? Theme.hover : "transparent"
                radius: 12
                
                property bool expanded: true
                
                MouseArea {
                    id: wifiMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: parent.expanded = !parent.expanded
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16
                    
                    MaterialIcon { 
                        text: Network.currentSsid !== "" ? "wifi" : "wifi_off"
                        color: Theme.textForeground
                        font.pixelSize: 24
                        Layout.alignment: Qt.AlignVCenter 
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 4
                        Text { text: "Wi-Fi"; color: Theme.textForeground; font.pixelSize: 14; Layout.fillWidth: true }
                        Text { text: Network.currentSsid !== "" ? Network.currentSsid : "Not connected"; color: Theme.textSecondary; font.pixelSize: 12; Layout.fillWidth: true }
                    }
                    
                    MaterialIcon { 
                        text: parent.parent.expanded ? "expand_less" : "expand_more"
                        color: Theme.textForeground
                        font.pixelSize: 24
                        Layout.alignment: Qt.AlignVCenter 
                    }
                }
            }
            
            // Wi-Fi List
            ColumnLayout {
                Layout.fillWidth: true
                visible: parent.children[0].expanded
                spacing: 0
                
                Repeater {
                    model: Network.networks
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: passwordField.visible ? 104 : 56
                        color: netMouse.containsMouse ? Theme.hover : "transparent"
                        
                        property bool isConnected: modelData.active
                        
                        MouseArea {
                            id: netMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            property bool showPassword: false
                            onClicked: {
                                if (isConnected) {
                                    Network.disconnect()
                                } else if (modelData.security !== "") {
                                    showPassword = !showPassword
                                    if (showPassword) pwdInput.forceActiveFocus()
                                } else {
                                    Network.connectTo(modelData.ssid, "")
                                }
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            
                            MaterialIcon { 
                                text: Network.getIcon(modelData.signal, modelData.security !== "")
                                font.pixelSize: 24
                                color: Theme.textForeground 
                                Layout.alignment: Qt.AlignVCenter
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Text { text: modelData.ssid; color: Theme.textForeground; font.pixelSize: 14; font.bold: isConnected; Layout.fillWidth: true }
                                Text { text: isConnected ? "Connected" : (modelData.security !== "" ? "Secured" : "Open"); color: Theme.textSecondary; font.pixelSize: 12; Layout.fillWidth: true }
                            }
                        }
                        
                        // Password Field
                        RowLayout {
                            id: passwordField
                            visible: netMouse.showPassword
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.leftMargin: 56
                            anchors.rightMargin: 16
                            anchors.bottomMargin: 8
                            height: 32
                            
                            TextField {
                                id: pwdInput
                                Layout.fillWidth: true
                                placeholderText: "Password"
                                echoMode: TextInput.Password
                                onAccepted: Network.connectTo(modelData.ssid, pwdInput.text)
                            }
                            Button {
                                text: "Connect"
                                onClicked: Network.connectTo(modelData.ssid, pwdInput.text)
                            }
                        }
                    }
                }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16 }
            
            // VPN Header
            SettingRow {
                icon: "vpn_key"
                title: "VPN"
                description: Vpn.currentVpn !== "" ? Vpn.currentVpn : "Add connection"
                
                Button {
                    text: "Import"
                    onClicked: vpnDialog.open()
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.alpha(Theme.textForeground, 0.1); anchors.leftMargin: 16; visible: Vpn.vpnCount > 0 }

            // VPN List
            ColumnLayout {
                Layout.fillWidth: true
                visible: Vpn.vpnCount > 0
                spacing: 0
                
                Repeater {
                    model: Vpn.vpns
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 56
                        color: vpnMouse.containsMouse ? Theme.hover : "transparent"
                        
                        property bool isConnected: modelData.active
                        
                        MouseArea {
                            id: vpnMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (isConnected) {
                                    Vpn.disconnectVpn(modelData.name)
                                } else {
                                    Vpn.connectVpn(modelData.name)
                                }
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            
                            MaterialIcon { 
                                text: isConnected ? "vpn_lock" : "vpn_key"
                                font.pixelSize: 24
                                color: Theme.textForeground 
                                Layout.alignment: Qt.AlignVCenter
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Text { text: modelData.name; color: Theme.textForeground; font.pixelSize: 14; font.bold: isConnected; Layout.fillWidth: true }
                                Text { text: isConnected ? "Connected" : "Disconnected"; color: Theme.textSecondary; font.pixelSize: 12; Layout.fillWidth: true }
                            }

                            IconButton {
                                icon: "delete"
                                onClicked: Vpn.deleteVpn(modelData.name)
                            }
                        }
                    }
                }
            }

        }
    }
}
