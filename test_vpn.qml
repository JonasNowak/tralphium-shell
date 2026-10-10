import QtQuick
import Quickshell
import qs.services

ShellRoot {
    Component.onCompleted: {
        console.log("VPNs:", JSON.stringify(Vpn.vpns));
        console.log("Current VPN:", Vpn.currentVpn);
        Qt.quit();
    }
}
