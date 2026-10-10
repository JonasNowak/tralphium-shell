pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string currentVpn: ""
    property var vpns: []
    property int vpnCount: vpns.length // [{name: string, active: bool}]

    function refresh() {
        if (!listReader.running) listReader.running = true;
    }

    function connectVpn(name) {
        connectProcess.command = ["nmcli", "con", "up", "id", name];
        connectProcess.running = true;
    }

    function disconnectVpn(name) {
        disconnectProcess.command = ["nmcli", "con", "down", "id", name];
        disconnectProcess.running = true;
    }

    function deleteVpn(name) {
        deleteProcess.command = ["nmcli", "con", "delete", "id", name];
        deleteProcess.running = true;
    }

    function importVpn(filePath) {
        importProcess.command = ["nmcli", "con", "import", "type", "wireguard", "file", filePath];
        importProcess.running = true;
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
        id: deleteProcess
        onExited: root.refresh()
    }

    Process {
        id: importProcess
        onExited: root.refresh()
    }

    Process {
        id: listReader
        // List connections, filter by wireguard, output active state and name
        command: ["sh", "-c", "nmcli -t -f active,name,type con show | grep -E ':(wireguard|vpn|tun)$' || true"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = text.split("\n");
                let vpnList = [];
                let activeName = "";
                for (let i = 0; i < lines.length; i++) {
                    let line = lines[i].trim();
                    if (!line) continue;
                    let match = line.match(/^([^:]+):([^:]+):(wireguard|vpn|tun)$/);
                    if (match) {
                        let active = match[1] === "yes";
                        let name = match[2].replace(/\\:/g, ':');
                        vpnList.push({name: name, active: active});
                        if (active) {
                            activeName = name;
                        }
                    }
                }
                root.vpns = vpnList;
                root.currentVpn = activeName;
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
