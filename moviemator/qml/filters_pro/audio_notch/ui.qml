
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    width: 300
    height: 250
    property bool bEnableControls: keyFrame.bKeyFrame  ||  (!filter.getKeyFrameNumber())

    Component.onCompleted: {
        if (filter.isNew) {
            // Set default parameter values
            filter.set('0', 322)
            filter.set('1', 322)
            filter.set('2', 1)
            filter.set('wetness', 1.0)
            filter.savePreset(preset.parameters)
        }
        setControls()
    }

    function setControls() {
        sliderCenter.value = filter.getDouble('0')
        sliderBandwidth.value = filter.getDouble('1')
        sliderStages.value = filter.get('2')
        sliderWetness.value = filter.getDouble('wetness') * sliderWetness.maximumValue
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 8
        columns: 3

        Label {
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignRight
            color: bEnableControls?'#ffffff': '#828282'
        }
        Preset {

            id: preset
            enabled: bEnableControls
            parameters: ['0', '1', '2', 'wetness']
            Layout.columnSpan: 2
            onPresetSelected: setControls()
        }

        Label {
            text: qsTr('Center frequency')
            Layout.alignment: Qt.AlignRight
            color: bEnableControls?'#ffffff': '#828282'
        }
        SliderSpinner {
            id: sliderCenter
            enabled: bEnableControls
            minimumValue: 5
            maximumValue: 21600
            suffix: ' Hz'
            spinnerWidth: 80
            value: filter.getDouble('0')
            onValueChanged: {
               filter.set('0', value)
            }
        }
        UndoButton {
            enabled: bEnableControls
            onClicked: sliderCenter.value = 322
        }

        Label { 
            text: qsTr('Bandwidth')
        Layout.alignment: Qt.AlignRight
        color: bEnableControls?'#ffffff': '#828282'
        }

        SliderSpinner {
            id: sliderBandwidth
            enabled: bEnableControls
            minimumValue: 5
            maximumValue: 21600
            suffix: ' Hz'
            spinnerWidth: 80
            value: filter.getDouble('1')
            onValueChanged: {
                filter.set('1', value)
            }
        }
        UndoButton {
            enabled: bEnableControls
            onClicked: sliderBandwidth.value = 322
        }

        Label { text: qsTr('Rolloff rate')
        Layout.alignment: Qt.AlignRight
        color: bEnableControls?'#ffffff': '#828282'
        }
        SliderSpinner {
            id: sliderStages
            enabled: bEnableControls
            minimumValue: 1
            maximumValue: 10
            spinnerWidth: 80
            value: filter.get('1')
            onValueChanged: {
                filter.set('1', value)
            }
        }
        UndoButton {
            onClicked: sliderStages.value = 1
            enabled: bEnableControls
        }

        Label { text: qsTr('Dry')
        Layout.alignment: Qt.AlignRight
        color: bEnableControls?'#ffffff': '#828282'
        }
        SliderSpinner {
            id: sliderWetness
            enabled: bEnableControls
            minimumValue: 0
            maximumValue: 100
            decimals: 1
            spinnerWidth: 80
            label: qsTr('Wet')
            suffix: ' %'
            value: filter.getDouble('wetness') * maximumValue
            onValueChanged: {
                filter.set('wetness', value / maximumValue)
            }
        }
        UndoButton {
            enabled: bEnableControls
            onClicked: sliderWetness.value = sliderWetness.maximumValue
        }

        Item {
            Layout.fillHeight: true;
        }
    }
}
