pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var apps: []

    function refresh() {
        if (!reader.running) {
            reader.running = true;
        }
    }

    function findApp(appId) {
        if (!appId) return null;
        const id = appId.toLowerCase();
        
        // Exact match
        let found = apps.find(a => a.id.toLowerCase() === id);
        if (found) return found;
        
        // Try with .desktop extension or without
        found = apps.find(a => a.id.toLowerCase() === id + ".desktop" || a.id.toLowerCase() + ".desktop" === id);
        if (found) return found;
        
        return null;
    }

    Process {
        id: reader
        // Qt.resolvedUrl returns file://..., so we need to remove it to get the path
        command: ["python3", String(Qt.resolvedUrl("../etc/list_apps.py")).replace("file://", ""), "--json"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const loaded = JSON.parse(this.text.trim());
                    if (Array.isArray(loaded)) {
                        root.apps = loaded;
                    }
                } catch(e) {
                    console.log("Failed to parse apps json:", e);
                }
            }
        }
    }
}
