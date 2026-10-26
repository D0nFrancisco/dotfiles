import QtQuick
import QtQuick.Layouts

// Fila: ícono · etiqueta ······ valor
RowLayout {
    id: r

    property string icon: ""
    property string label: ""
    property string value: ""

    Layout.fillWidth: true
    spacing: 8

    Glyph {
        text: r.icon
        visible: r.icon !== ""
        font.pixelSize: 13
        color: Theme.muted
        Layout.preferredWidth: 16
    }
    Txt {
        text: r.label
        color: r.value === "" ? Theme.fg : Theme.muted
        font.pixelSize: Theme.fontSm
        Layout.fillWidth: true
    }
    Txt {
        text: r.value
        visible: r.value !== ""
        font.pixelSize: Theme.fontSm
        horizontalAlignment: Text.AlignRight
        Layout.maximumWidth: 210
    }
}
