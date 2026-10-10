import QtQuick
import Quickshell
import "components/settings"

ShellRoot {
    SettingsWindow { id: settings; Component.onCompleted: open() }
}
