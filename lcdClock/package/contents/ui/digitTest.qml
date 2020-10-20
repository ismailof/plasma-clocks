import QtQuick 2.0
import QtQuick.Layouts 1.12

RowLayout {
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

    Rectangle {
        z: -1
        anchors.fill: parent
        color: "black"
    }
}
