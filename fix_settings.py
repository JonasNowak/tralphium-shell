with open('components/settings/SettingsWindow.qml', 'r') as f:
    content = f.read()

old_open = '''    function open() {
        show();
        requestActivate();
    }'''

new_open = '''    function open() {
        show();
        requestActivate();
    }

    function openNetworkSettings() {
        currentTab = 0;
        wifiHeader.expanded = true;
        open();
    }'''

if 'function openNetworkSettings()' not in content:
    content = content.replace(old_open, new_open)

with open('components/settings/SettingsWindow.qml', 'w') as f:
    f.write(content)
