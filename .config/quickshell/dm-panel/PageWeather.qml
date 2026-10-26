import QtQuick
import QtQuick.Layouts

// ─────────── Clima: actual + 3 días ───────────
ColumnLayout {
    id: page
    spacing: 12

    Card {
        Layout.fillWidth: true
        padding: 16

        RowLayout {
            Layout.fillWidth: true
            spacing: 16
            Glyph {
                text: Weather.icon
                font.pixelSize: 56
                color: Theme.accent
                SequentialAnimation on y {
                    running: page.visible
                    loops: Animation.Infinite
                    NumberAnimation { from: 0; to: -4; duration: 2200; easing.type: Easing.InOutSine }
                    NumberAnimation { from: -4; to: 0; duration: 2200; easing.type: Easing.InOutSine }
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Txt { text: Weather.temp + "°C"; font.pixelSize: 36; font.weight: Font.Light }
                Txt { text: Weather.desc; color: Theme.muted; Layout.fillWidth: true; font.capitalization: Font.Capitalize }
            }
        }

        InfoRow { icon: Theme.iTemp; label: "Sensación"; value: Weather.feels + "°C" }
        InfoRow { icon: Theme.iHumidity; label: "Humedad"; value: Weather.humidity + "%" }
        InfoRow { icon: Theme.iWind; label: "Viento"; value: Weather.wind + " km/h" }
        InfoRow { icon: Theme.iHome; label: "Ubicación"; value: Weather.area || "—" }
    }

    Card {
        Layout.fillWidth: true
        title: "Próximos días"

        Repeater {
            model: Weather.days
            delegate: RowLayout {
                required property var modelData
                Layout.fillWidth: true
                spacing: 12
                Txt { text: modelData.name; Layout.preferredWidth: 40; font.pixelSize: Theme.fontSm }
                Glyph { text: modelData.icon; font.pixelSize: 17; color: Theme.accent; Layout.preferredWidth: 22 }
                Txt { text: modelData.desc; color: Theme.muted; font.pixelSize: 10; Layout.fillWidth: true }
                Txt { text: modelData.min + "°"; color: Theme.muted; font.pixelSize: Theme.fontSm }
                Txt { text: modelData.max + "°"; font.pixelSize: Theme.fontSm }
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Txt { text: Weather.ready ? "Actualizado " + Weather.updated + " · wttr.in" : "Sin conexión con wttr.in"; color: Theme.muted; font.pixelSize: 10; Layout.fillWidth: true }
        Button { icon: Theme.iRefresh; label: "Actualizar"; onClicked: Weather.refresh() }
    }

    Item { Layout.fillHeight: true }
}
