import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.14
import org.kde.kirigami 2.12 as Kirigami

Item {
    id: root
    width: 400
    height: 400

    readonly property string letters : "ESONPLASUNACUATROIDOCESIETEKCINCOSEISOJNUEVEDIEZTRESDOSOCHOEONCEDYMENOSRFDIEZVEINTICINCOMEDIAVEINTECUARTOPUNTO"

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
                return "EN PUNTO";
            case 5:  return "Y CINCO";
            case 10: return "Y 73#DIEZ";
            case 15: return "Y CUARTO";
            case 20: return "Y VEINTE";
            case 25: return "Y VEINTICINCO";
            case 30: return "Y MEDIA";
            case 35: return "MENOS VEINTICINCO";
            case 40: return "MENOS VEINTE";
            case 45: return "MENOS CUARTO";
            case 50: return "MENOS 73#DIEZ";
            case 55: return "MENOS CINCO";
        }
    }

    function hourWords(_hour) {
        switch (_hour % 12) {
            case 0: return "DOCE";
            case 1: return "UNA";
            case 2: return "DOS";
            case 3: return "TRES";
            case 4: return "CUATRO";
            case 5: return "CINCO";
            case 6: return "SEIS";
            case 7: return "SIETE";
            case 8: return "OCHO";
            case 9: return "NUEVE";
            case 10: return "DIEZ";
            case 11: return "ONCE";
        }
    }

    function indexesOfWord(word, startIdx=0) {
        let indexes = [];
        let foundIdx = letters.indexOf(word, startIdx);

        if (foundIdx < 0) {
            return [];
        }
        for (let i=0; i < word.length; i++) {
            indexes.push(foundIdx + i);
        }
        return indexes
    }

    property string timeWords: {
        let closestHour = (hour + (mins > nextHourLimit ? 1 : 0)) % 12;

        let sWords = (closestHour == 1) ? "ES LA" : "SON LAS"
        let mWords = minuteWords(mins)
        let hWords = hourWords(closestHour)

        return [sWords, hWords, mWords].join(" ")
    }

    property var highlights: {
        let allIdxs = [];
        for (let word of timeWords.split(" ")) {
            // Word strings can be nnn#WORD, to indicate word search starts from nnn index
            const startIdx = parseInt(word) || 0 // the index hint added to the word
            const wordPos = word.indexOf('#') + 1; //start of the actual word, or 0 when no hint
            for (const idx of indexesOfWord(word.substring(wordPos), startIdx)) {
                allIdxs.push(idx);
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

