/*
    SPDX-FileCopyrightText: 2013 Heena Mahour <heena393@gmail.com>
    SPDX-FileCopyrightText: 2013 Sebastian Kügler <sebas@kde.org>
    SPDX-FileCopyrightText: 2013 Martin Klapetek <mklapetek@kde.org>
    SPDX-FileCopyrightText: 2022 Ismael Asensio <isma.af@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.14

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PC3


Item {
    id: root

    property date time: new Date("2000-12-17 10:10:00")

    // The actual time "digits" to be shown
    //"@" in the minutes indicates next hour will be used
    readonly property int _hour: (time.getHours() + (_mins === 60 || minuteWords.includes('@') ? 1 : 0)) % 24
    readonly property int _mins: Math.round((time.getMinutes() + time.getSeconds()/60) / 5) * 5

    // Internationalization properties
    readonly property string letters: i18nc("String of letters that compose the clock grid, that will be arrange in a 11x10 grid.",
                                            "ITLISASAMPMACQUARTERDCTWENTYFIVEXHALFBTENFTOPASTERUNINEONESIXTHREEFOURFIVETWOEIGHTELEVENSEVENTWELVETENSEO'CLOCK").trim()

    readonly property string introWords: i18ncp("Introductory words for the time",
                                                "IT IS", "IT IS", _hour)

    readonly property string hourWords: {
        switch (_hour) {
            case 0:
                return i18nc("Word representing the hour 12 (AM)","TWELVE")
            case 12:
                // Some languages (FR) make the distinction betwen 12AM and 12PM
                return i18nc("Word representing the hour 12 (PM)","TWELVE")
            case 1:
            case 13:
                return i18nc("Word representing the hour 1","ONE")
            case 2:
            case 14:
                return i18nc("Word representing the hour 2","TWO")
            case 3:
            case 15:
                return i18nc("Word representing the hour 3","THREE")
            case 4:
            case 16:
                return i18nc("Word representing the hour 4","FOUR")
            case 5:
            case 17:
                return i18nc("Word representing the hour 5","70#FIVE")
            case 6:
            case 18:
                return i18nc("Word representing the hour 6","SIX")
            case 7:
            case 19:
                return i18nc("Word representing the hour 7","SEVEN")
            case 8:
            case 20:
                return i18nc("Word representing the hour 8","EIGHT")
            case 9:
            case 21:
                return i18nc("Word representing the hour 9","NINE")
            case 10:
            case 22:
                return i18nc("Word representing the hour 10","99#TEN")
            case 11:
            case 23:
                return i18nc("Word representing the hour 11","ELEVEN")
        }
    }
    readonly property string minuteWords: {
        switch (_mins) {
            case 0:
            case 60: // Use also 60 to simplify calculation of the next hour
                return i18nc("Words representing the minutes :00", "O'CLOCK")
            case 5:  return i18nc("Words representing the minutes :05", "FIVE PAST")
            case 10: return i18nc("Words representing the minutes :10", "TEN PAST")
            case 15: return i18nc("Words representing the minutes :15", "11#A QUARTER PAST")
            case 20: return i18nc("Words representing the minutes :20", "TWENTY PAST")
            case 25: return i18nc("Words representing the minutes :25", "TWENTYFIVE PAST")
            case 30: return i18nc("Words representing the minutes :30", "HALF PAST")
            case 35: return i18nc("Words representing the minutes :35", "TWENTYFIVE TO @")
            case 40: return i18nc("Words representing the minutes :40", "TWENTY TO @")
            case 45: return i18nc("Words representing the minutes :45", "11#A QUARTER TO @")
            case 50: return i18nc("Words representing the minutes :50", "TEN TO @")
            case 55: return i18nc("Words representing the minutes :55", "FIVE TO @")
        }
    }

    readonly property var highlights: indexesOfSentence([introWords, minuteWords, hourWords].join(" "))

    // Helper for language debugging
    onHighlightsChanged: {
        console.log(time.toLocaleTimeString() + " > intro: " + introWords + "  " + _hour + "h: " + hourWords + "  " + _mins + "m: " + minuteWords)
    }

    // Array with indexes of special characters
    readonly property var specialIdxs: {
        let _specialIdxs = []
        let _startIdx = 0
        while (true) {
            let idx = letters.indexOf("\'", _startIdx)
            if (idx === -1) {
                break
            }
            _specialIdxs.push(idx)
            _startIdx = idx + 1
        }
        return _specialIdxs
    }

    readonly property int columns: Math.ceil(Math.sqrt(letters.length - specialIdxs.length))  // 11
    readonly property int rows: Math.ceil((letters.length - specialIdxs.length) / columns)    // 10

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

    function indexesOfSentence(sentence) {
        let allIdxs = []
        for (let word of sentence.split(" ")) {
            // A sentence can contain '@' to indicate that the next hour should be used
            if (word === "@") {
                continue
            }
            // Word strings can start with a number followed by '#' to indicate an index hint
            const startIdx = parseInt(word) || 0 // the index hint added to the word
            const wordPos = word.indexOf('#') + 1 //start of the actual word, or 0 when no hint
            for (const idx of indexesOfWord(word.substring(wordPos), startIdx)) {
                allIdxs.push(idx)
            }
        }
        return allIdxs
    }

    GridLayout {
        id: grid

        anchors.fill: parent
        anchors.margins: PlasmaCore.Units.gridUnit
        columns: root.columns

        Repeater {
            model: letters.length - specialIdxs.length
            delegate: PC3.Label {
                Layout.fillWidth: true
                Layout.fillHeight: true

                readonly property int actualIndex: index + specialIdxs.filter((idx, i) => index + i >= idx).length
                readonly property bool active: highlights.includes(actualIndex)

                horizontalAlignment: Text.AlignHCenter
                font.bold:true
                font.pixelSize: Math.floor(grid.height / root.rows)

                text: letters[actualIndex] + (specialIdxs.includes(actualIndex + 1) ? letters[actualIndex + 1] : "")
                opacity: active ? 1 : 0.1

                Behavior on opacity {
                    NumberAnimation { duration: 4 * PlasmaCore.Units.longDuration } // or just a fixed 500
                }
            }
        }
    }
}

