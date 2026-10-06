import QtQuick
import QtQuick.Layouts
import Quickshell

// Light notification card shared by the toasts and the control panel list.
// Emits dismissRequested() when the close button or one of the screenshot actions is used.
Card {
    id: root
    required property var notif
    signal dismissRequested()

    // Path of the attached image, without a file:// prefix
    readonly property string file: (notif.image || notif.icon || "").replace(/^file:\/\//, "")

    function run(command) {
        Quickshell.execDetached(command);
        dismissRequested();
    }

    implicitHeight: row.implicitHeight + 24
    color: "#f8f9fa"
    border.color: "#e9ecef"

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Image {
            source: root.notif.image || (root.notif.icon ? (root.notif.icon.startsWith("/") ? "file://" + root.notif.icon : root.notif.icon) : "")
            visible: source != ""
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true

                Text {
                    Layout.fillWidth: true
                    text: root.notif.appName || "System"
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
                    onClicked: root.dismissRequested()
                }
            }

            Text {
                Layout.fillWidth: true
                text: root.notif.summary
                color: "#202124"
                font.pixelSize: 14
                font.bold: true
                wrapMode: Text.Wrap
            }

            Text {
                Layout.fillWidth: true
                text: root.notif.body
                color: "#5f6368"
                font.pixelSize: 13
                wrapMode: Text.Wrap
                visible: root.notif.body !== ""
            }

            RowLayout {
                Layout.fillWidth: true
                visible: root.notif.appName === "ScreenshotTool"
                spacing: 8

                ActionButton { text: "Edit"; onClicked: root.run(["gimp", root.file]) }
                ActionButton { text: "Share"; onClicked: root.run(["localsend", root.file]) }
                ActionButton { text: "AI"; onClicked: root.run(["helium-browser", "https://gemini.google.com/"]) }
            }
        }
    }
}
