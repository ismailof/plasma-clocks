/*
    SPDX-FileCopyrightText: 2022 Ismael Asensio <isma.af@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.plasma5support 2.0 as P5Support
import org.kde.kirigami 2 as Kirigami

PlasmoidItem {
    id: root

    property date time: new Date("2003-08-07 12:00")

    width: Kirigami.Units.gridUnit * 15
    height: Kirigami.Units.gridUnit * 15

    fullRepresentation: CrossWordClock {
        time: root.time

        Layout.minimumWidth: Kirigami.Units.gridUnit * 6
        Layout.minimumHeight: Kirigami.Units.gridUnit * 6
    }

    P5Support.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: "Local"
        interval: 30000
        //intervalAlignment: P5Support.Types.AlignToMinute
        onDataChanged: {
           time = new Date(data["Local"]["DateTime"]);
        }
        Component.onCompleted: {
            onDataChanged();
        }
    }
}
