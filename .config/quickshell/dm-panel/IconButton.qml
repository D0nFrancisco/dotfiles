import QtQuick

// Botón de ícono (barra lateral, controles, cerrar)
Item {
    id: b

    property string icon: ""
    property bool active: false
    property bool indicator: false      // línea a la izquierda cuando está activo
    property bool dot: false            // punto de aviso (notificaciones)
    property int size: 36
    property int iconSize: 17
    property color hoverColor: Theme.fg
    signal clicked()

    implicitWidth: size
    implicitHeight: size

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusMd
        color: b.active ? Theme.bg3 : (ma.containsMouse ? Theme.bg2 : "transparent")
        Behavior on color { ColorAnimation { duration: Theme.anim } }
    }

    Rectangle {
        visible: b.indicator
        width: 2
        height: b.active ? 16 : 0
        radius: 1
        color: Theme.accent
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: -5
        Behavior on height { NumberAnimation { duration: Theme.anim; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.soft } }
    }

    Glyph {
        anchors.centerIn: parent
        text: b.icon
        font.pixelSize: b.iconSize
        color: b.active ? Theme.accent : (ma.containsMouse ? b.hoverColor : Theme.muted)
        scale: ma.pressed ? 0.88 : 1
        Behavior on scale { NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutCubic } }
    }

    Rectangle {
        visible: b.dot
        width: 6
        height: 6
        radius: 3
        color: Theme.accent
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 7
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: b.clicked()
    }
}
