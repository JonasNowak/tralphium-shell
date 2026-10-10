import re

with open('components/settings/SettingsWindow.qml', 'r') as f:
    content = f.read()

# Fix "Settings" title
content = content.replace(
    'Text {\n                        text: "Settings"',
    'Text {\n                        Layout.fillWidth: true\n                        text: "Settings"'
)

# Fix "Network" title
content = content.replace(
    'Text {\n                                text: "Network"',
    'Text {\n                                Layout.fillWidth: true\n                                text: "Network"'
)

# Fix Wi-Fi row right side
wifi_old = '''                                            MaterialIcon { text: wifiHeader.expanded ? "expand_less" : "expand_more"; color: Theme.textForeground; font.pixelSize: 24; Layout.alignment: Qt.AlignVCenter }'''
wifi_new = '''                                            MaterialIcon { text: wifiHeader.expanded ? "expand_less" : "expand_more"; color: Theme.textForeground; font.pixelSize: 20; Layout.alignment: Qt.AlignVCenter }
                                            
                                            // Switch
                                            Rectangle {
                                                implicitWidth: 44
                                                implicitHeight: 24
                                                radius: 12
                                                color: Theme.activeTint
                                                Layout.alignment: Qt.AlignVCenter
                                                
                                                Rectangle {
                                                    width: 20
                                                    height: 20
                                                    radius: 10
                                                    color: Theme.textForeground
                                                    x: 22
                                                    y: 2
                                                }
                                            }'''
content = content.replace(wifi_old, wifi_new)

# Fix VPN row right side
vpn_old = '''                                            MaterialIcon { text: "arrow_right"; color: Theme.textForeground; font.pixelSize: 20; Layout.alignment: Qt.AlignVCenter }'''
vpn_new = '''                                            MaterialIcon { text: "arrow_right"; color: Theme.textForeground; font.pixelSize: 20; Layout.alignment: Qt.AlignVCenter }
                                            Item { implicitWidth: 44; implicitHeight: 24 }'''
content = content.replace(vpn_old, vpn_new)

# Fix Add connection right side
add_old = '''                                            MaterialIcon { text: "expand_more"; color: Theme.textForeground; font.pixelSize: 20; Layout.alignment: Qt.AlignVCenter }'''
add_new = '''                                            MaterialIcon { text: "expand_more"; color: Theme.textForeground; font.pixelSize: 20; Layout.alignment: Qt.AlignVCenter }
                                            Item { implicitWidth: 44; implicitHeight: 24 }'''
content = content.replace(add_old, add_new)

with open('components/settings/SettingsWindow.qml', 'w') as f:
    f.write(content)
