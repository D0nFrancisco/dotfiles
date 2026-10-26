//@ pragma UseQApplication
// ─────────────────────────────────────────────────────────────
//  dm-panel · centro de control Dark Minimal (Quickshell 0.3)
//  Abrir/cerrar:  qs -c dm-panel ipc call panel toggle
//  Ir a pestaña:  qs -c dm-panel ipc call panel show calendar
// ─────────────────────────────────────────────────────────────
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray

ShellRoot {
    id: shell

    property bool open: false
    property bool mapped: false
    property int page: 0

    readonly property var pages: [
        { key: "home",      title: "Inicio",      icon: Theme.iHome },
        { key: "media",     title: "Multimedia",  icon: Theme.iMusic },
        { key: "audio",     title: "Audio",       icon: Theme.iVolHigh },
        { key: "system",    title: "Sistema",     icon: Theme.iSystem },
        { key: "network",   title: "Red",         icon: Theme.iLan },
        { key: "bluetooth", title: "Bluetooth",   icon: Theme.iBt },
        { key: "weather",   title: "Clima",       icon: Theme.iPartly },
        { key: "calendar",  title: "Calendario",  icon: Theme.iCalendar }
    ]

    function indexOf(key) { return pages.findIndex(p => p.key === key); }
    function show(key) {
        const i = indexOf(key);
        if (i >= 0) page = i;
        open = true;
    }
    function hide() { open = false; }
    function toggle() { open ? hide() : show(""); }

    onOpenChanged: {
        if (open) { hideTimer.stop(); mapped = true; }
        else hideTimer.restart();
    }

    // la ventana sigue mapeada mientras corre la animación de cierre
    Timer {
        id: hideTimer
        interval: Theme.anim + 40
        onTriggered: if (!shell.open) shell.mapped = false
    }

    // volumen por defecto siempre vinculado
    PwObjectTracker { objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource] }

    IpcHandler {
        target: "panel"
        function toggle(): void { shell.toggle(); }
        function close(): void { shell.hide(); }
        function show(tab: string): void {
            if (shell.open && shell.pages[shell.page].key === tab) shell.hide();
            else shell.show(tab);
        }
    }

    PanelWindow {
        id: win

        visible: shell.mapped
        anchors { top: true; right: true }
        margins { top: 6; right: 10 }
        exclusiveZone: 0
        implicitWidth: 540
        implicitHeight: 640
        color: "transparent"

        WlrLayershell.namespace: "dm-panel"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: shell.open ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

        // clic fuera del panel = cerrar
        HyprlandFocusGrab {
            windows: [win]
            active: shell.open
            onCleared: shell.hide()
        }

        Rectangle {
            id: frame
            anchors.fill: parent
            radius: Theme.radius
            color: Theme.panelBg
            border.width: 1
            border.color: Theme.bg3

            // entrada: desde arriba a la derecha, escala 0.96 → 1 con rebote mínimo
            opacity: shell.open ? 1 : 0
            property real s: shell.open ? 1 : 0.96
            property real ty: shell.open ? 0 : -12
            transform: [
                Scale { origin.x: frame.width; origin.y: 0; xScale: frame.s; yScale: frame.s },
                Translate { y: frame.ty }
            ]
            Behavior on opacity { NumberAnimation { duration: Theme.anim; easing.type: Easing.OutCubic } }
            Behavior on s { NumberAnimation { duration: Theme.animSlow; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.soft } }
            Behavior on ty { NumberAnimation { duration: Theme.animSlow; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.glide } }

            // teclado: Esc cierra, 1-8 cambian de pestaña
            Item {
                anchors.fill: parent
                focus: shell.open
                Keys.onEscapePressed: shell.hide()
                Keys.onPressed: e => {
                    const n = e.key - Qt.Key_1;
                    if (n >= 0 && n < shell.pages.length) { shell.page = n; e.accepted = true; }
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                // ── Barra lateral ──
                Rectangle {
                    Layout.fillHeight: true
                    implicitWidth: 50
                    radius: Theme.radiusMd
                    color: Theme.cardBg
                    border.width: 1
                    border.color: Theme.bg3

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.topMargin: 8
                        anchors.bottomMargin: 8
                        spacing: 6

                        Repeater {
                            model: shell.pages
                            delegate: IconButton {
                                required property var modelData
                                required property int index
                                Layout.alignment: Qt.AlignHCenter
                                icon: modelData.icon
                                active: shell.page === index
                                indicator: true
                                onClicked: shell.page = index
                            }
                        }

                        Item { Layout.fillHeight: true }

                        IconButton {
                            Layout.alignment: Qt.AlignHCenter
                            icon: Status.dnd ? Theme.iBellOff : Theme.iBell
                            dot: Status.notifCount > 0 && !Status.dnd
                            onClicked: { shell.hide(); Status.openNotifs(); }
                        }
                        IconButton {
                            Layout.alignment: Qt.AlignHCenter
                            icon: Theme.iLock
                            onClicked: { shell.hide(); Quickshell.execDetached(["sh", "-c", "pidof hyprlock || hyprlock"]); }
                        }
                        IconButton {
                            Layout.alignment: Qt.AlignHCenter
                            icon: Theme.iPower
                            hoverColor: Theme.alert
                            onClicked: { shell.hide(); Quickshell.execDetached(["sh", "-c", "pkill wlogout || wlogout -b 5 -T 400 -B 400 -L 320 -R 320"]); }
                        }
                    }
                }

                // ── Contenido ──
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 12

                    // cabecera: título · bandeja · cerrar
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Txt {
                            id: title
                            text: shell.pages[shell.page].title
                            color: Theme.accent
                            font.pixelSize: Theme.fontLg
                            font.weight: Font.DemiBold
                            Layout.fillWidth: true
                        }

                        Repeater {
                            model: SystemTray.items
                            delegate: MouseArea {
                                id: trayItem
                                required property var modelData
                                implicitWidth: 26
                                implicitHeight: 26
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                                cursorShape: Qt.PointingHandCursor
                                onClicked: e => {
                                    if (e.button === Qt.LeftButton && !modelData.onlyMenu) modelData.activate();
                                    else if (e.button === Qt.MiddleButton) modelData.secondaryActivate();
                                    else if (modelData.hasMenu) {
                                        const p = trayItem.mapToItem(null, 0, trayItem.height + 4);
                                        modelData.display(win, p.x, p.y);
                                    }
                                }
                                onWheel: w => modelData.scroll(w.angleDelta.y, false)

                                Rectangle {
                                    anchors.fill: parent
                                    radius: Theme.radiusSm
                                    color: trayItem.containsMouse ? Theme.bg3 : "transparent"
                                    Behavior on color { ColorAnimation { duration: Theme.animFast } }
                                }
                                IconImage {
                                    anchors.centerIn: parent
                                    implicitSize: 16
                                    source: trayItem.modelData.icon
                                    opacity: trayItem.containsMouse ? 1 : 0.8
                                }
                            }
                        }

                        Rectangle {
                            visible: SystemTray.items.values.length > 0
                            implicitWidth: 1
                            implicitHeight: 16
                            color: Theme.bg3
                            Layout.leftMargin: 4
                            Layout.rightMargin: 4
                        }

                        IconButton {
                            icon: Theme.iClose
                            size: 30
                            iconSize: 15
                            hoverColor: Theme.alert
                            onClicked: shell.hide()
                        }
                    }

                    // páginas con transición (fundido + desplazamiento)
                    StackLayout {
                        id: stack
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        currentIndex: shell.page

                        transform: Translate { id: stackShift }
                        onCurrentIndexChanged: switchAnim.restart()

                        ParallelAnimation {
                            id: switchAnim
                            NumberAnimation { target: stack; property: "opacity"; from: 0; to: 1; duration: Theme.anim; easing.type: Easing.OutCubic }
                            NumberAnimation { target: stackShift; property: "y"; from: 14; to: 0; duration: Theme.animSlow; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.glide }
                        }

                        PageHome { onOpenPage: key => shell.show(key) }
                        PageMedia {}
                        PageAudio {}
                        PageSystem {}
                        PageNetwork {}
                        PageBluetooth {}
                        PageWeather {}
                        PageCalendar {}
                    }
                }
            }
        }
    }
}
