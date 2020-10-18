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

//import org.kde.plasma.plasmoid 2.0

RowLayout {

    Repeater {
        model: 16
        delegate: Digit {
            Layout.fillWidth: true
            Layout.fillHeight: true
            digit: modelData
        }
    }
}
