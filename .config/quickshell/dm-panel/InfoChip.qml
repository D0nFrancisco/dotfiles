import QtQuick
import QtQuick.Layouts

// Ícono + valor pequeño (pie de las gráficas)
RowLayout {
    id: c

    property string icon: ""
    property string text: ""
    property bool hot: false
    property bool dim: false

    spacing: 5
    Glyph { text: c.icon; font.pixelSize: 12; color: c.hot ? Theme.alert : Theme.muted }
    Txt {
        text: c.text
        font.pixelSize: Theme.fontSm
        color: c.hot ? Theme.alert : (c.dim ? Theme.muted : Theme.fg)
        Behavior on color { ColorAnimation { duration: Theme.anim } }
    }
}
