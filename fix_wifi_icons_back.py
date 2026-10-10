import os

def replace_in_file(filepath, replacements):
    if not os.path.exists(filepath):
        return
    with open(filepath, 'r') as f:
        content = f.read()
    
    for old, new in replacements.items():
        content = content.replace(old, new)
        
    with open(filepath, 'w') as f:
        f.write(content)

# We want:
# non-secure: network_wifi, network_wifi_3_bar, network_wifi_2_bar, network_wifi_1_bar
# secure: network_wifi_locked, network_wifi_3_bar_locked, network_wifi_2_bar_locked, network_wifi_1_bar_locked
# off: wifi_off

reps = {
    '"signal_wifi_4_bar_lock"': '"network_wifi_locked"',
    '"signal_wifi_4_bar"': '"network_wifi"',
    '"signal_wifi_3_bar_lock"': '"network_wifi_3_bar_locked"',
    '"signal_wifi_3_bar"': '"network_wifi_3_bar"',
    '"signal_wifi_2_bar_lock"': '"network_wifi_2_bar_locked"',
    '"signal_wifi_2_bar"': '"network_wifi_2_bar"',
    '"signal_wifi_1_bar_lock"': '"network_wifi_1_bar_locked"',
    '"signal_wifi_1_bar"': '"network_wifi_1_bar"',
    '"signal_wifi_off"': '"wifi_off"'
}

replace_in_file('services/Network.qml', reps)
replace_in_file('components/settings/SettingsWindow.qml', reps)
replace_in_file('components/controlpanel/ControlPanel.qml', reps)

