
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    property string paramAmount: '0'
    property string paramSize: '1'
    property var defaultParameters: [paramAmount, paramSize]
    width: 300
    height: 250
    Component.onCompleted: {
        keyFrame.initFilter(layoutRoot)
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
            Layout.columnSpan: 2
            parameters: defaultParameters
            onPresetSelected: {
                aslider.value = filter.getDouble(paramAmount) * 100.0
                sslider.value = filter.getDouble(paramSize) * 100.0
            }
        }

        Label {
            text: qsTr('Amount')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'aslider'
            id: aslider
            minimumValue: 0
            maximumValue: 100
            suffix: ' %'
            decimals: 1
            value: filter.getDouble(paramAmount) * 100.0
            onValueChanged:{
                keyFrame.controlValueChanged(aslider) 
            }
        }
        UndoButton {
            onClicked: aslider.value = 50
        }

        Label {
            text: qsTr('Size')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'sslider'
            id: sslider
            minimumValue: 0
            maximumValue: 100
            suffix: ' %'
            decimals: 1
            value: filter.getDouble(paramSize) * 100.0
            onValueChanged:{
                keyFrame.controlValueChanged(sslider) 
            }
        }
        UndoButton {
            onClicked: sslider.value = 50
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
