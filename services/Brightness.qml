pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Screen backlight: read from sysfs, written via macbook-lighter-screen.
Singleton {
    id: root

    readonly property string sysfsPath: "/sys/class/backlight/intel_backlight"

    property int max: 1808
    property int current: 1808
    readonly property real value: max > 0 ? current / max : 0

    function refresh() { reader.running = true; }

    // `fraction` is 0..1; macbook-lighter-screen only supports relative steps
    function set(fraction) {
        const target = Math.round(fraction * max);
        const diff = target - current;
        if (diff !== 0)
            Quickshell.execDetached(["macbook-lighter-screen", diff > 0 ? "--inc" : "--dec", Math.abs(diff).toString()]);
        current = target;
    }

    Process {
        id: reader
        running: true
        command: ["cat", root.sysfsPath + "/max_brightness", root.sysfsPath + "/brightness"]
        stdout: StdioCollector {
            onStreamFinished: {
                const [max, current] = this.text.trim().split("\n").map(v => parseInt(v));
                if (!isNaN(max)) root.max = max;
                if (!isNaN(current)) root.current = current;
            }
        }
    }
}
