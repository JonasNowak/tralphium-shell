pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Default sink volume and sink selection via WirePlumber (wpctl).
Singleton {
    id: root

    property real volume: 0.5
    property bool isMuted: false
    property var sinks: [] // [{ id, name, isDefault }]

    function refresh() { volumeReader.running = true; }
    function refreshSinks() { sinkReader.running = true; }

    function setVolume(value) {
        volume = value;
        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", Math.round(value * 100) + "%"]);
        if (isMuted) {
            isMuted = false;
            Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "0"]);
        }
    }

    function toggleMute() {
        isMuted = !isMuted;
        Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", isMuted ? "1" : "0"]);
    }

    function setDefaultSink(id) {
        Quickshell.execDetached(["wpctl", "set-default", id]);
        root.sinks = root.sinks.map(s => Object.assign({}, s, { isDefault: s.id === id }));
        refreshSinks();
    }

    Process {
        id: volumeReader
        running: true
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                const match = this.text.match(/Volume:\s*([\d.]+)/);
                if (match) root.volume = parseFloat(match[1]);
                root.isMuted = this.text.indexOf("[MUTED]") !== -1;
            }
        }
    }

    // Outputs one "id|isDefault|name" line per sink
    Process {
        id: sinkReader
        running: true
        command: [Quickshell.shellPath("etc/get_sinks.sh")]
        stdout: StdioCollector {
            onStreamFinished: {
                root.sinks = this.text.trim().split("\n")
                    .map(line => line.split("|"))
                    .filter(parts => parts.length >= 3)
                    .map(parts => ({ id: parts[0].trim(), isDefault: parts[1].trim() === "1", name: parts[2].trim() }));
            }
        }
    }
}
