/*
 *    SPDX-FileCopyrightText: 2020 Ismael Asensio <isma.af@gmail.com>
 *
 *    SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: displayRoot

    property int digit: 8
    property real opacityOff: 0.1
    property int opacityDelay: PlasmaCore.Units.shortDuration

    Layout.fillWidth: true
    Layout.fillHeight: true

    PlasmaCore.Svg {
        id: digitSvg
        //imagePath: "qrc://images/7segments"
        imagePath: "file:///home/isma/Proyectos/lcdClock/package/contents/ui/7segments.svg"

        readonly property real ratio: size.width / size.height
    }

    Item {
        id: displayBox

        anchors.centerIn: parent
        width: Math.min(displayRoot.width, displayRoot.height * digitSvg.ratio)
        height: width / digitSvg.ratio

        readonly property real scale: height / digitSvg.size.height

        Repeater {
            model: 7    // 7 segments
            delegate: PlasmaCore.SvgItem {
                svg: digitSvg
                elementId: "abcdefg".charAt(index)

                opacity: displayBox.segmentWord & (1 << index) ? 1 : opacityOff

                Behavior on opacity {
                    NumberAnimation { duration: opacityDelay }
                }

                readonly property rect elementRect: svg.elementRect(elementId)
                x: Math.round(elementRect.x * displayBox.scale)
                y: Math.round(elementRect.y * displayBox.scale)
                width: Math.round(elementRect.width * displayBox.scale)
                height: Math.round(elementRect.height * displayBox.scale)
            }
        }

        readonly property int segmentWord: {
            switch (digit) {
                case 0: return 0b00111111
                case 1: return 0b00000110
                case 2: return 0b01011011
                case 3: return 0b01001111
                case 4: return 0b01100110
                case 5: return 0b01101101
                case 6: return 0b01111101
                case 7: return 0b00000111
                case 8: return 0b01111111
                case 9: return 0b01101111
                case 0xA: return 0b01110111
                case 0xB: return 0b01111100
                case 0xC: return 0b00111001
                case 0xD: return 0b01011110
                case 0xE: return 0b01111001
                case 0xF: return 0b01110001
                default: return 0b01000000  // "-"
            }
        }
    }
}
