import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris

// ─────────── Multimedia: reproductor MPRIS ───────────
ColumnLayout {
    id: page
    spacing: 12

    readonly property var players: Mpris.players.values
    property int sel: 0
    readonly property var player: players.length > 0 ? players[Math.min(sel, players.length - 1)] : null

    function fmt(s) {
        if (!isFinite(s) || s < 0) return "0:00";
        const m = Math.floor(s / 60), r = Math.floor(s % 60);
        return m + ":" + (r < 10 ? "0" : "") + r;
    }

    // la posición no se actualiza sola: se refresca cada segundo
    Timer {
        interval: 1000
        repeat: true
        running: page.visible && !!page.player && page.player.isPlaying
        onTriggered: page.player.positionChanged()
    }

    // ── Sin reproductor ──
    Card {
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: !page.player
        Item { Layout.fillHeight: true }
        Glyph { text: Theme.iMusic; font.pixelSize: 40; color: Theme.bg3; Layout.alignment: Qt.AlignHCenter }
        Txt { text: "Nada reproduciéndose"; color: Theme.muted; Layout.alignment: Qt.AlignHCenter }
        Item { Layout.fillHeight: true }
    }

    // ── Selector de reproductor ──
    RowLayout {
        visible: page.players.length > 1
        spacing: 6
        Repeater {
            model: page.players
            delegate: Button {
                required property var modelData
                required property int index
                label: modelData.identity
                icon: index === page.sel ? Theme.iCheck : ""
                onClicked: page.sel = index
            }
        }
    }

    // ── Reproductor ──
    Card {
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: !!page.player
        padding: 16

        ClippingRectangle {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 220
            implicitHeight: 220
            radius: Theme.radiusMd
            color: Theme.bg2
            scale: page.player && page.player.isPlaying ? 1 : 0.94
            Behavior on scale { NumberAnimation { duration: Theme.animSlow; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.soft } }

            Image {
                id: art
                anchors.fill: parent
                source: page.player ? page.player.trackArtUrl : ""
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                opacity: status === Image.Ready ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: Theme.animSlow } }
            }
            Glyph {
                anchors.centerIn: parent
                visible: art.status !== Image.Ready
                text: Theme.iMusic
                font.pixelSize: 56
                color: Theme.bg3
            }
        }

        Txt {
            text: page.player ? (page.player.trackTitle || "Sin título") : ""
            Layout.fillWidth: true
            Layout.topMargin: 6
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }
        Txt {
            text: page.player ? (page.player.trackArtist || page.player.identity) : ""
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            color: Theme.muted
            font.pixelSize: Theme.fontSm
        }

        // progreso
        ColumnLayout {
            Layout.fillWidth: true
            visible: !!page.player && page.player.lengthSupported && page.player.length > 0
            spacing: 2
            Slider {
                Layout.fillWidth: true
                value: page.player && page.player.length > 0 ? page.player.position / page.player.length : 0
                onMoved: v => { if (page.player && page.player.positionSupported) page.player.position = v * page.player.length; }
            }
            RowLayout {
                Layout.fillWidth: true
                Txt { text: page.fmt(page.player ? page.player.position : 0); font.pixelSize: 10; color: Theme.muted }
                Item { Layout.fillWidth: true }
                Txt { text: page.fmt(page.player ? page.player.length : 0); font.pixelSize: 10; color: Theme.muted }
            }
        }

        // controles
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 18
            IconButton {
                icon: Theme.iPrev; size: 40; iconSize: 20
                opacity: page.player && page.player.canGoPrevious ? 1 : 0.35
                onClicked: page.player.previous()
            }
            Rectangle {
                implicitWidth: 52
                implicitHeight: 52
                radius: 26
                color: playMa.containsMouse ? Theme.fg : Theme.accent
                scale: playMa.pressed ? 0.92 : 1
                Behavior on color { ColorAnimation { duration: Theme.animFast } }
                Behavior on scale { NumberAnimation { duration: Theme.animFast } }
                Glyph {
                    anchors.centerIn: parent
                    text: page.player && page.player.isPlaying ? Theme.iPause : Theme.iPlay
                    font.pixelSize: 22
                    color: Theme.bg0
                }
                MouseArea {
                    id: playMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: page.player.togglePlaying()
                }
            }
            IconButton {
                icon: Theme.iNext; size: 40; iconSize: 20
                opacity: page.player && page.player.canGoNext ? 1 : 0.35
                onClicked: page.player.next()
            }
        }
        Item { Layout.fillHeight: true }
    }
}
