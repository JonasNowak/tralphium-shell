import re

with open('components/settings/SettingsWindow.qml', 'r') as f:
    content = f.read()

# Fix Wi-Fi row icon to be arrow_drop_down / arrow_right
content = content.replace(
    'MaterialIcon { text: wifiHeader.expanded ? "expand_less" : "expand_more"; color: Theme.textForeground; font.pixelSize: 20; Layout.alignment: Qt.AlignVCenter }',
    'MaterialIcon { text: wifiHeader.expanded ? "arrow_drop_down" : "arrow_right"; color: Theme.textForeground; font.pixelSize: 24; Layout.alignment: Qt.AlignVCenter }'
)

# And make Mobile data / VPN use size 24 for the arrow to match Wi-Fi's arrow_right size
content = content.replace(
    'MaterialIcon { text: "arrow_right"; color: Theme.textForeground; font.pixelSize: 20; Layout.alignment: Qt.AlignVCenter }',
    'MaterialIcon { text: "arrow_right"; color: Theme.textForeground; font.pixelSize: 24; Layout.alignment: Qt.AlignVCenter }'
)

with open('components/settings/SettingsWindow.qml', 'w') as f:
    f.write(content)
