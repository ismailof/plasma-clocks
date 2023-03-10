/*
 *    SPDX-FileCopyrightText: 2012 Viranch Mehta <viranch.mehta@gmail.com>
 *    SPDX-FileCopyrightText: 2012 Marco Martin <mart@kde.org>
 *    SPDX-FileCopyrightText: 2013 David Edmundson <davidedmundson@kde.org>
 *    SPDX-FileCopyrightText: 2020 Ismael Asensio <isma.af@gmail.com>
 *
 *    SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.12

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasma5support 2.0 as P5Support


Item {
    id: lcdclock

    width: PlasmaCore.Units.gridUnit * 15
    height: PlasmaCore.Units.gridUnit * 7

    property int hours
    property int minutes
    property int seconds
    property int tzOffset

    property bool showSeconds: true

    Plasmoid.backgroundHints: Plasmoid.DefaultBackground;
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.toolTipMainText: Qt.formatDate(dataSource.data["Local"]["DateTime"],"dddd")
    Plasmoid.toolTipSubText: Qt.formatDate(dataSource.data["Local"]["DateTime"],
                                           Qt.locale().dateFormat(Locale.LongFormat).replace(/(^dddd.?\s)|(,?\sdddd$)/, ""))

    P5Support.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: "Local"
        interval: showSeconds ? 1000 : 30000
        onDataChanged: {
            let date = new Date(data["Local"]["DateTime"]);
            hours = date.getHours();
            minutes = date.getMinutes();
            seconds = date.getSeconds();
        }
        Component.onCompleted: {
            onDataChanged();
        }
    }

    function dateTimeChanged()
    {
        var currentTZOffset = dataSource.data["Local"]["Offset"] / 60;
        if (currentTZOffset !== tzOffset) {
            tzOffset = currentTZOffset;
            Date.timeZoneUpdated(); // inform the QML JS engine about TZ change
        }
    }

    Component.onCompleted: {
        tzOffset = new Date().getTimezoneOffset();
        dataSource.onDataChanged.connect(dateTimeChanged);
    }

    Plasmoid.compactRepresentation: RowLayout {
        id: representation
        Layout.minimumWidth: Plasmoid.formFactor !== PlasmaCore.Types.Vertical ? representation.height : PlasmaCore.Units.gridUnit
        Layout.minimumHeight: Plasmoid.formFactor === PlasmaCore.Types.Vertical ? representation.width : PlasmaCore.Units.gridUnit

        spacing: PlasmaCore.Units.largeSpacing

        DigitDisplay {
            digits: 2
            value: hours

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 100   // 100% = reference width
        }
        DigitDisplay {
            digits: 2
            value: minutes

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 100   // 100% = reference width
        }
        DigitDisplay {
            digits: 2
            value: seconds
            visible: showSeconds

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 60   // 60% of the others
            Layout.alignment: Qt.AlignBottom
        }
    }
}
