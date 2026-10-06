pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Single unified configuration service for Tralphium settings.
// Persisted at ~/.config/tralphium/config.json with bi-directional synchronization.
Singleton {
    id: root

    readonly property string configPath: Quickshell.env("HOME") + "/.config/tralphium/config.json"

    // Theme setting ("nord", "cappuccino", etc.)
    property string theme: "nord"

    // Menu bar (Top bar) visibility toggle
    property bool menuBar: false
    property alias topBar: root.menuBar
    property alias enableTopBar: root.menuBar

    // Standard default applications
    property var apps: ({
        terminal: "kitty",
        fileManager: "kitty -e yazi",
        taskManager: "kitty -e btop",
        editor: "kitty -e vim",
        browser: "helium-browser",
        imageEditor: "gimp",
        share: "localsend",
        networkManager: "kitty -e nmtui",
        bluetoothManager: "kitty -e bluetui"
    })

    // Notification settings
    property bool notificationsEnabled: true

    // Synchronization state
    property string _lastText: ""
    property bool _isLoading: false
    property bool _isSaving: false

    FileView {
        id: configFile
        path: root.configPath
        watchChanges: true
        printErrors: false

        onLoaded: root._handleLoaded(text())
        onLoadFailed: root._handleLoadFailed()
        onFileChanged: {
            if (!root._isSaving) reload();
        }
        onSaved: {
            root._isSaving = false;
        }
    }

    Timer {
        id: saveTimer
        interval: 30
        repeat: false
        onTriggered: root._doSave()
    }

    function save() {
        if (_isLoading) return;
        saveTimer.restart();
    }

    function reload() {
        configFile.reload();
    }

    function toggleTopBar() {
        menuBar = !menuBar;
        save();
    }

    function toggleMenuBar() {
        toggleTopBar();
    }

    function toggleTheme() {
        theme = (theme === "nord" ? "cappuccino" : "nord");
        save();
    }

    function setTheme(name) {
        if (!name) return;
        if (theme !== name) {
            theme = name;
            save();
        }
    }

    function setTopBar(val) {
        if (menuBar !== val) {
            menuBar = val;
            save();
        }
    }

    function setNotificationsEnabled(val) {
        if (notificationsEnabled !== val) {
            notificationsEnabled = val;
            save();
        }
    }

    function _doSave() {
        const data = {
            theme: root.theme,
            menuBar: root.menuBar,
            apps: {
                terminal: (root.apps && root.apps.terminal) || "kitty",
                fileManager: (root.apps && root.apps.fileManager) || "kitty -e yazi",
                taskManager: (root.apps && root.apps.taskManager) || "kitty -e btop",
                editor: (root.apps && root.apps.editor) || "kitty -e vim",
                browser: (root.apps && root.apps.browser) || "helium-browser",
                imageEditor: (root.apps && root.apps.imageEditor) || "gimp",
                share: (root.apps && root.apps.share) || "localsend",
                networkManager: (root.apps && root.apps.networkManager) || "kitty -e nmtui",
                bluetoothManager: (root.apps && root.apps.bluetoothManager) || "kitty -e bluetui"
            },
            notifications: {
                enabled: root.notificationsEnabled
            }
        };

        const json = JSON.stringify(data, null, 2);
        if (json.trim() === _lastText.trim() && _lastText !== "") return;
        _lastText = json;
        _isSaving = true;

        configFile.setText(json);
    }

    function _handleLoaded(raw) {
        if (!raw || raw.trim() === "") return;
        if (raw.trim() === _lastText.trim()) return;
        _lastText = raw.trim();

        try {
            const data = JSON.parse(raw);
            _isLoading = true;

            if (data.theme && typeof data.theme === "string") {
                root.theme = data.theme;
            }

            if (data.menuBar !== undefined) {
                root.menuBar = Boolean(data.menuBar);
            } else if (data.topBar !== undefined) {
                root.menuBar = Boolean(data.topBar);
            } else if (data.enableTopBar !== undefined) {
                root.menuBar = Boolean(data.enableTopBar);
            }

            if (data.apps && typeof data.apps === "object") {
                root.apps = Object.assign({}, root.apps, data.apps);
            } else if (data.standardApps && typeof data.standardApps === "object") {
                root.apps = Object.assign({}, root.apps, data.standardApps);
            }

            if (data.notifications && typeof data.notifications === "object" && data.notifications.enabled !== undefined) {
                root.notificationsEnabled = Boolean(data.notifications.enabled);
            } else if (data.notificationsEnabled !== undefined) {
                root.notificationsEnabled = Boolean(data.notificationsEnabled);
            }

            _isLoading = false;
        } catch (e) {
            _isLoading = false;
            console.warn("Failed to parse config.json:", e);
        }
    }

    function _handleLoadFailed() {
        Quickshell.execDetached(["mkdir", "-p", Quickshell.env("HOME") + "/.config/tralphium"]);
    }

    // Execution helpers for standard applications
    function launch(cmd) {
        if (!cmd || cmd.trim() === "") return;
        Quickshell.execDetached(["sh", "-c", cmd]);
    }

    function launchTerminal(args) {
        const term = (apps && apps.terminal) ? apps.terminal : "kitty";
        if (args) launch(term + " " + args);
        else launch(term);
    }

    function launchFileManager(path) {
        const fm = (apps && apps.fileManager) ? apps.fileManager : "kitty -e yazi";
        if (path) launch(fm + ' "' + path + '"');
        else launch(fm);
    }

    function launchTaskManager() {
        const tm = (apps && apps.taskManager) ? apps.taskManager : "kitty -e btop";
        launch(tm);
    }

    function launchEditor(file) {
        const ed = (apps && apps.editor) ? apps.editor : "kitty -e vim";
        if (file) launch(ed + ' "' + file + '"');
        else launch(ed);
    }

    function launchBrowser(url) {
        const br = (apps && apps.browser) ? apps.browser : "helium-browser";
        if (url) launch(br + ' "' + url + '"');
        else launch(br);
    }

    function launchImageEditor(file) {
        const img = (apps && apps.imageEditor) ? apps.imageEditor : "gimp";
        if (file) launch(img + ' "' + file + '"');
        else launch(img);
    }

    function launchShare(file) {
        const sh = (apps && apps.share) ? apps.share : "localsend";
        if (file) launch(sh + ' "' + file + '"');
        else launch(sh);
    }

    function launchNetworkManager() {
        const nm = (apps && apps.networkManager) ? apps.networkManager : ((apps && apps.terminal ? apps.terminal : "kitty") + " -e nmtui");
        launch(nm);
    }

    function launchBluetoothManager() {
        const bm = (apps && apps.bluetoothManager) ? apps.bluetoothManager : ((apps && apps.terminal ? apps.terminal : "kitty") + " -e bluetui");
        launch(bm);
    }

    function openConfig() {
        launchEditor(configPath);
    }
}
