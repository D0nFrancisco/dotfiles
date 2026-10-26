import QtQuick

// Ícono Nerd Font con cambio de color suave
Text {
    font.family: Theme.font
    font.pixelSize: 16
    color: Theme.fg
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    Behavior on color { ColorAnimation { duration: Theme.animFast } }
}
