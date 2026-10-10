import QtQuick
import Quickshell
import qs.services

ShellRoot {
    Component.onCompleted: {
        console.log("Loading Vpn...");
    }
    
    Connections {
        target: Vpn
        function onVpnsChanged() {
            console.log("VPN count:", Vpn.vpnCount);
            Qt.quit();
        }
    }
}
