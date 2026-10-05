pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// App IDs pinned to the taskbar (case-insensitive).
Singleton {
    id: root

    property var apps: []

    function isPinned(appId) {
        if (!appId) return false;
        const id = appId.toLowerCase();
        return apps.some(a => a.toLowerCase() === id);
    }

    function save() {
        const json = JSON.stringify(apps).replace(/'/g, "'\\''");
        Quickshell.execDetached(["sh", "-c", "mkdir -p ~/.config/tralphium && echo '" + json + "' > ~/.config/tralphium/pins.json"]);
    }

    function toggle(appId) {
        if (!appId) return;
        const id = appId.toLowerCase();
        apps = isPinned(appId) ? apps.filter(a => a.toLowerCase() !== id) : apps.concat([appId]);
        save();
    }

    Process {
        command: ["cat", Quickshell.env("HOME") + "/.config/tralphium/pins.json"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const loaded = JSON.parse(this.text.trim());
                    if (Array.isArray(loaded)) {
                        root.apps = loaded;
                    }
                } catch(e) {}
            }
        }
    }
}
