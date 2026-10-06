pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias apps: appsModel

    ListModel {
        id: appsModel
    }

    function isHidden(appId) {
        if (!appId) return false;
        const id = appId.toLowerCase();
        for (let i = 0; i < appsModel.count; i++) {
            if (appsModel.get(i).appId.toLowerCase() === id) return true;
        }
        return false;
    }

    function save() {
        let arr = [];
        for (let i = 0; i < appsModel.count; i++) {
            arr.push(appsModel.get(i).appId);
        }
        const json = JSON.stringify(arr).replace(/'/g, "'\\''");
        Quickshell.execDetached(["sh", "-c", "mkdir -p ~/.config/tralphium && echo '" + json + "' > ~/.config/tralphium/hidden_apps.json"]);
    }

    function toggle(appId) {
        if (!appId) return;
        const id = appId.toLowerCase();
        if (isHidden(appId)) {
            for (let i = 0; i < appsModel.count; i++) {
                if (appsModel.get(i).appId.toLowerCase() === id) {
                    appsModel.remove(i, 1);
                    break;
                }
            }
        } else {
            appsModel.append({ appId: appId });
        }
        save();
    }

    Process {
        command: ["cat", Quickshell.env("HOME") + "/.config/tralphium/hidden_apps.json"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const loaded = JSON.parse(this.text.trim());
                    if (Array.isArray(loaded)) {
                        appsModel.clear();
                        loaded.forEach(a => appsModel.append({ appId: a }));
                    }
                } catch(e) {}
            }
        }
    }
}
