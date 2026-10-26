pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// ─────────────────────────────────────────────────────────────
//  Datos del sistema (scripts/dm-stats.sh, una línea JSON/seg)
//  Corre siempre para que las gráficas tengan historial al abrir.
// ─────────────────────────────────────────────────────────────
Singleton {
    id: root

    readonly property int histLen: 60

    property var info: ({ cpu: "", gpu: "", os: "", kernel: "", wm: "", host: "" })
    property var now: ({
        cpu: 0, temp: 0, memUsed: 0, memTotal: 0, memPct: 0,
        swapUsed: 0, swapTotal: 0, rx: 0, tx: 0, iface: "",
        diskUsed: 0, diskTotal: 0, diskPct: 0, load: "", uptime: 0
    })

    property var cpuHist: []
    property var memHist: []
    property var rxHist: []
    property var txHist: []

    function push(arr, v) {
        const a = arr.slice(-(histLen - 1));
        a.push(v);
        return a;
    }

    function rate(b) {
        if (b < 1024) return b + " B/s";
        if (b < 1048576) return (b / 1024).toFixed(1) + " KiB/s";
        return (b / 1048576).toFixed(1) + " MiB/s";
    }

    function uptimeText(s) {
        const d = Math.floor(s / 86400);
        const h = Math.floor((s % 86400) / 3600);
        const m = Math.floor((s % 3600) / 60);
        if (d > 0) return d + " d " + h + " h";
        if (h > 0) return h + " h " + m + " min";
        return m + " min";
    }

    Process {
        id: stats
        command: ["bash", Quickshell.shellDir + "/scripts/dm-stats.sh"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                try {
                    const d = JSON.parse(data);
                    root.now = d;
                    root.cpuHist = root.push(root.cpuHist, d.cpu);
                    root.memHist = root.push(root.memHist, d.memPct);
                    root.rxHist = root.push(root.rxHist, d.rx);
                    root.txHist = root.push(root.txHist, d.tx);
                } catch (e) {}
            }
        }
        // si el script muere, se relanza
        onRunningChanged: if (!running) restart.start()
    }

    Timer {
        id: restart
        interval: 2000
        onTriggered: stats.running = true
    }

    Process {
        command: ["bash", Quickshell.shellDir + "/scripts/dm-stats.sh", "--info"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try { root.info = JSON.parse(text); } catch (e) {}
            }
        }
    }
}
