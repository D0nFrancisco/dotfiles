import QtQuick
import QtQuick.Layouts

// ─────────── Sistema: CPU, memoria, red, información, recursos ───────────
GridLayout {
    id: page
    columns: 2
    rowSpacing: 12
    columnSpacing: 12

    // CPU
    Card {
        Layout.fillWidth: true
        Layout.preferredWidth: 1
        title: "CPU"
        Graph {
            Layout.fillWidth: true
            values: Sys.cpuHist
            maxValue: 100
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 14
            InfoChip { icon: Theme.iGauge; text: Math.round(Sys.now.cpu) + "%" }
            InfoChip { icon: Theme.iTemp; text: Sys.now.temp + "°C"; hot: Sys.now.temp >= 80 }
        }
    }

    // Memoria
    Card {
        Layout.fillWidth: true
        Layout.preferredWidth: 1
        title: "Memoria"
        Graph {
            Layout.fillWidth: true
            values: Sys.memHist
            maxValue: 100
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            InfoChip { icon: Theme.iMemory; text: Sys.now.memUsed.toFixed(1) + " GiB · " + Sys.now.memPct + "%" }
        }
    }

    // Red (ancho completo)
    Card {
        Layout.fillWidth: true
        Layout.columnSpan: 2
        title: "Red"
        trailing: Sys.now.iface
        Graph {
            Layout.fillWidth: true
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

    // Información del equipo
    Card {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        title: "Sistema"
        InfoRow { icon: Theme.iCpu; label: Sys.info.cpu }
        InfoRow { icon: Theme.iGpu; label: Sys.info.gpu }
        InfoRow { icon: Theme.iCog; label: Sys.info.os }
        InfoRow { icon: Theme.iList; label: "Linux " + Sys.info.kernel }
        InfoRow { icon: Theme.iHome; label: Sys.info.wm }
        InfoRow { icon: Theme.iClock; label: "Encendido " + Sys.uptimeText(Sys.now.uptime) }
        Item { Layout.fillHeight: true }
    }

    // Recursos
    Card {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        title: "Recursos"
        InfoRow { icon: Theme.iGauge; label: "Carga"; value: Sys.now.load }
        InfoRow { icon: Theme.iMemory; label: "RAM"; value: Sys.now.memUsed.toFixed(1) + " / " + Sys.now.memTotal.toFixed(1) + " GiB" }
        InfoRow { icon: Theme.iSwap; label: "Swap"; value: Sys.now.swapUsed.toFixed(1) + " / " + Sys.now.swapTotal.toFixed(1) + " GiB" }
        InfoRow { icon: Theme.iDisk; label: "/ · " + Sys.now.diskPct + "%"; value: Sys.now.diskUsed.toFixed(0) + " / " + Sys.now.diskTotal.toFixed(0) + " GiB" }
        Item { Layout.fillHeight: true }
    }
}
