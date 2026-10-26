pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// ─────────────────────────────────────────────────────────────
//  Notificaciones (swaync) y luz nocturna (hyprsunset)
// ─────────────────────────────────────────────────────────────
Singleton {
    id: root

    property int notifCount: 0
    property bool dnd: false
    property bool nightLight: false

    function toggleDnd() {
        Quickshell.execDetached(["swaync-client", "-d", "-sw"]);
        dnd = !dnd;
    }
    function clearNotifs() { Quickshell.execDetached(["swaync-client", "-C", "-sw"]); }
    function openNotifs() { Quickshell.execDetached(["swaync-client", "-t", "-sw"]); }

    function toggleNight() {
        Quickshell.execDetached(["sh", "-c", "pkill -x hyprsunset || hyprsunset -t 4500"]);
        nightLight = !nightLight;
        nightCheck.restart();
    }

    // swaync emite una línea JSON por cada cambio
    Process {
        id: swaync
        command: ["swaync-client", "-swb"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                try {
                    const d = JSON.parse(data);
                    root.notifCount = parseInt(d.text) || 0;
                    root.dnd = (d.alt || "").startsWith("dnd");
                } catch (e) {}
            }
        }
        onRunningChanged: if (!running) swRestart.start()
    }
    Timer { id: swRestart; interval: 3000; onTriggered: swaync.running = true }

    Process {
        id: night
        command: ["pgrep", "-x", "hyprsunset"]
        onExited: (code, status) => root.nightLight = code === 0
    }
    Timer { id: nightCheck; interval: 1200; onTriggered: night.running = true }
    Timer { interval: 5000; running: true; repeat: true; triggeredOnStart: true; onTriggered: night.running = true }
}
