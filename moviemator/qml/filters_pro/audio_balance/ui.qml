
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

    ColumnLayout {
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
            id: layoutRoot
            Label {
                text: qsTr('Left')
                color: '#ffffff'
            }
            SliderSpinner {
                objectName: 'slider'
                id: slider
                minimumValue: 0
                maximumValue: 1000
                ratio: 1000
                decimals: 2
                label: qsTr('Right')
                value: filter.getDouble('start') * maximumValue
                onValueChanged: {
                    keyFrame.controlValueChanged(slider)
                }
                
            }
            UndoButton {
                onClicked: slider.value = 500
            }
        }
        Item {
            Layout.fillHeight: true;
        }
    }
}
