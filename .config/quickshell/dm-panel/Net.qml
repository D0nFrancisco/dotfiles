pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// ─────────────────────────────────────────────────────────────
//  Red (NetworkManager vía nmcli)
// ─────────────────────────────────────────────────────────────
Singleton {
    id: root

    property string type: ""        // ethernet | wifi | ""
    property string name: ""
    property string device: ""
    property string ip: ""
    property string gateway: ""
    property bool wifiOn: false
    property int signal: 0
    property var networks: []       // [{ ssid, signal, secure, active }]
    property bool scanning: false

    readonly property bool connected: type !== ""
    readonly property string icon: {
        if (type === "ethernet") return Theme.iEthernet;
        if (type === "wifi") {
            if (signal >= 75) return Theme.iWifi4;
            if (signal >= 50) return Theme.iWifi3;
            if (signal >= 25) return Theme.iWifi2;
            return Theme.iWifi1;
        }
        return wifiOn ? Theme.iWifiOff : Theme.iLanOff;
    }
    readonly property string label: connected ? name : "Sin conexión"

    function refresh() { status.running = true; }

    function scan() {
        if (scanner.running) return;
        root.scanning = true;
        scanner.running = true;
    }

    function toggleWifi() {
        Quickshell.execDetached(["nmcli", "radio", "wifi", wifiOn ? "off" : "on"]);
        wifiOn = !wifiOn;
        delay.restart();
    }

    function connectTo(ssid) {
        Quickshell.execDetached(["sh", "-c",
            "nmcli device wifi connect \"$1\" || nm-connection-editor", "sh", ssid]);
        delay.restart();
    }

    // separa por ':' respetando '\:' de nmcli -t
    function fields(line) {
        const out = [];
        let cur = "";
        for (let i = 0; i < line.length; i++) {
            const ch = line[i];
            if (ch === "\\" && i + 1 < line.length) { cur += line[++i]; continue; }
            if (ch === ":") { out.push(cur); cur = ""; continue; }
            cur += ch;
        }
        out.push(cur);
        return out;
    }

    Process {
        id: status
        command: ["bash", Quickshell.shellDir + "/scripts/dm-net.sh"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const d = JSON.parse(text);
                    root.type = d.type;
                    root.name = d.name;
                    root.device = d.device;
                    root.ip = d.ip;
                    root.gateway = d.gateway;
                    root.wifiOn = d.wifi === "enabled";
                    root.signal = parseInt(d.signal) || 0;
                } catch (e) {}
            }
        }
    }

    Process {
        id: scanner
        command: ["nmcli", "-t", "-f", "IN-USE,SSID,SIGNAL,SECURITY", "device", "wifi", "list", "--rescan", "auto"]
        stdout: StdioCollector {
            onStreamFinished: {
                const seen = {};
                const list = [];
                for (const line of text.split("\n")) {
                    if (!line) continue;
                    const f = root.fields(line);
                    const ssid = f[1];
                    if (!ssid || seen[ssid]) continue;
                    seen[ssid] = true;
                    list.push({ ssid: ssid, signal: parseInt(f[2]) || 0, secure: (f[3] || "") !== "", active: f[0] === "*" });
                }
                list.sort((a, b) => (b.active - a.active) || (b.signal - a.signal));
                root.networks = list;
                root.scanning = false;
            }
        }
    }

    Timer { interval: 5000; running: true; repeat: true; onTriggered: root.refresh() }
    Timer { id: delay; interval: 2500; onTriggered: { root.refresh(); if (root.wifiOn) root.scan(); } }
}
