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
    property int _applied: 1808 // last value handed to macbook-lighter-screen
    readonly property real value: max > 0 ? current / max : 0

    function refresh() { currentFile.reload(); }

    // `fraction` is 0..1. macbook-lighter-screen only supports relative steps and every call
    // is a process, so while dragging a slider the changes are coalesced (at most one per 50 ms).
    function set(fraction) {
        current = Math.round(fraction * max);
        applyTimer.start();
    }

    Timer {
        id: applyTimer
        interval: 50
        onTriggered: {
            const diff = root.current - root._applied;
            if (diff !== 0)
                Quickshell.execDetached(["macbook-lighter-screen", diff > 0 ? "--inc" : "--dec", Math.abs(diff).toString()]);
            root._applied = root.current;
        }
    }

    FileView {
        path: root.sysfsPath + "/max_brightness"
        printErrors: false
        onLoaded: root.max = parseInt(text()) || root.max
    }

    FileView {
        id: currentFile
        path: root.sysfsPath + "/brightness"
        printErrors: false
        onLoaded: {
            const v = parseInt(text());
            if (!isNaN(v)) root.current = root._applied = v;
        }
    }
}
