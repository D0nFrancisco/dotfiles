import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

// ─────────── Audio: salida, entrada, aplicaciones ───────────
Flickable {
    id: page
    contentHeight: col.implicitHeight
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var nodes: Pipewire.nodes.values
    readonly property var outputs: nodes.filter(n => n.audio && n.isSink && !n.isStream)
    readonly property var inputs: nodes.filter(n => n.audio && !n.isSink && !n.isStream)
    readonly property var streams: nodes.filter(n => n.audio && n.isSink && n.isStream)

    // vincula todos los nodos para poder leer/cambiar su volumen
    PwObjectTracker { objects: page.nodes }

    function nodeName(n) {
        if (!n) return "";
        const p = n.properties || {};
        return p["application.name"] || n.nickname || n.description || n.name;
    }

    ColumnLayout {
        id: col
        width: page.width
        spacing: 12

        // ── Salida ──
        Card {
            Layout.fillWidth: true
            title: "Salida"
            trailing: page.sink && page.sink.audio ? Math.round(page.sink.audio.volume * 100) + "%" : ""

            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                IconButton {
                    icon: page.sink && page.sink.audio && page.sink.audio.muted ? Theme.iVolOff : Theme.iVolHigh
                    size: 28; iconSize: 16
                    onClicked: if (page.sink && page.sink.audio) page.sink.audio.muted = !page.sink.audio.muted
                }
                Slider {
                    Layout.fillWidth: true
                    value: page.sink && page.sink.audio ? page.sink.audio.volume : 0
                    dimmed: !!page.sink && !!page.sink.audio && page.sink.audio.muted
                    onMoved: v => { if (page.sink && page.sink.audio) page.sink.audio.volume = v; }
                }
            }

            Repeater {
                model: page.outputs
                delegate: ListRow {
                    required property var modelData
                    icon: (modelData.description || "").toLowerCase().includes("hdmi") ? Theme.iGpu : Theme.iSpeaker
                    label: modelData.description || modelData.name
                    selected: page.sink === modelData
                    onClicked: Pipewire.preferredDefaultAudioSink = modelData
                }
            }
        }

        // ── Entrada ──
        Card {
            Layout.fillWidth: true
            title: "Entrada"
            visible: page.inputs.length > 0
            trailing: page.source && page.source.audio ? Math.round(page.source.audio.volume * 100) + "%" : ""

            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                IconButton {
                    icon: page.source && page.source.audio && page.source.audio.muted ? Theme.iMicOff : Theme.iMic
                    size: 28; iconSize: 16
                    onClicked: if (page.source && page.source.audio) page.source.audio.muted = !page.source.audio.muted
                }
                Slider {
                    Layout.fillWidth: true
                    value: page.source && page.source.audio ? page.source.audio.volume : 0
                    dimmed: !!page.source && !!page.source.audio && page.source.audio.muted
                    onMoved: v => { if (page.source && page.source.audio) page.source.audio.volume = v; }
                }
            }

            Repeater {
                model: page.inputs
                delegate: ListRow {
                    required property var modelData
                    icon: Theme.iMic
                    label: modelData.description || modelData.name
                    selected: page.source === modelData
                    onClicked: Pipewire.preferredDefaultAudioSource = modelData
                }
            }
        }

        // ── Aplicaciones ──
        Card {
            Layout.fillWidth: true
            title: "Aplicaciones"
            trailing: page.streams.length === 0 ? "nada sonando" : ""

            Repeater {
                model: page.streams
                delegate: ColumnLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    spacing: 2
                    Txt { text: page.nodeName(modelData); font.pixelSize: Theme.fontSm; color: Theme.muted; Layout.fillWidth: true }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        Slider {
                            Layout.fillWidth: true
                            value: modelData.audio ? modelData.audio.volume : 0
                            dimmed: !!modelData.audio && modelData.audio.muted
                            onMoved: v => { if (modelData.audio) modelData.audio.volume = v; }
                        }
                        Txt {
                            text: modelData.audio ? Math.round(modelData.audio.volume * 100) + "%" : ""
                            Layout.preferredWidth: 38
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 10
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Button { icon: Theme.iTune; label: "Mezclador"; onClicked: Quickshell.execDetached(["pavucontrol"]) }
            Button { icon: Theme.iHeadphones; label: "EasyEffects"; onClicked: Quickshell.execDetached(["easyeffects"]) }
            Item { Layout.fillWidth: true }
        }
    }
}
