import QtQuick 2.0
import QtQuick.Layouts 1.12

RowLayout {
    spacing: 0

    Repeater {
        model: 16
        delegate: DigitDisplay {
            Layout.fillWidth: true
            Layout.fillHeight: true
            digit: modelData
        }
    }

    Rectangle {
        z: -1
        anchors.fill: parent
        color: "black"
    }
}
