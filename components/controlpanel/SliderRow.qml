import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.themes
import qs.widgets

// Icon + slider + optional trailing button. `value` is 0..1.
RowLayout {
    id: root
    property alias icon: leading.icon
    property alias trailingIcon: trailing.icon
    property real value
    signal moved(real value)
    signal trailingClicked()

    Layout.fillWidth: true
    spacing: 16

    // Dragging breaks a declarative binding, so push external changes manually
    onValueChanged: slider.value = value
    Component.onCompleted: slider.value = value

    IconButton {
        id: leading
        implicitWidth: 32
        implicitHeight: 32
        enabled: false
        baseColor: Theme.alpha(Theme.buttonHover, 0.3)
    }

    Slider {
        id: slider
        Layout.fillWidth: true
        onMoved: root.moved(value)
    }

    // Kept (invisible) when unused so all sliders line up
    IconButton {
        id: trailing
        implicitWidth: 32
        implicitHeight: 32
        iconSize: 24
        opacity: icon ? 1 : 0
        enabled: icon !== ""
        baseColor: Theme.alpha(Theme.buttonHover, 0.3)
        onClicked: root.trailingClicked()
    }
}
