import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.themes
import qs.widgets

// Quick settings panel (bottom right): session buttons, toggles, sliders, date & battery.
Overlay {
    id: root
    signal powerMenuRequested()

    property bool nightLightOn: false

    function run(cmd) { Quickshell.execDetached(["sh", "-c", cmd]); }

    onVisibleChanged: {
        if (!visible) return;
        Audio.refresh();
        Brightness.refresh();
        Battery.refresh();
    }

    // First click outside closes the sink menu, the next one the panel
    onBackgroundClicked: {
        if (sinkMenu.visible) sinkMenu.visible = false;
        else close();
    }

    SystemClock { id: clock; precision: SystemClock.Minutes }

    Card {
        id: panel
        width: 380
        height: layout.implicitHeight + 32
        anchors { right: parent.right; bottom: parent.bottom; margins: 4 }
        radius: 24
        onClicked: sinkMenu.visible = false

        ColumnLayout {
            id: layout
            anchors.fill: parent
            anchors.margins: 16
            spacing: 20

            // Profile, sign out and session buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                IconButton {
                    icon: "person"
                    enabled: false
                    baseColor: Theme.alpha(Theme.buttonHover, 0.5)
                }

                Rectangle {
                    implicitWidth: 80
                    implicitHeight: 36
                    radius: 18
                    color: signOutMouse.containsMouse ? Theme.hover : "transparent"
                    border.color: Theme.hover
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Sign out"
                        color: Theme.textForeground
                        font.pixelSize: 13
                        font.bold: true
                    }

                    MouseArea {
                        id: signOutMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Session.signOut()
                    }
                }

                Item { Layout.fillWidth: true }

                RowLayout {
                    spacing: 4

                    IconButton {
                        icon: "power_settings_new"
                        onClicked: {
                            root.close();
                            root.powerMenuRequested();
                        }
                    }
                    IconButton { icon: "lock"; onClicked: Session.lock() }
                    IconButton { icon: "settings"; onClicked: root.run("kitty -e vim ~/.config/mango/config.conf") }
                    IconButton { icon: "expand_more" }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 3
                rowSpacing: 16
                columnSpacing: 8

                QuickToggle {
                    icon: "wifi"; title: "Network"; subtitle: "Strong"; active: true
                    onClicked: root.run("kitty -e nmtui")
                }
                QuickToggle {
                    icon: "bluetooth"; title: "Bluetooth"; subtitle: "On"; active: true
                    onClicked: root.run("kitty -e bluetui")
                }
                QuickToggle { icon: "accessibility_new"; title: "Accessibility" }
                QuickToggle { icon: "notifications"; title: "Notifications"; subtitle: "On, all apps"; active: true }
                QuickToggle {
                    icon: "screenshot_monitor"; title: "Screen capture"
                    onClicked: {
                        root.close();
                        root.run("sleep 0.05 && slurp | grim -g - ~/Pictures/Screenshot_$(date +%s).png");
                    }
                }
                QuickToggle { icon: "visibility_off"; title: "Nearby visibility"; subtitle: "Off" }
                QuickToggle {
                    icon: "dark_mode"; title: "Night Light"
                    subtitle: root.nightLightOn ? "On" : "Off"
                    active: root.nightLightOn
                    onClicked: {
                        root.nightLightOn = !root.nightLightOn;
                        root.run("(killall gammastep; gammastep " + (root.nightLightOn ? "-O 4000" : "-x") + ") >/dev/null 2>&1");
                    }
                }
                QuickToggle {
                    icon: "wifi_tethering"; title: "Share"
                    onClicked: {
                        root.close();
                        root.run("localsend");
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16

                SliderRow {
                    icon: "volume_up"
                    trailingIcon: "chevron_right"
                    value: Audio.volume
                    onMoved: value => Audio.setVolume(value)
                    onTrailingClicked: {
                        Audio.refreshSinks();
                        sinkMenu.visible = true;
                    }
                }

                SliderRow {
                    icon: "light_mode"
                    value: Brightness.value
                    onMoved: value => Brightness.set(value)
                }
            }

            // Date & battery
            RowLayout {
                spacing: 8

                Text { text: Qt.formatDate(clock.date, "ddd, MMM d"); color: Theme.textForeground; font.pixelSize: 13; font.bold: true }
                Text { text: "•"; color: Theme.textSecondary; font.pixelSize: 13 }
                Text { text: Battery.description; color: Theme.textForeground; font.pixelSize: 13 }
            }
        }

        // Audio output picker
        MenuCard {
            id: sinkMenu
            visible: false
            z: 1
            implicitWidth: 260
            anchors { right: parent.right; bottom: parent.bottom; rightMargin: 16; bottomMargin: 120 }

            Repeater {
                model: Audio.sinks
                delegate: MenuItem {
                    text: modelData.name
                    checked: modelData.isDefault
                    onClicked: {
                        sinkMenu.visible = false;
                        Audio.setDefaultSink(modelData.id);
                    }
                }
            }
        }
    }
}
