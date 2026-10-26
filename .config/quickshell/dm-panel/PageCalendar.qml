import QtQuick
import QtQuick.Layouts

// ─────────── Calendario: fecha grande + mes navegable ───────────
ColumnLayout {
    id: page
    spacing: 12

    property date today: new Date()
    property int year: today.getFullYear()
    property int month: today.getMonth()           // 0..11
    readonly property var loc: Qt.locale("es_CO")
    readonly property var weekdays: ["L", "M", "X", "J", "V", "S", "D"]

    Timer { interval: 60000; running: true; repeat: true; onTriggered: page.today = new Date() }

    function shiftMonth(d) {
        let m = month + d, y = year;
        if (m < 0) { m = 11; y--; }
        if (m > 11) { m = 0; y++; }
        month = m; year = y;
        gridAnim.restart();
    }
    function goToday() { today = new Date(); year = today.getFullYear(); month = today.getMonth(); gridAnim.restart(); }

    // 42 celdas (6 semanas), semana empieza en lunes
    readonly property var cells: {
        const first = new Date(year, month, 1);
        const offset = (first.getDay() + 6) % 7;
        const out = [];
        for (let i = 0; i < 42; i++) {
            const d = new Date(year, month, 1 - offset + i);
            out.push({
                day: d.getDate(),
                inMonth: d.getMonth() === month,
                isToday: d.toDateString() === today.toDateString(),
                weekend: d.getDay() === 0 || d.getDay() === 6
            });
        }
        return out;
    }

    function weekNumber(d) {
        const t = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
        const day = t.getUTCDay() || 7;
        t.setUTCDate(t.getUTCDate() + 4 - day);
        const y0 = new Date(Date.UTC(t.getUTCFullYear(), 0, 1));
        return Math.ceil(((t - y0) / 86400000 + 1) / 7);
    }

    // ── Hoy ──
    Card {
        Layout.fillWidth: true
        RowLayout {
            Layout.fillWidth: true
            Txt {
                text: page.today.getDate()
                font.pixelSize: 44
                font.weight: Font.Light
                color: Theme.accent
            }
            ColumnLayout {
                spacing: 2
                Layout.leftMargin: 6
                Txt { text: page.loc.toString(page.today, "dddd"); font.pixelSize: 15; font.capitalization: Font.Capitalize }
                Txt { text: page.loc.toString(page.today, "MMMM 'de' yyyy"); color: Theme.muted; font.pixelSize: Theme.fontSm }
            }
            Item { Layout.fillWidth: true }
            Txt { text: "Semana " + page.weekNumber(page.today); color: Theme.muted; font.pixelSize: Theme.fontSm }
        }
    }

    // ── Mes ──
    Card {
        Layout.fillWidth: true
        Layout.fillHeight: true

        RowLayout {
            Layout.fillWidth: true
            IconButton { icon: Theme.iLeft; size: 28; iconSize: 15; onClicked: page.shiftMonth(-1) }
            Txt {
                text: page.loc.standaloneMonthName(page.month, Locale.LongFormat) + " " + page.year
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 14
                font.weight: Font.DemiBold
                font.capitalization: Font.Capitalize
            }
            IconButton { icon: Theme.iRight; size: 28; iconSize: 15; onClicked: page.shiftMonth(1) }
        }

        GridLayout {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 7
            rowSpacing: 4
            columnSpacing: 4

            transform: Translate { id: gridShift }

            ParallelAnimation {
                id: gridAnim
                NumberAnimation { target: grid; property: "opacity"; from: 0.2; to: 1; duration: Theme.anim; easing.type: Easing.OutCubic }
                NumberAnimation { target: gridShift; property: "y"; from: 6; to: 0; duration: Theme.anim; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.glide }
            }

            Repeater {
                model: page.weekdays
                delegate: Txt {
                    required property string modelData
                    required property int index
                    text: modelData
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 10
                    color: Theme.muted
                    opacity: index >= 5 ? 0.6 : 1
                }
            }

            Repeater {
                model: page.cells
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 30
                    radius: Theme.radiusSm
                    color: modelData.isToday ? Theme.accent : (cellMa.containsMouse ? Theme.bg3 : "transparent")
                    Behavior on color { ColorAnimation { duration: Theme.animFast } }

                    Txt {
                        anchors.centerIn: parent
                        text: modelData.day
                        font.pixelSize: Theme.fontMd
                        font.weight: modelData.isToday ? Font.Bold : Font.Normal
                        color: modelData.isToday ? Theme.bg0
                             : !modelData.inMonth ? Theme.bg3
                             : modelData.weekend ? Theme.muted : Theme.fg
                    }
                    MouseArea { id: cellMa; anchors.fill: parent; hoverEnabled: true }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            Button {
                icon: Theme.iCalendar
                label: "Hoy"
                visible: page.month !== page.today.getMonth() || page.year !== page.today.getFullYear()
                onClicked: page.goToday()
            }
        }
    }
}
