import QtQuick
import QtQuick.Layouts

// A Card that stacks MenuItems vertically.
Card {
    default property alias items: column.data

    implicitWidth: 160
    implicitHeight: column.implicitHeight + 16

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4
    }
}
