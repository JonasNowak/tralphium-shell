pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    function take() {
        Quickshell.execDetached(["sh", "-c", "sleep 0.05 && FILE=~/Pictures/Screenshot_$(date +%s).png && slurp | grim -g - \"$FILE\" && wl-copy < \"$FILE\" && notify-send -a \"ScreenshotTool\" -i \"$FILE\" 'Screenshot' 'Copied to clipboard.'"]);
    }
}
