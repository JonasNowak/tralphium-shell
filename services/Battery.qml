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

    function refresh() {
        capacityFile.reload();
        statusFile.reload();
    }

    FileView {
        id: capacityFile
        path: root.sysfsPath + "/capacity"
        printErrors: false
        onLoaded: {
            root.capacity = parseInt(text()) || 100;
            root.available = true;
        }
        onLoadFailed: root.available = false
    }

    FileView {
        id: statusFile
        path: root.sysfsPath + "/status"
        printErrors: false
        onLoaded: root.status = text().trim()
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }
}
