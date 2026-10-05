pragma Singleton
import QtQuick
import Quickshell

// App IDs pinned to the taskbar (case-insensitive).
Singleton {
    id: root

    property var apps: []

    function isPinned(appId) {
        if (!appId) return false;
        const id = appId.toLowerCase();
        return apps.some(a => a.toLowerCase() === id);
    }

    function toggle(appId) {
        if (!appId) return;
        const id = appId.toLowerCase();
        apps = isPinned(appId) ? apps.filter(a => a.toLowerCase() !== id) : apps.concat([appId]);
    }
}
