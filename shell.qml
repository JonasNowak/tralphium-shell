import QtQuick
import Quickshell
import Quickshell.Io
import qs.components.shelf
import qs.components.launchpad
import qs.components.controlpanel
import qs.components.powermenu

// Entry point: wires the shell's top-level surfaces together.
// The active theme is selected in themes/Theme.qml.
ShellRoot {
    Shelf {
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
    }

    Launchpad { id: launchpad }

    ControlPanel {
        id: controlPanel
        onPowerMenuRequested: powerMenu.open()
    }

    PowerMenu { id: powerMenu }

    // e.g. bind a key to: qs ipc call shell toggleLaunchpad
    IpcHandler {
        target: "shell"
        function toggleLaunchpad() {
            controlPanel.close();
            launchpad.toggle();
        }
    }
}
