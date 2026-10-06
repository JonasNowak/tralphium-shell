import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.themes
import qs.widgets

PanelWindow {
    id: root
    
    anchors {
        bottom: true
        right: true
    }
    
    margins {
        bottom: 4
        right: 4
    }

    width: 380
    // Perfectly wrap the list height so the window bounds adapt exactly to the toasts
    height: listView.contentHeight
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
                    model.notif.dismiss();
                    NotificationService.toasts.remove(index);
                }
            }

            Timer {
                id: toastTimer
                interval: 4000
                running: true
                onTriggered: delegateRoot.performDismiss()
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
                                            Quickshell.execDetached(["sh", "-c", "echo '" + p + "' >> /tmp/gimp_debug.txt"]);
                                            Quickshell.execDetached(["gimp", p]);
                                            delegateRoot.performDismiss();
                                        }
                                    }
                                    ActionButton {
                                        text: "Share"
                                        onClicked: {
                                            let p = model.notif.image || model.notif.icon || "";
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
}
