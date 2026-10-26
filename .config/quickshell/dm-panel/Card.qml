import QtQuick
import QtQuick.Layouts

// Tarjeta: fondo carbón, borde de 1 px, título opcional
Rectangle {
    id: card

    property string title: ""
    property string trailing: ""
    property int padding: 12
    default property alias content: body.data

    color: Theme.cardBg
    radius: Theme.radiusMd
    border.width: 1
    border.color: hover.hovered ? Qt.lighter(Theme.bg3, 1.35) : Theme.bg3
    implicitHeight: col.implicitHeight + padding * 2
    Behavior on border.color { ColorAnimation { duration: Theme.anim } }

    HoverHandler { id: hover }

    ColumnLayout {
        id: col
        anchors.fill: parent
        anchors.margins: card.padding
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            visible: card.title !== "" || card.trailing !== ""
            Txt {
                text: card.title
                font.pixelSize: 13
                font.weight: Font.DemiBold
                Layout.fillWidth: true
            }
            Txt {
                text: card.trailing
                color: Theme.muted
                font.pixelSize: Theme.fontSm
            }
        }

        ColumnLayout {
            id: body
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6
        }
    }
}
