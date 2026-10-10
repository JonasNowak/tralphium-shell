import QtQuick
import QtQuick.Dialogs
import Quickshell

ShellRoot {
    FileDialog {
        id: fd
        Component.onCompleted: {
            console.log("FileDialog properties:", Object.keys(fd).join(", "));
            // fd.open()
        }
    }
}
