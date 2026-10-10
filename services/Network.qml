pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string currentSsid: ""
    property int currentSignal: 0
    property bool currentSecurity: false
    property var networks: [] // [{ssid: string, active: bool, signal: int, security: string}]
    property var knownNetworks: [] // [string]
    property bool scanning: false

    function refresh() {
        if (!stateReader.running) stateReader.running = true;
        if (!listReader.running) listReader.running = true;
        if (!knownReader.running) knownReader.running = true;
    }

    function getIcon(signal, secure) {
        if (signal >= 75) return secure ? "network_wifi_locked" : "network_wifi";
        if (signal >= 50) return secure ? "network_wifi_3_bar_locked" : "network_wifi_3_bar";
        if (signal >= 25) return secure ? "network_wifi_2_bar_locked" : "network_wifi_2_bar";
        return secure ? "network_wifi_1_bar_locked" : "network_wifi_1_bar";
    }

    function connectKnown(ssid) {
        connectProcess.command = ["nmcli", "con", "up", "id", ssid];
        connectProcess.running = true;
    }

    function connectTo(ssid, password, username) {
        if (ssid === "eduroam") {
            // Preconfigured eduroam settings
            eduroamProcess.command = ["sh", "-c", `nmcli con add type wifi con-name "${ssid}" ssid "${ssid}" wifi-sec.key-mgmt wpa-eap 802-1x.eap peap 802-1x.phase2-auth mschapv2 802-1x.identity "${username}" 802-1x.password "${password}" && nmcli con up id "${ssid}"`];
            eduroamProcess.running = true;
        } else {
            let args = ["dev", "wifi", "connect", ssid];
            if (password) {
                args.push("password");
                args.push(password);
            }
            connectProcess.command = ["nmcli", ...args];
            connectProcess.running = true;
        }
    }

    function updateConnection(ssid, password, username) {
        if (ssid === "eduroam") {
            eduroamProcess.command = ["sh", "-c", `nmcli con modify "${ssid}" 802-1x.identity "${username}" 802-1x.password "${password}" && nmcli con up id "${ssid}"`];
            eduroamProcess.running = true;
        } else {
            connectProcess.command = ["sh", "-c", `nmcli con modify "${ssid}" wifi-sec.psk "${password}" && nmcli con up id "${ssid}"`];
            connectProcess.running = true;
        }
    }

    function forgetNetwork(ssid) {
        forgetProcess.command = ["nmcli", "con", "delete", "id", ssid];
        forgetProcess.running = true;
    }

    function disconnect() {
        if (currentSsid) {
            disconnectProcess.command = ["nmcli", "con", "down", "id", currentSsid];
            disconnectProcess.running = true;
        }
    }

    Process {
        id: connectProcess
        onExited: root.refresh()
    }
    
    Process {
        id: eduroamProcess
        onExited: root.refresh()
    }

    Process {
        id: disconnectProcess
        onExited: root.refresh()
    }

    Process {
        id: forgetProcess
        onExited: root.refresh()
    }

    Process {
        id: stateReader
        command: ["sh", "-c", "nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim()) {
                    root.currentSsid = text.trim();
                } else {
                    root.currentSsid = "";
                }
            }
        }
    }
    
    Process {
        id: knownReader
        command: ["sh", "-c", "nmcli -t -f name,type con show | grep 802-11-wireless | cut -d: -f1"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = text.split("\n");
                let knownList = [];
                for (let i = 0; i < lines.length; i++) {
                    let line = lines[i].trim();
                    if (line) knownList.push(line);
                }
                root.knownNetworks = knownList;
            }
        }
    }

    Process {
        id: listReader
        command: ["sh", "-c", "nmcli -t -f active,ssid,signal,security dev wifi list"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = text.split("\n");
                let netList = [];
                let seen = new Set();
                for (let i = 0; i < lines.length; i++) {
                    let line = lines[i].trim();
                    if (!line) continue;
                    let match = line.match(/^([^:]+):(.*):([^:]+):([^:]*)$/);
                    if (match) {
                        let active = match[1] === "yes";
                        let ssid = match[2].replace(/\\:/g, ':');
                        let signal = parseInt(match[3]);
                        let security = match[4];
                        if (ssid && !seen.has(ssid)) {
                            seen.add(ssid);
                            netList.push({ssid: ssid, active: active, signal: signal, security: security});
                            if (active) {
                                root.currentSignal = signal;
                                root.currentSecurity = (security !== "");
                            }
                        }
                    }
                }
                netList.sort((a, b) => {
                    if (a.active && !b.active) return -1;
                    if (!a.active && b.active) return 1;
                    return b.signal - a.signal;
                });
                root.networks = netList;
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
