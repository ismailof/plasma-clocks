/*
 *    SPDX-FileCopyrightText: 2020 Ismael Asensio <isma.af@gmail.com>
 *
 *    SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: display

    property int digits: 1
    property int value: 8
    property int numericBase: 10
    property bool zeroPadding: true
    property real opacityOff: 0.1
    property int opacityDelay: PlasmaCore.Units.shortDuration

    property var segmentWord: {
        ""  : 0b00001000,  // default character = "-"
        "0" : 0b00111111,
        "1" : 0b00000110,
        "2" : 0b01011011,
        "3" : 0b01001111,
        "4" : 0b01100110,
        "5" : 0b01101101,
        "6" : 0b01111101,
        "7" : 0b00000111,
        "8" : 0b01111111,
        "9" : 0b01101111,
        "a" : 0b01110111,
        "b" : 0b01111100,
        "c" : 0b00111001,
        "d" : 0b01011110,
        "e" : 0b01111001,
        "f" : 0b01110001,
        " " : 0b00000000,
        "-" : 0b01000000,
        "_" : 0b00001000,
    }

    PlasmaCore.Svg {
        id: digitSvg
        //imagePath: "qrc://images/7segments"
        imagePath: "file:///home/isma/Proyectos/lcdClock/package/contents/ui/7segments.svg"

        readonly property real ratio: size.width / size.height
    }

    RowLayout {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: Math.min(display.height, width / (digitSvg.ratio * digits))
        spacing: 0

        Repeater {
            model: digits

            Item {
                id: digitBox

                readonly property real scale: height / digitSvg.size.height
                readonly property string character: value.toString(numericBase)
                                                         .padStart(digits, (zeroPadding ? "0" : " "))
                                                         .charAt(index)

                Layout.fillWidth: true
                Layout.fillHeight: true

                Repeater {
                    model: 7    // 7 segments
                    delegate: PlasmaCore.SvgItem {
                        svg: digitSvg
                        elementId: "abcdefg".charAt(index)

                        opacity: (segmentWord[character] || segmentWord[""]) & (1 << index) ? 1 : opacityOff

                        Behavior on opacity {
                            NumberAnimation { duration: opacityDelay }
                        }

                        readonly property rect elementRect: svg.elementRect(elementId)
                        x: Math.round(elementRect.x * digitBox.scale)
                        y: Math.round(elementRect.y * digitBox.scale)
                        width: Math.round(elementRect.width * digitBox.scale)
                        height: Math.round(elementRect.height * digitBox.scale)
                    }
                }
            }
        }
    }
}
