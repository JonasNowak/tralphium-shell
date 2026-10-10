pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    // Update DBus environment for Wayland
    Process { command: ["sh", "-c", "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"]; running: true }
    
    // Start standard desktop environment services
    Process { command: ["sh", "-c", "pgrep -x wireplumber || wireplumber &"]; running: true }
    Process { command: ["sh", "-c", "pgrep -x pipewire || pipewire &"]; running: true }
    Process { command: ["sh", "-c", "pgrep -x pipewire-pulse || pipewire-pulse &"]; running: true }
    
    // Start polkit agent
    Process { 
        command: ["sh", "-c", "pgrep -f polkit-gnome-authentication-agent-1 || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"]
        running: true 
    }
}
