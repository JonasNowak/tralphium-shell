import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import Quickshell
import qs.services
import qs.themes
import qs.widgets
import "pages"

Window {
    id: root
    title: "Settings"
    width: 900
    height: 700
    color: Theme.panelBackground

    function open() {
        show();
        requestActivate();
    }

    function openNetworkSettings() {
        scrollView.contentY = networkSec.y;
        open();
    }
    
    function scrollTo(sectionY) {
        scrollAnim.to = sectionY;
        scrollAnim.start();
    }
    
    NumberAnimation {
        id: scrollAnim
        target: scrollView
        property: "contentY"
        duration: 300
        easing.type: Easing.InOutQuad
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left Sidebar
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 240
            color: Theme.alpha(Theme.buttonHover, 0.05)
            radius: Theme.panelRadius
            
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Theme.panelRadius
                color: parent.color
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8

                Text {
                    Layout.fillWidth: true
                    text: "Settings"
                    font.pixelSize: 22
                    font.bold: true
                    color: Theme.textForeground
                    Layout.bottomMargin: 16
                    Layout.leftMargin: 8
                }

                Repeater {
                    model: [
                        { name: "Network", icon: "network_wifi", target: networkSec },
                        { name: "Bluetooth", icon: "bluetooth", target: bluetoothSec },
                        { name: "Connected devices", icon: "devices", target: connectedSec },
                        { name: "Accounts", icon: "person", target: accountsSec },
                        { name: "Device", icon: "computer", target: deviceSec },
                        { name: "Personalization", icon: "edit", target: personalizationSec },
                        { name: "Search and Assistant", icon: "search", target: searchSec },
                        { name: "Privacy and security", icon: "security", target: privacySec },
                        { name: "Apps", icon: "apps", target: appsSec },
                        { name: "Accessibility", icon: "accessibility", target: accessibilitySec },
                        { name: "About Tralphium", icon: "info", target: aboutSec }
                    ]
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 40
                        radius: 20
                        color: mouseArea.containsMouse ? Theme.alpha(Theme.buttonHover, 0.1) : "transparent"
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            spacing: 16
                            MaterialIcon { 
                                text: modelData.icon
                                color: Theme.iconColor
                                font.pixelSize: 20 
                            }
                            Text { 
                                text: modelData.name
                                color: Theme.textForeground
                                font.pixelSize: 14 
                            }
                            Item { Layout.fillWidth: true }
                        }
                        
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                scrollTo(modelData.target.y);
                            }
                        }
                    }
                }
                
                Item { Layout.fillHeight: true } // Spacer
            }
        }
        
        // Right Content
        Flickable {
            id: scrollView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentHeight: contentCol.implicitHeight + 120
            boundsBehavior: Flickable.StopAtBounds
            
            ScrollBar.vertical: ScrollBar {
                active: true
            }
            
            ColumnLayout {
                id: contentCol
                width: scrollView.width - 120
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 40
                
                Item { height: 20 } // Top padding
                
                NetworkSection { id: networkSec; Layout.fillWidth: true }
                BluetoothSection { id: bluetoothSec; Layout.fillWidth: true }
                ConnectedDevicesSection { id: connectedSec; Layout.fillWidth: true }
                AccountsSection { id: accountsSec; Layout.fillWidth: true }
                DeviceSection { id: deviceSec; Layout.fillWidth: true }
                PersonalizationSection { id: personalizationSec; Layout.fillWidth: true }
                SearchAndAssistantSection { id: searchSec; Layout.fillWidth: true }
                PrivacyAndSecuritySection { id: privacySec; Layout.fillWidth: true }
                AppsSection { id: appsSec; Layout.fillWidth: true }
                AccessibilitySection { id: accessibilitySec; Layout.fillWidth: true }
                AboutSection { id: aboutSec; Layout.fillWidth: true }
            }
        }
    }
}
