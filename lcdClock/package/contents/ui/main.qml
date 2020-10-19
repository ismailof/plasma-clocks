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


Item {
    id: lcdclock

    width: units.gridUnit * 15
    height: units.gridUnit * 7

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

    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: "Local"
        interval: showSeconds ? 1000 : 30000
        onDataChanged: {
            var date = new Date(data["Local"]["DateTime"]);
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
        Layout.minimumWidth: plasmoid.formFactor !== PlasmaCore.Types.Vertical ? representation.height : units.gridUnit
        Layout.minimumHeight: plasmoid.formFactor === PlasmaCore.Types.Vertical ? representation.width : units.gridUnit

        spacing: 0

        DigitDisplay {
            digit: Math.floor(hours / 10)
        }
        DigitDisplay {
            digit: hours % 10
        }

        Item {
            Layout.preferredWidth: 10
        }

        DigitDisplay {
            digit: Math.floor(minutes / 10)
        }
        DigitDisplay {
            digit: minutes % 10
        }

        Item {
            visible: showSeconds
            Layout.preferredWidth: 10
        }

        DigitDisplay {
            visible: showSeconds
            Layout.maximumHeight: parent.height * 0.7
            Layout.alignment: Qt.AlignBottom
            digit: Math.floor(seconds / 10)
        }
        DigitDisplay {
            visible: showSeconds
            Layout.maximumHeight: parent.height * 0.7
            Layout.alignment: Qt.AlignBottom
            digit: seconds % 10
        }
    }
}
