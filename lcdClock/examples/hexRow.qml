/*
 *    SPDX-FileCopyrightText: 2020 Ismael Asensio <isma.af@gmail.com>
 *
 *    SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.12

import "../package/contents/ui"

Rectangle {
    color: "black"

    RowLayout {
        anchors.fill: parent

        Repeater {
            model: 16
            delegate: DigitDisplay {
                Layout.fillWidth: true
                Layout.fillHeight: true
                digits: 1
                numericBase: 16
                value: modelData
            }
        }
    }
}
