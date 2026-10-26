import QtQuick
import QtQuick.Layouts

// Botón rápido (Wi-Fi, Bluetooth, No molestar…)
Rectangle {
    id: t

    property string icon: ""
    property string label: ""
    property string sub: ""
    property bool active: false
    signal clicked()

    implicitHeight: 54
    radius: Theme.radiusMd
    color: active ? Theme.bg3 : (ma.containsMouse ? Theme.bg2 : Theme.cardBg)
    border.width: 1
    border.color: active ? Theme.accentDim : Theme.bg3
    scale: ma.pressed ? 0.96 : 1

    Behavior on color { ColorAnimation { duration: Theme.anim } }
    Behavior on border.color { ColorAnimation { duration: Theme.anim } }
    Behavior on scale { NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutCubic } }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 10
        spacing: 10

        Glyph {
            text: t.icon
            font.pixelSize: 18
            color: t.active ? Theme.accent : Theme.muted
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 1
            Txt {
                text: t.label
                Layout.fillWidth: true
                color: t.active ? Theme.fg : Theme.muted
                font.weight: Font.Medium
                Behavior on color { ColorAnimation { duration: Theme.anim } }
            }
            Txt {
                text: t.sub
                visible: text !== ""
                Layout.fillWidth: true
                color: Theme.muted
                font.pixelSize: 10
            }
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: t.clicked()
    }
}
