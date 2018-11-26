
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    width: 300
    height: 250
    Component.onCompleted: {
        keyFrame.initFilter(layoutRoot)
    }

    function setControls() {
        rotationSlider.value = filter.getDouble('transition.fix_rotate_x')
        scaleSlider.value = 100 / filter.getDouble('transition.scale_x')
        xOffsetSlider.value = filter.getDouble('transition.ox') * -1
        yOffsetSlider.value = filter.getDouble('transition.oy') * -1

    }

    GridLayout {
        id: layoutRoot
        anchors.fill: parent
        anchors.margins: 8
        columns: 3

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
            color: '#ffffff'
        }
        Preset {
            id: preset
            parameters: ['transition.fix_rotate_x', 'transition.scale_x', 'transition.ox', 'transition.oy']
            Layout.columnSpan: 2
            onPresetSelected: setControls()
        }

        Label {
            text: qsTr('Rotation')
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'rotationSlider'
            id: rotationSlider
            minimumValue: 0
            maximumValue: 360
            decimals: 1
            spinnerWidth: 110
            suffix: qsTr(' degree')
            onValueChanged:{
               keyFrame.controlValueChanged(rotationSlider) 
            }
        }
        UndoButton {
            onClicked: rotationSlider.value = 0
        }

        Label {
            text: qsTr('Scale')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'scaleSlider'
            id: scaleSlider
            minimumValue: 0.1
            maximumValue: 200
            decimals: 1
            spinnerWidth: 110
            suffix: ' %'
            onValueChanged: {
                keyFrame.controlValueChanged(scaleSlider) 
            }
        }
        UndoButton {
            onClicked: scaleSlider.value = 100
        }

        Label {
            text: qsTr('X offset')
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'xOffsetSlider'
            id: xOffsetSlider
            minimumValue: -1000
            maximumValue: 1000
            spinnerWidth: 110
            onValueChanged:{
                keyFrame.controlValueChanged(xOffsetSlider) 
            }
        }
        UndoButton {
            onClicked: xOffsetSlider.value = 0
        }

        Label {
            text: qsTr('Y offset')
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'yOffsetSlider'
            id: yOffsetSlider
            minimumValue: -1000
            maximumValue: 1000
            spinnerWidth: 110
            onValueChanged:{
                keyFrame.controlValueChanged(yOffsetSlider) 
            }
        }
        UndoButton {
            onClicked: yOffsetSlider.value = 0
        }

        Item {
            Layout.fillHeight: true;
        }
    }
}
