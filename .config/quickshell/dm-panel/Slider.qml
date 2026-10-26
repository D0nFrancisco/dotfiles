import QtQuick

// Deslizador fino: arrastre, clic y rueda. value 0..1
Item {
    id: s

    property real value: 0
    property bool dimmed: false
    signal moved(real v)

    implicitHeight: 22
    implicitWidth: 160

    readonly property real v: Math.max(0, Math.min(1, value))

    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: ma.containsMouse || ma.pressed ? 6 : 4
        radius: height / 2
        color: Theme.bg3
        Behavior on height { NumberAnimation { duration: Theme.animFast } }

        Rectangle {
            width: s.v * parent.width
            height: parent.height
            radius: parent.radius
            color: s.dimmed ? Theme.muted : Theme.accent
            Behavior on width { enabled: !ma.pressed; NumberAnimation { duration: Theme.anim; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: Theme.anim } }
        }
    }

    Rectangle {
        id: knob
        width: ma.containsMouse || ma.pressed ? 14 : 10
        height: width
        radius: width / 2
        x: s.v * (s.width - width)
        anchors.verticalCenter: parent.verticalCenter
        color: s.dimmed ? Theme.muted : Theme.accent
        border.width: 2
        border.color: Theme.bg1
        Behavior on width { NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutBack } }
        Behavior on x { enabled: !ma.pressed; NumberAnimation { duration: Theme.anim; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        function set(mx) { s.moved(Math.max(0, Math.min(1, mx / width))); }
        onPressed: m => set(m.x)
        onPositionChanged: m => { if (pressed) set(m.x); }
        onWheel: w => s.moved(Math.max(0, Math.min(1, s.value + (w.angleDelta.y > 0 ? 0.05 : -0.05))))
    }
}
