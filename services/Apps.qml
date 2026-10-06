pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Installed apps (from etc/list_apps.py), with an id index for fast lookups.
Singleton {
    id: root

    property var apps: []
    property var _byId: new Map() // lower-cased id -> app

    function refresh() {
        if (!reader.running) reader.running = true;
    }

    // Matches the app id case-insensitively, with or without a ".desktop" suffix
    function findApp(appId) {
        if (!appId) return null;
        const id = appId.toLowerCase();
        return _byId.get(id) || _byId.get(id.replace(/\.desktop$/, "")) || null;
    }

    Process {
        id: reader
        command: ["python3", Quickshell.shellPath("etc/list_apps.py")]
        running: true
        stdout: StdioCollector {
            property string last: ""
            onStreamFinished: {
                // Unchanged: keep the current model so no delegates get rebuilt
                if (text === last) return;
                last = text;
                try {
                    const loaded = JSON.parse(text);
                    if (!Array.isArray(loaded)) return;
                    const byId = new Map();
                    for (const app of loaded) {
                        app.search = (app.name + "\n" + app.id).toLowerCase();
                        if (!byId.has(app.id.toLowerCase())) byId.set(app.id.toLowerCase(), app);
                    }
                    root._byId = byId;
                    root.apps = loaded;
                } catch (e) {
                    console.log("Failed to parse apps json:", e);
                }
            }
        }
    }
}
