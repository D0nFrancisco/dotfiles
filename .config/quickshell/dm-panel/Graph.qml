import QtQuick

// Gráfica de línea con desplazamiento suave (se mueve 1 paso por segundo
// con animación continua, no a saltos). values2 = segunda línea opcional.
Canvas {
    id: g

    property var values: []
    property var values2: []
    property real maxValue: 100          // 0 = escala automática
    property int capacity: 60
    property color lineColor: Theme.accent
    property color lineColor2: Theme.muted
    property real shift: 0

    implicitHeight: 64
    renderStrategy: Canvas.Cooperative

    readonly property real step: width / Math.max(1, capacity - 1)

    onValuesChanged: { slide.restart(); requestPaint(); }
    onShiftChanged: requestPaint()
    onWidthChanged: requestPaint()
    onVisibleChanged: if (visible) requestPaint()

    NumberAnimation {
        id: slide
        target: g
        property: "shift"
        from: g.step
        to: 0
        duration: 1000
    }

    function draw(ctx, data, color, mx, fill) {
        const n = data.length;
        if (n < 2) return;
        const x0 = width - (n - 1) * step + shift;
        const y = v => height - 2 - (Math.min(v, mx) / mx) * (height - 6);

        ctx.beginPath();
        ctx.moveTo(x0, y(data[0]));
        for (let i = 1; i < n; i++)
            ctx.lineTo(x0 + i * step, y(data[i]));
        ctx.lineWidth = 1.4;
        ctx.lineJoin = "round";
        ctx.strokeStyle = color;
        ctx.stroke();

        if (!fill) return;
        ctx.lineTo(x0 + (n - 1) * step, height);
        ctx.lineTo(x0, height);
        ctx.closePath();
        const grad = ctx.createLinearGradient(0, 0, 0, height);
        grad.addColorStop(0, Qt.rgba(color.r, color.g, color.b, 0.16));
        grad.addColorStop(1, Qt.rgba(color.r, color.g, color.b, 0.0));
        ctx.fillStyle = grad;
        ctx.fill();
    }

    onPaint: {
        const ctx = getContext("2d");
        ctx.reset();

        // línea guía central punteada
        ctx.strokeStyle = Theme.bg3;
        ctx.lineWidth = 1;
        ctx.setLineDash([2, 4]);
        ctx.beginPath();
        ctx.moveTo(0, height / 2);
        ctx.lineTo(width, height / 2);
        ctx.stroke();
        ctx.setLineDash([]);

        let mx = maxValue;
        if (mx <= 0) {
            mx = 1;
            for (const v of values) mx = Math.max(mx, v);
            for (const v of values2) mx = Math.max(mx, v);
            mx *= 1.2;
        }

        draw(ctx, values2, lineColor2, mx, false);
        draw(ctx, values, lineColor, mx, true);
    }
}
