import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.themes
import qs.widgets

PanelWindow {
    id: root
    WlrLayershell.layer: WlrLayer.Overlay
    
    anchors {
        bottom: true
        right: true
    }
    
    margins {
        bottom: 4
        right: 4
    }

    implicitWidth: 380
    // Perfectly wrap the list height so the window bounds adapt exactly to the toasts
    implicitHeight: listView.contentHeight
    color: "transparent"

    ListView {
        id: listView
        width: parent.width
        height: contentHeight
        spacing: 8
        interactive: false
        model: NotificationService.toasts
        
        // Premium "pop in" enter animation
        add: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.OutCubic }
                NumberAnimation { property: "scale"; from: 0.85; to: 1.0; duration: 250; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
            }
        }

        // Swift slide-out exit animation
        remove: Transition {
            NumberAnimation { property: "opacity"; to: 0; duration: 250; easing.type: Easing.InCubic }
        }
        
        // Fluidly slide remaining toasts around when one leaves or enters
        displaced: Transition {
            NumberAnimation { properties: "y"; duration: 250; easing.type: Easing.OutCubic }
        }
        
        delegate: Item {
            id: delegateRoot
            width: ListView.view.width
            implicitHeight: notifCard.implicitHeight
            
            property bool isDismissing: false
            
            function performDismiss() {
                if (isDismissing) return;
                isDismissing = true;
                toastTimer.stop();
                model.notif.dismiss();
                NotificationService.toasts.remove(index);
            }

            function timeoutToast() {
                if (isDismissing) return;
                isDismissing = true;
                NotificationService.toasts.remove(index);
            }

            Timer {
                id: toastTimer
                interval: 4000
                running: true
                onTriggered: delegateRoot.timeoutToast()
            }

            Item {
                id: dragContainer
                anchors.fill: parent

                Item {
                    anchors.fill: parent

                    Card {
                        id: notifCard
                        width: delegateRoot.width

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.NoButton
                            onWheel: (wheel) => {
                                // Downward scroll corresponds to negative angleDelta.y usually
                                if (wheel.angleDelta.y < -10 || wheel.angleDelta.y > 10) {
                                    if (!swipeDownAnim.running) {
                                        swipeDownAnim.start();
                                    }
                                }
                            }
                        }

                        NumberAnimation on y {
                            id: swipeDownAnim
                            to: 100
                            duration: 200
                            easing.type: Easing.InCubic
                            running: false
                            onFinished: delegateRoot.timeoutToast()
                        }
                        implicitHeight: notifRow.implicitHeight + 24
                        
                        color: "#f8f9fa"
                        border.color: "#e9ecef"
                        
                        HoverHandler {
                            onHoveredChanged: {
                                if (hovered) toastTimer.stop();
                                else toastTimer.restart();
                            }
                        }

                        RowLayout {
                            id: notifRow
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12

                            Image {
                                source: model.notif.image || (model.notif.icon ? (model.notif.icon.startsWith("/") ? "file://" + model.notif.icon : model.notif.icon) : "")
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
                                        text: model.notif.appName || "System"
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
                                    text: model.notif.summary
                                    color: "#202124"
                                    font.pixelSize: 14
                                    font.bold: true
                                    wrapMode: Text.Wrap
                                }
                                
                                Text {
                                    Layout.fillWidth: true
                                    text: model.notif.body
                                    color: "#5f6368"
                                    font.pixelSize: 13
                                    wrapMode: Text.Wrap
                                    visible: model.notif.body !== ""
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    visible: model.notif.appName === "ScreenshotTool"
                                    spacing: 8
                                    
                                    ActionButton {
                                        text: "Edit"
                                        onClicked: {
                                            let p = model.notif.image || model.notif.icon || "";
                                            if (p.startsWith("file://")) p = p.substring(7);
                                            Config.launchImageEditor(p);
                                            delegateRoot.performDismiss();
                                        }
                                    }
                                    ActionButton {
                                        text: "Share"
                                        onClicked: {
                                            let p = model.notif.image || model.notif.icon || "";
                                            if (p.startsWith("file://")) p = p.substring(7);
                                            Config.launchShare(p);
                                            delegateRoot.performDismiss();
                                        }
                                    }
                                    ActionButton {
                                        text: "AI"
                                        onClicked: {
                                            Config.launchBrowser("https://gemini.google.com/");
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
}
