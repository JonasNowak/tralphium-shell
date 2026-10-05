pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Battery state read from sysfs, polled every 10 seconds.
Singleton {
    id: root

    readonly property string sysfsPath: "/sys/class/power_supply/BAT0"

    property bool available: false
    property int capacity: 100
    property string status: "" // "Charging", "Discharging", "Full", "Not charging"
    readonly property bool charging: status === "Charging"

    readonly property string description: {
        if (!available) return "No Battery";
        if (status === "Full") return capacity === 100 ? "Battery full" : capacity + "% - Plugged in";
        if (status === "Charging") return capacity + "% - Charging";
        if (status === "Not charging") return capacity + "% - Plugged in";
        return capacity + "% left";
    }

    function refresh() { reader.running = true; }

    Process {
        id: reader
        running: true
        command: ["cat", root.sysfsPath + "/capacity", root.sysfsPath + "/status"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n");
                root.available = lines.length >= 2;
                if (root.available) {
                    root.capacity = parseInt(lines[0]) || 100;
                    root.status = lines[1].trim();
                }
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }
}
