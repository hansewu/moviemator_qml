
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    width: 300
    height: 250
    property string saturationParameter: 'saturation'
    Component.onCompleted: {
        keyFrame.initFilter(layoutRoot)
    }

    ColumnLayout {
        id: layoutRoot
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

        RowLayout {
            anchors.fill: parent

            Label {
                text: qsTr('Saturation')
                color: '#ffffff'
            }
            SliderSpinner {
                objectName: 'slider'
                id: slider
                minimumValue: 0
                maximumValue: 300
                suffix: ' %'
                value: filter.getDouble(saturationParameter) * 100
                onValueChanged: {
                    keyFrame.controlValueChanged(slider)
                }
            }
            UndoButton {
                onClicked: slider.value = 100
            }
        }
        Item {
            Layout.fillHeight: true;
        }
    }
}
