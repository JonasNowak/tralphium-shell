pragma Singleton
import QtQuick
import Quickshell

// Session / power actions.
Singleton {
    function powerOff() { Quickshell.execDetached(["systemctl", "poweroff"]); }
    function reboot() { Quickshell.execDetached(["systemctl", "reboot"]); }
    function suspend() { Quickshell.execDetached(["systemctl", "suspend"]); }
    function lock() { Quickshell.execDetached(["loginctl", "lock-session"]); }
    function signOut() { Quickshell.execDetached(["killall", "mango"]); }
}
