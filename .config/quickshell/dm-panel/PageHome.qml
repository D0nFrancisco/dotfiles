import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris

// ─────────── Inicio: hora, accesos rápidos, volumen, resumen ───────────
ColumnLayout {
    id: page
    spacing: 12

    signal openPage(string key)

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    property date now: new Date()
    Timer { interval: 1000; running: page.visible; repeat: true; triggeredOnStart: true; onTriggered: page.now = new Date() }

    function volIcon(n) {
        if (!n || !n.audio || n.audio.muted) return Theme.iVolOff;
        if (n.audio.volume < 0.34) return Theme.iVolLow;
        if (n.audio.volume < 0.67) return Theme.iVolMid;
        return Theme.iVolHigh;
    }

    // ── Hora y clima ──
    Card {
        Layout.fillWidth: true
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 2
                Txt {
                    text: Qt.formatTime(page.now, "HH:mm")
                    font.pixelSize: 34
                    font.weight: Font.Light
                    color: Theme.accent
                }
                Txt {
                    text: Qt.locale("es_CO").toString(page.now, "dddd, d 'de' MMMM")
                    color: Theme.muted
                    font.pixelSize: Theme.fontSm
                }
            }
            Item { Layout.fillWidth: true }
            MouseArea {
                Layout.preferredWidth: wcol.implicitWidth
                Layout.preferredHeight: wcol.implicitHeight
                cursorShape: Qt.PointingHandCursor
                onClicked: page.openPage("weather")
                ColumnLayout {
                    id: wcol
                    spacing: 2
                    RowLayout {
                        Layout.alignment: Qt.AlignRight
                        spacing: 6
                        Glyph { text: Weather.icon; font.pixelSize: 22; color: Theme.accent }
                        Txt { text: Weather.temp + "°"; font.pixelSize: 22; font.weight: Font.Light }
                    }
                    Txt {
                        text: Weather.desc
                        Layout.alignment: Qt.AlignRight
                        Layout.maximumWidth: 160
                        color: Theme.muted
                        font.pixelSize: 10
                    }
                }
            }
        }
    }

    // ── Accesos rápidos ──
    GridLayout {
        Layout.fillWidth: true
        columns: 3
        rowSpacing: 8
        columnSpacing: 8

        Toggle {
            Layout.fillWidth: true
            icon: Net.icon
            label: Net.type === "ethernet" ? "Cable" : "Wi-Fi"
            sub: Net.label
            active: Net.connected
            onClicked: Net.type === "ethernet" ? page.openPage("network") : Net.toggleWifi()
        }
        Toggle {
            Layout.fillWidth: true
            icon: page.adapter && page.adapter.enabled ? Theme.iBt : Theme.iBtOff
            label: "Bluetooth"
            sub: !page.adapter ? "Sin adaptador" : (page.adapter.enabled ? "Activado" : "Apagado")
            active: !!page.adapter && page.adapter.enabled
            onClicked: if (page.adapter) page.adapter.enabled = !page.adapter.enabled
        }
        Toggle {
            Layout.fillWidth: true
            icon: Status.dnd ? Theme.iBellOff : Theme.iBell
            label: "No molestar"
            sub: Status.notifCount > 0 ? Status.notifCount + " pendientes" : "Sin avisos"
            active: Status.dnd
            onClicked: Status.toggleDnd()
        }
        Toggle {
            Layout.fillWidth: true
            icon: Theme.iNightLight
            label: "Luz nocturna"
            sub: Status.nightLight ? "4500 K" : "Apagada"
            active: Status.nightLight
            onClicked: Status.toggleNight()
        }
        Toggle {
            Layout.fillWidth: true
            icon: page.volIcon(page.sink)
            label: "Sonido"
            sub: page.sink && page.sink.audio && page.sink.audio.muted ? "Silenciado" : "Activo"
            active: !!page.sink && !!page.sink.audio && !page.sink.audio.muted
            onClicked: if (page.sink && page.sink.audio) page.sink.audio.muted = !page.sink.audio.muted
        }
        Toggle {
            Layout.fillWidth: true
            icon: page.source && page.source.audio && !page.source.audio.muted ? Theme.iMic : Theme.iMicOff
            label: "Micrófono"
            sub: page.source && page.source.audio && page.source.audio.muted ? "Silenciado" : "Activo"
            active: !!page.source && !!page.source.audio && !page.source.audio.muted
            onClicked: if (page.source && page.source.audio) page.source.audio.muted = !page.source.audio.muted
        }
    }

    // ── Volumen ──
    Card {
        Layout.fillWidth: true
        title: "Volumen"
        trailing: page.sink ? (page.sink.nickname || page.sink.description) : ""

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            IconButton {
                icon: page.volIcon(page.sink)
                size: 28
                iconSize: 16
                onClicked: if (page.sink && page.sink.audio) page.sink.audio.muted = !page.sink.audio.muted
            }
            Slider {
                Layout.fillWidth: true
                value: page.sink && page.sink.audio ? page.sink.audio.volume : 0
                dimmed: !!page.sink && !!page.sink.audio && page.sink.audio.muted
                onMoved: v => { if (page.sink && page.sink.audio) page.sink.audio.volume = v; }
            }
            Txt {
                text: page.sink && page.sink.audio ? Math.round(page.sink.audio.volume * 100) + "%" : "--"
                Layout.preferredWidth: 38
                horizontalAlignment: Text.AlignRight
                font.pixelSize: Theme.fontSm
            }
        }
    }

    // ── Resumen del sistema ──
    Card {
        Layout.fillWidth: true
        title: "Sistema"
        trailing: "encendido " + Sys.uptimeText(Sys.now.uptime)

        MouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: stats.implicitHeight
            cursorShape: Qt.PointingHandCursor
            onClicked: page.openPage("system")

            GridLayout {
                id: stats
                anchors.fill: parent
                columns: 4
                columnSpacing: 10

                Repeater {
                    model: [
                        { icon: Theme.iCpu,    label: "CPU",   value: Math.round(Sys.now.cpu) + "%",   pct: Sys.now.cpu },
                        { icon: Theme.iMemory, label: "RAM",   value: Sys.now.memPct + "%",            pct: Sys.now.memPct },
                        { icon: Theme.iTemp,   label: "Temp",  value: Sys.now.temp + "°C",             pct: Sys.now.temp },
                        { icon: Theme.iDisk,   label: "Disco", value: Sys.now.diskPct + "%",           pct: Sys.now.diskPct }
                    ]
                    delegate: ColumnLayout {
                        required property var modelData
                        Layout.fillWidth: true
                        spacing: 4
                        RowLayout {
                            spacing: 5
                            Glyph { text: modelData.icon; font.pixelSize: 12; color: Theme.muted }
                            Txt { text: modelData.label; font.pixelSize: 10; color: Theme.muted }
                        }
                        Txt { text: modelData.value; font.pixelSize: 14 }
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 3
                            radius: 2
                            color: Theme.bg3
                            Rectangle {
                                width: parent.width * Math.min(1, modelData.pct / 100)
                                height: parent.height
                                radius: 2
                                color: modelData.pct > 85 ? Theme.alert : Theme.accent
                                Behavior on width { NumberAnimation { duration: Theme.animSlow; easing.type: Easing.OutCubic } }
                            }
                        }
                    }
                }
            }
        }
    }

    // ── Reproduciendo (si hay) ──
    Card {
        Layout.fillWidth: true
        visible: page.player !== null
        padding: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            Glyph { text: Theme.iMusic; font.pixelSize: 18; color: Theme.accent }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                Txt { text: page.player ? (page.player.trackTitle || "Sin título") : ""; Layout.fillWidth: true; font.pixelSize: Theme.fontSm }
                Txt { text: page.player ? (page.player.trackArtist || page.player.identity) : ""; Layout.fillWidth: true; font.pixelSize: 10; color: Theme.muted }
            }
            IconButton { icon: Theme.iPrev; size: 28; iconSize: 15; onClicked: page.player.previous() }
            IconButton { icon: page.player && page.player.isPlaying ? Theme.iPause : Theme.iPlay; size: 28; iconSize: 15; onClicked: page.player.togglePlaying() }
            IconButton { icon: Theme.iNext; size: 28; iconSize: 15; onClicked: page.player.next() }
        }
    }

    Item { Layout.fillHeight: true }
}
