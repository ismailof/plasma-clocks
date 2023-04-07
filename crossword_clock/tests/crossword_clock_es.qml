import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.14
import org.kde.kirigami 2.12 as Kirigami

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.14
import org.kde.kirigami 2.12 as Kirigami

CrossWordClock {
    width: 300
    height: 300

    Kirigami.Theme.colorSet: Kirigami.Theme.View

    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.backgroundColor
        z: -1
    }

    letters : "ESONPLASUNACUATROIDOCESIETEKCINCOSEISOJNUEVEDIEZTRESDOSOCHOESDONCEMENOSYPUNTOVEINTICINCOMEDIAVEINTECUARTOIDIEZ"

    introWords: {
        "singular": "ES LA",
        "plural": "SON LAS",
    }

    hourWords: {
        0: "DOCE"  ,
        1: "UNA"   ,
        2: "DOS"   ,
        3: "TRES"  ,
        4: "CUATRO",
        5: "CINCO" ,
        6: "SEIS"  ,
        7: "SIETE" ,
        8: "OCHO"  ,
        9: "NUEVE" ,
        10: "DIEZ" ,
        11: "ONCE" ,
    }

    minuteWords: {
        0:  "EN PUNTO",
        60: "EN PUNTO",
        5:  "Y 83#CINCO",
        10: "Y 99#DIEZ",
        15: "Y CUARTO",
        20: "Y VEINTE",
        25: "Y VEINTICINCO",
        30: "Y MEDIA",
        35: "MENOS VEINTICINCO",
        40: "MENOS VEINTE",
        45: "MENOS CUARTO",
        50: "MENOS 99#DIEZ",
        55: "MENOS 83#CINCO",
    }

    Timer {
        interval: 15000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            time = new Date()
        }
    }
}
