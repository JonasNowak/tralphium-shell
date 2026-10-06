import QtQuick
import Quickshell

ShellRoot {
    Component.onCompleted: {
        console.log("QML URL:", Qt.resolvedUrl("."));
        Quickshell.exit(0);
    }
}
