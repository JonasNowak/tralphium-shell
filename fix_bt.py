import re

with open('./services/Bluetooth.qml', 'r') as f:
    content = f.read()

funcs = """
    function startScan() {
        scanning = true;
        scanProcess.command = ["bluetoothctl", "scan", "on"];
        scanProcess.running = true;
    }

    function stopScan() {
        scanning = false;
        scanProcess.running = false;
        scanProcess.command = ["bluetoothctl", "scan", "off"];
        scanProcess.running = true;
    }

    function pairDevice(mac) {
        pairProcess.command = ["bluetoothctl", "pair", mac];
        pairProcess.running = true;
    }

    Process {
        id: scanProcess
    }

    Process {
        id: pairProcess
        onExited: root.refresh()
    }
"""

content = re.sub(
    r'(Process {\s*id: powerProcess)',
    funcs + r'\n    \1',
    content
)

with open('./services/Bluetooth.qml', 'w') as f:
    f.write(content)
