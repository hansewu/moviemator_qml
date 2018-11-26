
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
            color: '#ffffff'
        }
        Preset {
            id: preset
            Layout.columnSpan: 2
            parameters: ['u', 'v']
            onPresetSelected: {
                sliderBlue.value = filter.getDouble('u')
                sliderRed.value = filter.getDouble('v')
            }
        }

        Label {
            text: qsTr('Yellow-Blue')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            property var lastValue:75
            id: sliderBlue
            objectName: 'sliderBlue'
            minimumValue: 0
            maximumValue: 255
            //value: (filter.getDouble('u') == -1) ? sliderBlue.value : (filter.getDouble('u'))
            value:75
            onValueChanged:{
                keyFrame.controlValueChanged(sliderBlue)
            }
        }

        UndoButton {
            onClicked: sliderBlue.value = 75
        }

        Label {
            text: qsTr('Cyan-Red')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            property var lastValue:150
            id: sliderRed
            objectName:'sliderRed'
            minimumValue: 0
            maximumValue: 255
            value: 150
            onValueChanged: {
                keyFrame.controlValueChanged(sliderRed)
            }
        }
        UndoButton {
            onClicked: sliderRed.value = 150
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
