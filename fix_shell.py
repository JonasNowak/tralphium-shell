with open('shell.qml', 'r') as f:
    content = f.read()

# Add onNetworkSettingsRequested: settingsWindow.openNetworkSettings()
if 'onNetworkSettingsRequested' not in content:
    content = content.replace(
        'onSettingsRequested: settingsWindow.open()',
        'onSettingsRequested: settingsWindow.open()\n        onNetworkSettingsRequested: settingsWindow.openNetworkSettings()'
    )

with open('shell.qml', 'w') as f:
    f.write(content)
