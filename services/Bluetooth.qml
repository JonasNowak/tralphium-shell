pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool enabled: false
    property var devices: []
    property bool scanning: false

    function refresh() {
        if (!stateReader.running) stateReader.running = true;
        if (!devicesReader.running) devicesReader.running = true;
    }

    function toggle() {
        enabled = !enabled;
        powerProcess.command = ["bluetoothctl", "power", enabled ? "on" : "off"];
        powerProcess.running = true;
    }

    function connectDevice(mac) {
        connectProcess.command = ["bluetoothctl", "connect", mac];
        connectProcess.running = true;
    }

    function disconnectDevice(mac) {
        disconnectProcess.command = ["bluetoothctl", "disconnect", mac];
        disconnectProcess.running = true;
    }

    
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

    Process {
        id: powerProcess
        onExited: root.refresh()
    }
    
    Process {
        id: connectProcess
        onExited: root.refresh()
    }

    Process {
        id: disconnectProcess
        onExited: root.refresh()
    }

    Process {
        id: stateReader
        command: ["sh", "-c", "bluetoothctl show | grep -i 'Powered: yes'"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.enabled = (text.trim() !== "");
            }
        }
    }

    Process {
        id: devicesReader
        command: ["sh", "-c", "bluetoothctl devices | awk '{print $2, $3}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = text.split("\n");
                let devList = [];
                for (let i = 0; i < lines.length; i++) {
                    let line = lines[i].trim();
                    if (!line) continue;
                    let parts = line.split(" ");
                    if (parts.length >= 2) {
                        let mac = parts[0];
                        let name = parts.slice(1).join(" ");
                        devList.push({mac: mac, name: name, connected: false});
                    }
                }
                
                // Need to fetch connection status
                if (devList.length > 0) {
                    root.devices = devList;
                    statusReader.runNext(0);
                } else {
                    root.devices = [];
                }
            }
        }
    }

    Process {
        id: statusReader
        property int currentIndex: 0
        command: []
        
        function runNext(index) {
            if (index >= root.devices.length) return;
            currentIndex = index;
            command = ["sh", "-c", "bluetoothctl info " + root.devices[index].mac + " | grep -i 'Connected: yes'"];
            running = true;
        }

        stdout: StdioCollector {
            onStreamFinished: {
                let isConnected = (text.trim() !== "");
                
                // We need to update the device list immutably to trigger binding updates
                let newDevices = root.devices.slice();
                if (currentIndex < newDevices.length) {
                    newDevices[currentIndex].connected = isConnected;
                }
                root.devices = newDevices;
                
                statusReader.runNext(statusReader.currentIndex + 1);
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }
    
    Component.onCompleted: root.refresh()
}
