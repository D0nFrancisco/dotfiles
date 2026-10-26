import QtQuick
import QtQuick.Layouts
import Quickshell

// ─────────── Red: conexión actual, tráfico, Wi-Fi ───────────
Flickable {
    id: page
    contentHeight: col.implicitHeight
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    onVisibleChanged: if (visible) { Net.refresh(); if (Net.wifiOn) Net.scan(); }

    function wifiIcon(s) {
        if (s >= 75) return Theme.iWifi4;
        if (s >= 50) return Theme.iWifi3;
        if (s >= 25) return Theme.iWifi2;
        return Theme.iWifi1;
    }

    ColumnLayout {
        id: col
        width: page.width
        spacing: 12

        // ── Conexión ──
        Card {
            Layout.fillWidth: true
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                Glyph { text: Net.icon; font.pixelSize: 28; color: Net.connected ? Theme.accent : Theme.muted }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Txt { text: Net.label; font.pixelSize: 14; Layout.fillWidth: true }
                    Txt {
                        text: Net.connected ? (Net.type === "wifi" ? "Wi-Fi · " + Net.signal + "%" : "Ethernet") + " · " + Net.device : "Desconectado"
                        color: Theme.muted
                        font.pixelSize: Theme.fontSm
                    }
                }
            }
            InfoRow { icon: Theme.iList; label: "Dirección IP"; value: Net.ip || "—" }
            InfoRow { icon: Theme.iSwap; label: "Puerta de enlace"; value: Net.gateway || "—" }
        }

        // ── Tráfico ──
        Card {
            Layout.fillWidth: true
            title: "Tráfico"
            Graph {
                Layout.fillWidth: true
                implicitHeight: 52
                values: Sys.rxHist
                values2: Sys.txHist
                maxValue: 0
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 18
                InfoChip { icon: Theme.iDown; text: Sys.rate(Sys.now.rx) }
                InfoChip { icon: Theme.iUp; text: Sys.rate(Sys.now.tx); dim: true }
            }
        }

        // ── Wi-Fi ──
        Card {
            Layout.fillWidth: true
            title: "Wi-Fi"
            trailing: Net.scanning ? "buscando…" : ""

            Toggle {
                Layout.fillWidth: true
                icon: Net.wifiOn ? Theme.iWifi4 : Theme.iWifiOff
                label: Net.wifiOn ? "Activado" : "Apagado"
                sub: Net.wifiOn ? Net.networks.length + " redes" : "Toca para encender"
                active: Net.wifiOn
                onClicked: Net.toggleWifi()
            }

            Repeater {
                model: Net.wifiOn ? Net.networks.slice(0, 8) : []
                delegate: ListRow {
                    required property var modelData
                    icon: page.wifiIcon(modelData.signal)
                    label: modelData.ssid
                    trailing: (modelData.secure ? Theme.iLock + " " : "") + modelData.signal + "%"
                    selected: modelData.active
                    onClicked: if (!modelData.active) Net.connectTo(modelData.ssid)
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Button { icon: Theme.iRefresh; label: "Buscar redes"; visible: Net.wifiOn; onClicked: Net.scan() }
            Button { icon: Theme.iCog; label: "Conexiones"; onClicked: Quickshell.execDetached(["nm-connection-editor"]) }
            Item { Layout.fillWidth: true }
        }
    }
}
