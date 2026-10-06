pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// App IDs pinned to the taskbar (case-insensitive), persisted in ~/.config/tralphium/pins.json.
Singleton {
    id: root

    property alias apps: appsModel
    // Lower-cased ids, replaced on every change so bindings calling isPinned() re-evaluate
    property var _keys: []

    ListModel { id: appsModel }

    function isPinned(appId) { return !!appId && _keys.includes(appId.toLowerCase()); }

    // Rebuilds the lookup table from the model and optionally persists it
    function _changed(save) {
        const ids = [];
        for (let i = 0; i < appsModel.count; i++) ids.push(appsModel.get(i).appId);
        _keys = ids.map(id => id.toLowerCase());
        if (save) file.setText(JSON.stringify(ids));
    }

    function insertPin(appId, index) {
        if (!appId) return;
        const existing = _keys.indexOf(appId.toLowerCase());
        if (existing !== -1) appsModel.move(existing, index, 1);
        else appsModel.insert(Math.min(index, appsModel.count), { appId: appId });
        _changed(true);
    }

    function toggle(appId) {
        if (!appId) return;
        const existing = _keys.indexOf(appId.toLowerCase());
        if (existing !== -1) appsModel.remove(existing, 1);
        else appsModel.append({ appId: appId });
        _changed(true);
    }

    function move(fromIndex, toIndex) {
        if (fromIndex === toIndex || fromIndex < 0 || toIndex < 0 || fromIndex >= appsModel.count || toIndex >= appsModel.count) return;
        appsModel.move(fromIndex, toIndex, 1);
        _changed(true);
    }

    FileView {
        id: file
        path: Quickshell.env("HOME") + "/.config/tralphium/pins.json"
        printErrors: false
        onLoaded: {
            try {
                const loaded = JSON.parse(text());
                if (!Array.isArray(loaded)) return;
                appsModel.clear();
                loaded.forEach(appId => appsModel.append({ appId: appId }));
                root._changed(false);
            } catch (e) {}
        }
        // First run: make sure the config directory exists before the first save
        onLoadFailed: Quickshell.execDetached(["mkdir", "-p", Quickshell.env("HOME") + "/.config/tralphium"])
    }
}
