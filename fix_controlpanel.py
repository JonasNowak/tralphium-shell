import re

with open('components/controlpanel/ControlPanel.qml', 'r') as f:
    content = f.read()

# Add signal networkSettingsRequested()
if 'signal networkSettingsRequested()' not in content:
    content = content.replace(
        'signal settingsRequested()',
        'signal settingsRequested()\n    signal networkSettingsRequested()'
    )

# Fix QuickToggle for Network
old_toggle = '''                    QuickToggle {
                        icon: "wifi"; title: "Network"; subtitle: "Strong"; active: true
                        onClicked: Config.launchNetworkManager()
                    }'''
new_toggle = '''                    QuickToggle {
                        icon: Network.currentSsid !== "" ? "wifi" : "wifi_off"
                        title: "Network"
                        subtitle: Network.currentSsid !== "" ? Network.currentSsid : "Not connected"
                        active: Network.currentSsid !== ""
                        onClicked: {
                            root.close()
                            root.networkSettingsRequested()
                        }
                    }'''
content = content.replace(old_toggle, new_toggle)

with open('components/controlpanel/ControlPanel.qml', 'w') as f:
    f.write(content)
