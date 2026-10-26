pragma Singleton
import QtQuick
import Quickshell

// ─────────────────────────────────────────────────────────────
//  Tema · Dark Minimal (paleta fija, tipografía, tiempos)
// ─────────────────────────────────────────────────────────────
Singleton {
    // Paleta
    readonly property color bg0: "#0a0a0b"
    readonly property color bg1: "#111113"
    readonly property color bg2: "#18181b"
    readonly property color bg3: "#232327"
    readonly property color fg: "#d6d3cd"
    readonly property color muted: "#6e6c69"
    readonly property color accent: "#d9d4c7"
    readonly property color alert: "#a15c5c"

    // Derivados (solo alfa sobre la misma paleta)
    readonly property color panelBg: Qt.rgba(0.039, 0.039, 0.043, 0.86)
    readonly property color cardBg: Qt.rgba(0.067, 0.067, 0.075, 0.72)
    readonly property color accentDim: Qt.rgba(0.851, 0.831, 0.780, 0.35)
    readonly property color accentFaint: Qt.rgba(0.851, 0.831, 0.780, 0.08)

    // Tipografía
    readonly property string font: "JetBrainsMono Nerd Font"
    readonly property int fontSm: 11
    readonly property int fontMd: 12
    readonly property int fontLg: 15

    // Forma
    readonly property int radius: 14
    readonly property int radiusMd: 10
    readonly property int radiusSm: 8

    // Movimiento (mismas curvas que Hyprland)
    readonly property int animFast: 160
    readonly property int anim: 300
    readonly property int animSlow: 460
    readonly property var glide: [0.22, 1.0, 0.36, 1.0, 1, 1]   // dmGlide
    readonly property var soft: [0.34, 1.06, 0.64, 1.0, 1, 1]   // dmSoft (rebote 6 %)

    // Íconos Nerd Font (Material Design)
    function g(cp) { return String.fromCodePoint(cp); }
    readonly property string iHome: g(0xf02dc)
    readonly property string iMusic: g(0xf075a)
    readonly property string iVolHigh: g(0xf057e)
    readonly property string iVolMid: g(0xf0580)
    readonly property string iVolLow: g(0xf057f)
    readonly property string iVolOff: g(0xf0581)
    readonly property string iMic: g(0xf036c)
    readonly property string iMicOff: g(0xf036d)
    readonly property string iSystem: g(0xf04c5)
    readonly property string iMemory: g(0xf035b)
    readonly property string iCpu: g(0xf0ee0)
    readonly property string iGpu: g(0xf0379)
    readonly property string iDisk: g(0xf02ca)
    readonly property string iTemp: g(0xf050f)
    readonly property string iGauge: g(0xf029a)
    readonly property string iSwap: g(0xf04e1)
    readonly property string iClock: g(0xf0150)
    readonly property string iEthernet: g(0xf0200)
    readonly property string iWifi4: g(0xf0928)
    readonly property string iWifi3: g(0xf0925)
    readonly property string iWifi2: g(0xf0922)
    readonly property string iWifi1: g(0xf091f)
    readonly property string iWifiOff: g(0xf05aa)
    readonly property string iLanOff: g(0xf0319)
    readonly property string iLan: g(0xf0317)
    readonly property string iBt: g(0xf00af)
    readonly property string iBtOff: g(0xf00b2)
    readonly property string iBtOn: g(0xf00b1)
    readonly property string iSun: g(0xf0599)
    readonly property string iPartly: g(0xf0595)
    readonly property string iCloud: g(0xf0590)
    readonly property string iRain: g(0xf0597)
    readonly property string iPour: g(0xf0596)
    readonly property string iStorm: g(0xf0593)
    readonly property string iFog: g(0xf0591)
    readonly property string iSnow: g(0xf0598)
    readonly property string iNight: g(0xf0594)
    readonly property string iNightLight: g(0xf1a4d)
    readonly property string iHumidity: g(0xf058e)
    readonly property string iWind: g(0xf059d)
    readonly property string iCalendar: g(0xf00ed)
    readonly property string iBell: g(0xf009a)
    readonly property string iBellOff: g(0xf009b)
    readonly property string iClear: g(0xf039f)
    readonly property string iLock: g(0xf033e)
    readonly property string iPower: g(0xf0425)
    readonly property string iClose: g(0xf0156)
    readonly property string iPlay: g(0xf040a)
    readonly property string iPause: g(0xf03e4)
    readonly property string iNext: g(0xf04ad)
    readonly property string iPrev: g(0xf04ae)
    readonly property string iLeft: g(0xf0141)
    readonly property string iRight: g(0xf0142)
    readonly property string iDown: g(0xf01da)
    readonly property string iUp: g(0xf0552)
    readonly property string iCog: g(0xf0493)
    readonly property string iRefresh: g(0xf0450)
    readonly property string iCheck: g(0xf012c)
    readonly property string iTune: g(0xf1542)
    readonly property string iHeadphones: g(0xf02cb)
    readonly property string iSpeaker: g(0xf04c3)
    readonly property string iList: g(0xf0279)
}
