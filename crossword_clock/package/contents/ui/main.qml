/*
    SPDX-FileCopyrightText: 2022 Ismael Asensio <isma.af@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasma5support 2.0 as P5Support


Item {
    id: root

    property date time: new Date("2003-08-07 12:00")

    width: PlasmaCore.Units.gridUnit * 15
    height: PlasmaCore.Units.gridUnit * 15

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: CrossWordClock {
        time: root.time

        Layout.minimumWidth: PlasmaCore.Units.gridUnit * 6
        Layout.minimumHeight: PlasmaCore.Units.gridUnit * 6
    }

    P5Support.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: "Local"
        interval: 30000
        intervalAlignment: PlasmaCore.Types.AlignToMinute
        onDataChanged: {
           time = new Date(data["Local"]["DateTime"]);
        }
        Component.onCompleted: {
            onDataChanged();
        }
    }
}
