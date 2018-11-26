
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0
import QtQuick.Controls.Styles 1.4

Item {
    width: 300
    height: 250

    Component.onCompleted: {
        keyFrame.initFilter(layoutRoot)
    }
    GridLayout {
        id: layoutRoot
        columns: 3
        anchors.fill: parent
        anchors.margins: 8

        YFKeyFrame{
            id: keyFrame
            Layout.columnSpan:3
            onSynchroData:{
                keyFrame.setDatas(layoutRoot)
            }
            onLoadKeyFrame:{
                keyFrame.loadFrameValue(layoutRoot)
            }
        }

        Label {
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignRight
            color:'#ffffff'
        }
        Preset {
            id: preset
            Layout.columnSpan: 2
            parameters: ['wave', 'speed', 'deformX', 'deformX']
            onPresetSelected: {
                waveSlider.value = filter.getDouble('wave')
                speedSlider.value = filter.getDouble('speed')
                deformXCheckBox.checked = filter.get('deformX') === '1'
                deformYCheckBox.checked = filter.get('deformY') === '1'
            }
        }

        Label {
            text: qsTr('Amplitude')
            Layout.alignment: Qt.AlignRight
            color:'#ffffff'
        }
        SliderSpinner {
            objectName: 'waveSlider'
            id: waveSlider
            minimumValue: 1
            maximumValue: 500
            value: filter.getDouble('wave')
            onValueChanged: {
                keyFrame.controlValueChanged(waveSlider)
            }
        }
        UndoButton {
            onClicked: waveSlider.value = 10
        }

        Label {
            text: qsTr('Speed')
            Layout.alignment: Qt.AlignRight
            color:'#ffffff'
        }
        SliderSpinner {
            objectName: 'speedSlider'
            id: speedSlider
            minimumValue: 0
            maximumValue: 1000
            value: filter.getDouble('speed')
            onValueChanged: {
                keyFrame.controlValueChanged(speedSlider)
            }
        }
        UndoButton {
            onClicked: speedSlider.value = 5
        }

        Label {}
        CheckBox {
            objectName: 'deformXCheckBox'
            id: deformXCheckBox
//            text: qsTr('Deform horizontally?')
            Layout.columnSpan: 2
            checked: filter.get('deformX') === '1'
            property bool isReady: false
            Component.onCompleted: isReady = true
            onClicked: {
                if (isReady)
                {
                    keyFrame.controlValueChanged(deformXCheckBox)
                }
            }

            style: CheckBoxStyle {
                        label: Text {
                            color: "white"
                            text: qsTr('Deform horizontally?')
                        }
            }
        }

        Label {}
        CheckBox {
            objectName: 'deformYCheckBox'
            id: deformYCheckBox
         //   text: qsTr('Deform vertically?')
            Layout.columnSpan: 2
            checked: filter.get('deformY') === '1'
            property bool isReady: false
            Component.onCompleted: isReady = true
            onClicked: {
                if (isReady)
                {
                    keyFrame.controlValueChanged(deformYCheckBox)
                }
            }
            style: CheckBoxStyle {
                        label: Text {
                            color: "white"
                            text: qsTr('Deform vertically?')
                        }
            }

        }

        Item {
            Layout.fillHeight: true
        }
    }
}
