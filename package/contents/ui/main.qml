/*
    SPDX-FileCopyrightText: 2022 Ismael Asensio <isma.af@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore


Item {
    id: root

    property date time

    width: PlasmaCore.Units.gridUnit * 15
    height: PlasmaCore.Units.gridUnit * 15

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: CrossWordClock {
        time: root.time

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
    }

    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: "Local"
        interval: 30000
        onDataChanged: {
            time = new Date(data["Local"]["DateTime"]);
        }
        Component.onCompleted: {
            onDataChanged();
        }
    }

}
