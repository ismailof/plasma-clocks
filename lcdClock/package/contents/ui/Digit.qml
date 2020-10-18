import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: digitDisplay

    property int digit: 8

    function digitSegements(_digit) {
        var digitMap = [
            "abcdef",   // 0
            "bc",       // 1
            "abdfg",    // 2
            "abcdg",    // 3
            "bcfg",     // 4
            "acdfg",    // 5
            "acdefg",   // 6
            "abc",      // 7
            "abcdefg",  // 8
            "abcdfg",   // 9
            "abcefg",   // A
            "cdefg",    // B
            "adef",     // C
            "bcdfg",    // D
            "adefg",    // E
            "aefg",     // F
        ]

        return digitMap[_digit].split("")
    }

    PlasmaCore.Svg {
        id: digitSvg
        //imagePath: "qrc://images/7segments"
        imagePath: "file:///home/isma/Proyectos/lcdClock/package/contents/ui/7segments.svg"
    }

    Repeater {
        model: digitSegements(digit)
        delegate: PlasmaCore.SvgItem {
            readonly property rect elementRect: {
                return svg.elementRect(elementId);
            }

            x: elementRect.x * parent.width / svg.size.width
            y: elementRect.y * parent.height / svg.size.height

            svg: digitSvg
            elementId: modelData
        }
    }
}
