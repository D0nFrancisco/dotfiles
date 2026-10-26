import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth

// ─────────── Bluetooth: adaptador y dispositivos ───────────
Flickable {
    id: page
    contentHeight: col.implicitHeight
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var devices: adapter
        ? adapter.devices.values.slice().sort((a, b) => (b.connected - a.connected) || (b.paired - a.paired) || a.name.localeCompare(b.name))
        : []

    // deja de buscar al salir de la pestaña
    onVisibleChanged: if (!visible && adapter && adapter.discovering) adapter.discovering = false

    ColumnLayout {
        id: col
        width: page.width
        spacing: 12

        Card {
            Layout.fillWidth: true
            visible: !page.adapter
            InfoRow { icon: Theme.iBtOff; label: "No se encontró un adaptador Bluetooth" }
        }

        Card {
            Layout.fillWidth: true
            visible: !!page.adapter
            title: page.adapter ? page.adapter.name : ""

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Toggle {
                    Layout.fillWidth: true
                    icon: page.adapter && page.adapter.enabled ? Theme.iBt : Theme.iBtOff
                    label: page.adapter && page.adapter.enabled ? "Activado" : "Apagado"
                    active: !!page.adapter && page.adapter.enabled
                    onClicked: page.adapter.enabled = !page.adapter.enabled
                }
                Toggle {
                    Layout.fillWidth: true
                    icon: Theme.iRefresh
                    label: page.adapter && page.adapter.discovering ? "Buscando…" : "Buscar"
                    active: !!page.adapter && page.adapter.discovering
                    onClicked: if (page.adapter.enabled) page.adapter.discovering = !page.adapter.discovering
                }
            }
        }

        Card {
            Layout.fillWidth: true
            visible: !!page.adapter && page.adapter.enabled
            title: "Dispositivos"
            trailing: page.devices.length === 0 ? "ninguno" : ""

            Repeater {
                model: page.devices
                delegate: ListRow {
                    required property var modelData
                    icon: modelData.connected ? Theme.iBtOn : Theme.iBt
                    label: modelData.name || modelData.address
                    sub: modelData.connected ? "Conectado" : (modelData.paired ? "Emparejado" : "Disponible")
                    trailing: modelData.batteryAvailable ? Math.round(modelData.battery * 100) + "%" : ""
                    selected: modelData.connected
                    onClicked: modelData.connected ? modelData.disconnect() : modelData.connect()
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Button { icon: Theme.iCog; label: "Administrador"; onClicked: Quickshell.execDetached(["blueman-manager"]) }
            Item { Layout.fillWidth: true }
        }
    }
}
