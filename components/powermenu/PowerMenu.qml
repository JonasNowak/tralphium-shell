import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.themes
import qs.widgets

// Chrome OS style power dialog centered on a dimmed screen.
Overlay {
    id: root

    exclusionMode: ExclusionMode.Ignore // also cover the shelf
    color: Qt.rgba(0, 0, 0, 0.35)

    onBackgroundClicked: close()
    onVisibleChanged: if (visible) card.forceActiveFocus()

    Card {
        id: card
        anchors.centerIn: parent
        width: options.implicitWidth + 32
        height: options.implicitHeight + 32
        focus: true
        Keys.onEscapePressed: root.close()

        RowLayout {
            id: options
            anchors.centerIn: parent
            spacing: 4

            Repeater {
                model: [
                    { icon: "power_settings_new", label: "Shut down", action: "powerOff" },
                    { icon: "restart_alt",        label: "Restart",   action: "reboot" },
                    { icon: "bedtime",            label: "Sleep",     action: "suspend" },
                    { icon: "logout",             label: "Sign out",  action: "signOut" },
                    { icon: "lock",               label: "Lock",      action: "lock" }
                ]
                delegate: Rectangle {
                    implicitWidth: 84
                    implicitHeight: 80
                    radius: 12
                    color: mouse.containsMouse ? Theme.hover : "transparent"

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8

                        MaterialIcon { Layout.alignment: Qt.AlignHCenter; text: modelData.icon; font.pixelSize: 24 }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: modelData.label
                            color: Theme.alpha(Theme.textForeground, 0.8)
                            font.pixelSize: 12
                        }
                    }

                    MouseArea {
                        id: mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            root.close();
                            Session[modelData.action]();
                        }
                    }
                }
            }
        }
    }
}
