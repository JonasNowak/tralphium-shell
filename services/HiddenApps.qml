pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// App IDs hidden from the launchpad (lower-cased), persisted in ~/.config/tralphium/hidden_apps.json.
Singleton {
    id: root

    // Replaced, never mutated, so bindings calling isHidden() re-evaluate
    property var ids: []
    readonly property int count: ids.length

    // Backwards-compatible object for callers expecting HiddenApps.apps.count
    readonly property var apps: ({
        count: root.ids.length
    })

    function isHidden(appId) { return !!appId && ids.includes(appId.toLowerCase()); }

    function toggle(appId) {
        if (!appId) return;
        const id = appId.toLowerCase();
        ids = isHidden(id) ? ids.filter(i => i !== id) : ids.concat(id);
        file.setText(JSON.stringify(ids));
    }

    FileView {
        id: file
        path: Quickshell.env("HOME") + "/.config/tralphium/hidden_apps.json"
        printErrors: false
        onLoaded: {
            try {
                const loaded = JSON.parse(text());
                if (Array.isArray(loaded)) root.ids = loaded.map(id => id.toLowerCase());
            } catch (e) {}
        }
        // First run: make sure the config directory exists before the first save
        onLoadFailed: Quickshell.execDetached(["mkdir", "-p", Quickshell.env("HOME") + "/.config/tralphium"])
    }
}
