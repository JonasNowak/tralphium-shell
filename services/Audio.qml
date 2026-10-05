pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Default sink volume and sink selection via WirePlumber (wpctl).
Singleton {
    id: root

    property real volume: 0.5
    property var sinks: [] // [{ id, name, isDefault }]

    function refresh() { volumeReader.running = true; }
    function refreshSinks() { sinkReader.running = true; }

    function setVolume(value) {
        volume = value;
        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", Math.round(value * 100) + "%"]);
    }

    function setDefaultSink(id) {
        defaultSetter.command = ["wpctl", "set-default", id];
        defaultSetter.running = true;
    }

    Process {
        id: volumeReader
        running: true
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                const match = this.text.match(/Volume: (\d+\.\d+)/);
                if (match) root.volume = parseFloat(match[1]);
            }
        }
    }

    // Outputs one "id|isDefault|name" line per sink
    Process {
        id: sinkReader
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

    Process {
        id: defaultSetter
        onExited: root.refreshSinks()
    }
}
