import QtQuick
import qs.themes

// App icon that falls back to `fallbackSource`, then to the name's initials.
Item {
    id: root
    property string source
    property string fallbackSource
    property string name
    property int initialsSize: 14

    Image {
        id: image
        anchors.fill: parent
        source: root.source
        fillMode: Image.PreserveAspectFit
        onStatusChanged: {
            if (status === Image.Error && root.fallbackSource && source != root.fallbackSource)
                source = root.fallbackSource;
        }
    }

    Text {
        anchors.centerIn: parent
        visible: image.status !== Image.Ready
        text: root.name.substring(0, 2).toUpperCase()
        color: Theme.iconColor
        font.pixelSize: root.initialsSize
        font.bold: true
    }
}
