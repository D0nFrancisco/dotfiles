import QtQuick
import QtQuick.Layouts

// Fila seleccionable (dispositivos de audio, redes, Bluetooth)
Rectangle {
    id: r

    property string icon: ""
    property string label: ""
    property string sub: ""
    property string trailing: ""
    property bool selected: false
    signal clicked()

    Layout.fillWidth: true
    implicitHeight: sub !== "" ? 42 : 34
    radius: Theme.radiusSm
    color: selected ? Theme.bg3 : (ma.containsMouse ? Theme.bg2 : "transparent")
    Behavior on color { ColorAnimation { duration: Theme.animFast } }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 10

        Glyph {
            text: r.icon
            font.pixelSize: 15
            color: r.selected ? Theme.accent : Theme.muted
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0
            Txt { text: r.label; Layout.fillWidth: true; font.pixelSize: Theme.fontSm; color: r.selected ? Theme.fg : Qt.darker(Theme.fg, 1.1) }
            Txt { text: r.sub; visible: text !== ""; Layout.fillWidth: true; font.pixelSize: 10; color: Theme.muted }
        }
        Txt {
            text: r.trailing
            visible: text !== ""
            font.pixelSize: 10
            color: Theme.muted
        }
        Glyph {
            text: Theme.iCheck
            visible: r.selected
            font.pixelSize: 13
            color: Theme.accent
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: r.clicked()
    }
}
