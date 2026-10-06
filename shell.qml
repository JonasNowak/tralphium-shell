import QtQuick
import Quickshell
import Quickshell.Io
import qs.components.shelf
import qs.components.launchpad
import qs.components.controlpanel
import qs.components.powermenu
import qs.components.topbar
import qs.services

// Entry point: wires the shell's top-level surfaces together.
// The active theme is selected in themes/Theme.qml.
ShellRoot {
    id: shellRoot
    
    // Feature toggle for the optional Googlebook style top bar
    property bool enableTopBar: false



    TopBar {
        visible: shellRoot.enableTopBar
    }

    Shelf {
        launcherActive: launchpad.visible
        onLauncherClicked: {
            controlPanel.close();
            launchpad.toggle();
        }
        onStatusClicked: {
            launchpad.close();
            controlPanel.toggle();
        }
        onBackgroundClicked: {
            controlPanel.close();
            launchpad.close();
        }
        onToggleTopBarClicked: {
            shellRoot.enableTopBar = !shellRoot.enableTopBar;
        }
    }

    Launchpad { id: launchpad }

    ControlPanel {
        id: controlPanel
        onPowerMenuRequested: powerMenu.open()
    }
    
    Toasts {
    }

    PowerMenu { id: powerMenu }

    // e.g. bind a key to: qs ipc call shell toggleLaunchpad
    IpcHandler {
        target: "shell"
        function toggleLaunchpad() {
            controlPanel.close();
            launchpad.toggle();
        }
        function toggleControlPanel() {
            launchpad.close();
            controlPanel.toggle();
        }
        function openPowerMenu() {
            powerMenu.open();
        }
        function takeScreenshot() {
            Screenshot.take();
        }
    }
}
