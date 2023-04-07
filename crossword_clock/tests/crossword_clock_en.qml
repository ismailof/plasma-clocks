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

    letters: "ITLISASAMPMACQUARTERDCTWENTYFIVEXHALFBTENFTOPASTERUNINEONESIXTHREEFOURFIVETWOEIGHTELEVENSEVENTWELVETENSEÔCLOCK"

    introWords: {
        "singular": "IT IS",
        "plural": "IT IS",
    }
    hourWords: {
        0:  "TWELVE",
        1:  "ONE",
        2:  "TWO",
        3:  "THREE",
        4:  "FOUR",
        5:  "FIVE",
        6:  "SIX",
        7:  "SEVEN",
        8:  "EIGHT",
        9:  "NINE",
        10: "99#TEN",
        11: "ELEVEN",
    }
    minuteWords: {
        0:  "ÔCLOCK",
        60: "ÔCLOCK", // Use 60 to simplify next hour calculation
        5:  "FIVE PAST",
        10: "TEN PAST",
        15: "11#A QUARTER PAST",
        20: "TWENTY PAST",
        25: "TWENTYFIVE PAST",
        30: "HALF PAST",
        35: "TWENTYFIVE TO",
        40: "TWENTY TO",
        45: "11#A QUARTER TO",
        50: "TEN TO",
        55: "FIVE TO",
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

