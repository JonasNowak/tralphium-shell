import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    Process {
        id: proc
        command: ["python3", "-c", "import json; print(json.dumps([{'id':'test'}]))"]
        running: true
        stdout: ProcessIo {
            onStringDataChanged: {
                console.log("Stdout:", stringData);
            }
        }
        onExited: {
            console.log("Exited");
            Quickshell.exit(0);
        }
    }
}
