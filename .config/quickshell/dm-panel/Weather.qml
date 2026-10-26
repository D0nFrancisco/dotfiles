pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// ─────────────────────────────────────────────────────────────
//  Clima (wttr.in, ubicación automática por IP, en español)
//  Se actualiza cada 30 min.
// ─────────────────────────────────────────────────────────────
Singleton {
    id: root

    property bool ready: false
    property string temp: "--"
    property string feels: "--"
    property string desc: "Sin datos"
    property string humidity: "--"
    property string wind: "--"
    property string area: ""
    property string icon: Theme.iCloud
    property string updated: ""
    property var days: []          // [{ name, max, min, icon, desc }]

    function iconFor(code, night) {
        const c = parseInt(code);
        if (c === 113) return night ? Theme.iNight : Theme.iSun;
        if (c === 116) return Theme.iPartly;
        if (c === 119 || c === 122) return Theme.iCloud;
        if ([143, 248, 260].includes(c)) return Theme.iFog;
        if ([200, 386, 389, 392, 395].includes(c)) return Theme.iStorm;
        if ([179, 182, 185, 227, 230, 317, 320, 323, 326, 329, 332, 335, 338, 350, 362, 365, 368, 371, 374, 377].includes(c)) return Theme.iSnow;
        if ([302, 305, 308, 356, 359].includes(c)) return Theme.iPour;
        return Theme.iRain;
    }

    function refresh() { fetch.running = true; }

    Process {
        id: fetch
        command: ["curl", "-sf", "--max-time", "15", "https://wttr.in/?format=j1&lang=es"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const d = JSON.parse(text);
                    const c = d.current_condition[0];
                    const hour = new Date().getHours();
                    root.temp = c.temp_C;
                    root.feels = c.FeelsLikeC;
                    root.humidity = c.humidity;
                    root.wind = c.windspeedKmph;
                    root.desc = (c.lang_es && c.lang_es[0]) ? c.lang_es[0].value : c.weatherDesc[0].value;
                    root.icon = root.iconFor(c.weatherCode, hour < 6 || hour >= 18);
                    const a = d.nearest_area[0];
                    root.area = a.areaName[0].value + (a.region[0].value ? ", " + a.region[0].value : "");
                    const names = ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"];
                    root.days = d.weather.map((w, i) => {
                        const mid = w.hourly[4] || w.hourly[0];
                        return {
                            name: i === 0 ? "Hoy" : names[new Date(w.date + "T12:00:00").getDay()],
                            max: w.maxtempC,
                            min: w.mintempC,
                            icon: root.iconFor(mid.weatherCode, false),
                            desc: (mid.lang_es && mid.lang_es[0]) ? mid.lang_es[0].value : mid.weatherDesc[0].value
                        };
                    });
                    root.updated = Qt.formatTime(new Date(), "HH:mm");
                    root.ready = true;
                } catch (e) {}
            }
        }
    }

    Timer {
        interval: 30 * 60 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
