
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    width: 300
    height: 250
    property var radiusValue: 2

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
            Label {
                text: qsTr('Radius')
                color: '#ffffff'
            }
            SliderSpinner {
                objectName: 'slider'
                id: slider
                minimumValue: 0
                maximumValue: 99.99
                value: filter.getDouble('radius')
                decimals: 2
                onValueChanged: {
                    keyFrame.controlValueChanged(slider)
                }
            }
            UndoButton {
                onClicked: slider.value = 3.0
            }
        }
        
        Item {
            Layout.fillHeight: true;
        }
    }
}
