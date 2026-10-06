import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Services.SystemTray
import qs.services
import qs.themes
import qs.widgets

// Quick settings panel (bottom right): session buttons, toggles, sliders, date & battery.
Overlay {
    id: root
    signal powerMenuRequested()

    property bool nightLightOn: false
    property bool trayExpanded: false
    property bool trayShouldCollapse: false

    Timer {
        id: trayCollapseTimer
        interval: 60000
        onTriggered: {
            root.trayShouldCollapse = true;
        }
    }

    function run(cmd) { Quickshell.execDetached(["sh", "-c", cmd]); }

    onVisibleChanged: {
        if (!visible) {
            if (trayShouldCollapse) {
                trayExpanded = false;
                trayShouldCollapse = false;
            }
            return;
        }
        Audio.refresh();
        Audio.refreshSinks();
        Brightness.refresh();
        Battery.refresh();
        panel.forceActiveFocus();
    }

    // First click outside closes the sink menu, the next one the panel
    onBackgroundClicked: {
        if (sinkMenu.visible) sinkMenu.visible = false;
        else close();
    }

    SystemClock { id: clock; precision: SystemClock.Minutes }

    ColumnLayout {
        anchors { right: parent.right; bottom: parent.bottom; margins: 4 }
        width: 380
        spacing: 8

        ListView {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, root.height - panel.height - 32)
            clip: true
            spacing: 8
            model: NotificationService.server.trackedNotifications
            boundsBehavior: Flickable.StopAtBounds

            // Flip the view so new notifications appear at the bottom, closest to the panel
            
            // To animate adding/removing notifications smoothly
            add: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 } }
            remove: Transition {
                NumberAnimation { property: "opacity"; to: 0; duration: 250; easing.type: Easing.InCubic }
            }
            displaced: Transition { NumberAnimation { properties: "x,y"; duration: 200 } }

            delegate: Item {
                id: delegateRoot
                width: ListView.view.width
                implicitHeight: notifCard.implicitHeight
                
                property bool isDismissing: false
                
                function performDismiss() {
                    if (isDismissing) return;
                    isDismissing = true;
                    
                    // Continue sliding smoothly off-screen to the right
                    flickOutAnim.to = 0;
                    flickOutAnim.start();
                }

                NumberAnimation {
                    id: flickOutAnim
                    target: flickable
                    property: "contentX"
                    duration: 200
                    easing.type: Easing.OutCubic
                    onFinished: {
                        modelData.dismiss();
                    }
                }
                
                Flickable {
                    id: flickable
                    anchors.fill: parent
                    contentWidth: parent.width * 2
                    contentX: parent.width
                    flickableDirection: Flickable.HorizontalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    
                    onContentXChanged: {
                        if (isDismissing) return;
                        if (parent.width - contentX > 80) {
                            delegateRoot.performDismiss();
                        }
                    }
                    
                    onMovementEnded: {
                        if (!isDismissing) {
                            snapAnim.restart();
                        }
                    }
                    
                    NumberAnimation {
                        id: snapAnim
                        target: flickable
                        property: "contentX"
                        to: delegateRoot.width
                        duration: 250
                        easing.type: Easing.OutBack
                    }

                    Item {
                        width: flickable.contentWidth
                        height: flickable.height

                        Card {
                            id: notifCard
                            x: delegateRoot.width
                            width: delegateRoot.width
                            implicitHeight: notifRow.implicitHeight + 24
                            
                            // Chrome OS Light Theme styling
                            color: "#f8f9fa"
                            border.color: "#e9ecef"

                            RowLayout {
                                id: notifRow
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 12

                                Image {
                                    source: modelData.image || (modelData.icon ? (modelData.icon.startsWith("/") ? "file://" + modelData.icon : modelData.icon) : "")
                                    visible: source != ""
                                    Layout.preferredWidth: 48
                                    Layout.preferredHeight: 48
                                    fillMode: Image.PreserveAspectCrop
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4
                                    
                                    RowLayout {
                                        Layout.fillWidth: true
                                        
                                        Text {
                                            Layout.fillWidth: true
                                            text: modelData.appName || "System"
                                            color: "#5f6368"
                                            font.pixelSize: 12
                                        }
                                        
                                        IconButton {
                                            icon: "close"
                                            implicitWidth: 24
                                            implicitHeight: 24
                                            iconSize: 16
                                            iconColor: "#5f6368"
                                            baseColor: "transparent"
                                            onClicked: delegateRoot.performDismiss()
                                        }
                                    }
                                    
                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.summary
                                        color: "#202124"
                                        font.pixelSize: 14
                                        font.bold: true
                                        wrapMode: Text.Wrap
                                    }
                                    
                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.body
                                        color: "#5f6368"
                                        font.pixelSize: 13
                                        wrapMode: Text.Wrap
                                        visible: modelData.body !== ""
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        visible: modelData.appName === "ScreenshotTool"
                                        spacing: 8
                                        
                                        ActionButton {
                                            text: "Edit"
                                            onClicked: {
                                                let p = modelData.image || modelData.icon || "";
                                                if (p.startsWith("file://")) p = p.substring(7);
                                                Quickshell.execDetached(["gimp", p]);
                                                delegateRoot.performDismiss();
                                            }
                                        }
                                        ActionButton {
                                            text: "Share"
                                            onClicked: {
                                                let p = modelData.image || modelData.icon || "";
                                                if (p.startsWith("file://")) p = p.substring(7);
                                                Quickshell.execDetached(["localsend", p]);
                                                delegateRoot.performDismiss();
                                            }
                                        }
                                        ActionButton {
                                            text: "AI"
                                            onClicked: {
                                                Quickshell.execDetached(["helium-browser", "https://gemini.google.com/"]);
                                                delegateRoot.performDismiss();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Card {
            id: panel
            Layout.fillWidth: true
            implicitHeight: layout.implicitHeight + 32
            focus: true
            
            Keys.onEscapePressed: {
                if (sinkMenu.visible) sinkMenu.visible = false;
                else root.close();
            }
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
                        IconButton {
                            icon: root.trayExpanded ? "expand_less" : "expand_more"
                            onClicked: {
                                if (root.trayExpanded) {
                                    root.trayExpanded = false;
                                    root.trayShouldCollapse = false;
                                    trayCollapseTimer.stop();
                                } else {
                                    root.trayExpanded = true;
                                    root.trayShouldCollapse = false;
                                    trayCollapseTimer.restart();
                                }
                            }
                        }
                    }
                }
                
                // System Tray
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.trayExpanded ? 48 : 0
                    visible: Layout.preferredHeight > 0
                    opacity: root.trayExpanded ? 1 : 0
                    color: Theme.hover
                    radius: 12
                    clip: true
                    
                    Behavior on Layout.preferredHeight { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                    ListView {
                        anchors.fill: parent
                        anchors.margins: 8
                        orientation: ListView.Horizontal
                        spacing: 8
                        model: SystemTray.items
                        delegate: Rectangle {
                            width: 32
                            height: 32
                            color: trayMouse.containsMouse ? Theme.textSecondary : "transparent"
                            radius: 8
                            Image {
                                anchors.centerIn: parent
                                width: 24
                                height: 24
                                source: modelData.icon || ""
                                fillMode: Image.PreserveAspectFit
                            }
                            MouseArea {
                                id: trayMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: modelData.activate()
                            }
                        }
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
                    QuickToggle {
                        icon: "notifications"
                        title: "Notifications"
                        subtitle: NotificationService.notificationsEnabled ? "On" : "Off"
                        active: NotificationService.notificationsEnabled
                        onClicked: NotificationService.notificationsEnabled = !NotificationService.notificationsEnabled
                    }
                    QuickToggle {
                        icon: "screenshot_monitor"; title: "Screen capture"
                        onClicked: {
                            root.close();
                            Screenshot.take();
                        }
                    }
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
                        icon: Audio.isMuted ? "volume_off" : "volume_up"
                        trailingIcon: "chevron_right"
                        value: Audio.volume
                        onMoved: value => Audio.setVolume(value)
                        onIconClicked: Audio.toggleMute()
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
