import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.14
import org.kde.kirigami 2.12 as Kirigami

Item {
    id: root
    width: 800
    height: 800

    readonly property string letters : "ITLISASAMPMACQUARTERDCTWENTYFIVEXHALFBTENFTOPASTERUNINEONESIXTHREEFOURFIVETWOEIGHTELEVENSEVENTWELVETENSEÔCLOCK"

    property int hour: 0
    property int mins: 0

    Timer {
        interval: 15000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            let now = new Date()
            hour = now.getHours() % 12
            mins = Math.round(now.getMinutes() / 5) * 5
        }
    }

    function minuteWords(_minutes) {
        switch (_minutes) {
            case 0:
            case 60:
                return "ÔCLOCK";
            case 5:  return "FIVE PAST";
            case 10: return "TEN PAST";
            case 15: return "A QUARTER PAST";
            case 20: return "TWENTY PAST";
            case 25: return "TWENTYFIVE PAST";
            case 30: return "HALF PAST";
            case 35: return "TWENTYFIVE TO";
            case 40: return "TWENTY TO";
            case 45: return "A QUARTER TO";
            case 50: return "TEN TO";
            case 55: return "FIVE TO";
        }
    }

    function hourWords(_hour) {
        switch (_hour % 12) {
            case 0: return "TWELVE";
            case 1: return "ONE";
            case 2: return "TWO";
            case 3: return "THREE";
            case 4: return "FOUR";
            case 5: return "FIVE";
            case 6: return "SIX";
            case 7: return "SEVEN";
            case 8: return "EIGHT";
            case 9: return "NINE";
            case 10: return "TEN";
            case 11: return "ELEVEN";
        }
    }

    function indexesOfWord(word, startPos=0) {
        let indexes = [];
        let startIdx = letters.indexOf(word, startPos);

        if (startIdx < 0) {
            return [];
        }
        for (let i=0; i < word.length; i++) {
            indexes.push(startIdx + i);
        }
        return indexes
    }

    property string timeWords: {
        let closestHour = hour + (mins > 30 ? 1 : 0);

        let sWords = "IT IS"
        let mWords = minuteWords(mins)
        let hWords = hourWords(closestHour)

        // HACK. It doesn't internationalize well. Better provide the indexes directly
        let words = mWords.includes(minuteWords(0)) ? [sWords, hWords, mWords] // O'Clock goes after the hour
                                                    : [sWords, mWords, hWords]

        return words.join(" ")
    }

    property var highlights: {
        let allIdxs = [];
        let prevIdx = 0;
        for (let word of timeWords.split(" ")) {
            for (let idx of indexesOfWord(word, prevIdx)) {
                allIdxs.push(idx);
                prevIdx = idx + 2;
            }
        }
        return allIdxs;
    }

    Kirigami.Theme.colorSet: Kirigami.Theme.View

    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.backgroundColor
    }

    GridLayout {
        id: grid

        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit
        columns: Math.ceil(Math.sqrt(letters.length))

        readonly property int rowCount: (letters.length / grid.columns)

        Repeater {
            model: letters.length
            delegate: QQC2.Label {
                Layout.fillWidth: true
                Layout.fillHeight: true

                color: Kirigami.Theme.textColor
                horizontalAlignment: Text.AlignHCenter
                font.bold:true
                font.pixelSize: Math.floor(grid.height / grid.rowCount)

                text: letters[index]
                opacity: highlights.includes(index) ? 1 : 0.1
            }
        }
    }
}

