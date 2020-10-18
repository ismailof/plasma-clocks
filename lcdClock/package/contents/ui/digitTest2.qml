import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12 as QQC2

ColumnLayout {
    DigitDisplay {
        Layout.fillWidth: true
        Layout.fillHeight: true
        digit: slider.value
    }
    QQC2.Slider {
        id: slider
        from: -1
        to: 15
        stepSize: 1.0
        snapMode: QQC2.Slider.SnapAlways
        value: 0
    }
}