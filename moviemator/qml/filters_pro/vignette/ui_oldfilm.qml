

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
        anchors.margins: 18
        rowSpacing: 13

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
        Label{
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        Preset {
            id: preset
            Layout.columnSpan: 2
            parameters: ['radius', 'smooth', 'opacity', 'mode']
            onPresetSelected: {
                radiusSlider.value = filter.getDouble('radius') * 100
                smoothSlider.value = filter.getDouble('smooth') * 100
                opacitySlider.value = (1.0 - filter.getDouble('opacity')) * 100
                modeCheckBox.checked = filter.get('mode') === '1'
            }
        }

        SeparatorLine {
            Layout.fillWidth: true 
            Layout.columnSpan: 3
        }

        Label {
            text: qsTr('Radius')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'radiusSlider'
            id: radiusSlider
            minimumValue: 0
            maximumValue: 100
            suffix: ' %'
            value: filter.getDouble('radius') * 100
            onValueChanged: {
                keyFrame.controlValueChanged(radiusSlider)
            }
        }
        UndoButton {
            onClicked: radiusSlider.value = 50
        }

        Label {
            text: qsTr('Feathering')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'smoothSlider'
            id: smoothSlider
            minimumValue: 0
            maximumValue: 500
            suffix: ' %'
            value: filter.getDouble('smooth') * 100
            onValueChanged: {
                keyFrame.controlValueChanged(smoothSlider)
            }
        }
        UndoButton {
            onClicked: smoothSlider.value = 80
        }

        Label {}
        CheckBox {
            objectName: 'modeCheckBox'
            id: modeCheckBox
//            text: qsTr('Non-linear feathering')
            Layout.columnSpan: 2
            checked: filter.get('mode') === '1'
            property bool isReady: false
            Component.onCompleted: isReady = true
            onClicked: {
                if (isReady)
                {
                    keyFrame.controlValueChanged(modeCheckBox)
                }
            }
            style: CheckBoxStyle {
                        label: Text {
                            color: "white"
                            text: qsTr('Non-linear feathering')
                        }
            }
        }

        Label {
            text: qsTr('Opacity')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'opacitySlider'
            id: opacitySlider
            minimumValue: 0
            maximumValue: 100
            suffix: ' %'
            value: (1.0 - filter.getDouble('opacity')) * 100
            onValueChanged:{
                keyFrame.controlValueChanged(opacitySlider)
            }
        }
        UndoButton {
            onClicked: opacitySlider.value = 100
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
