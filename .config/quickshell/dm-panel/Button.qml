import QtQuick
import QtQuick.Layouts

// Botón de texto con ícono (abrir pavucontrol, actualizar…)
Rectangle {
    id: b

    property string icon: ""
    property string label: ""
    signal clicked()

    implicitHeight: 32
    implicitWidth: row.implicitWidth + 24
    radius: Theme.radiusSm
    color: ma.containsMouse ? Theme.bg3 : Theme.bg2
    border.width: 1
    border.color: Theme.bg3
    scale: ma.pressed ? 0.96 : 1
    Behavior on color { ColorAnimation { duration: Theme.animFast } }
    Behavior on scale { NumberAnimation { duration: Theme.animFast } }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 8
        Glyph { text: b.icon; visible: b.icon !== ""; font.pixelSize: 14; color: ma.containsMouse ? Theme.accent : Theme.muted }
        Txt { text: b.label; font.pixelSize: Theme.fontSm }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: b.clicked()
    }
}
