
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    property string paramBlur: '0'
    property var defaultParameters: [paramBlur]
    property var oValue: 0.5
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
            Layout.columnSpan: 2
            parameters: defaultParameters
            onPresetSelected: {
                bslider.value = filter.getDouble(paramBlur) * 100.0
            }
        }

        Label {
            text: qsTr('Blur')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'bslider'
            id: bslider
            minimumValue: 0
            maximumValue: 100
            suffix: ' %'
            value: filter.getDouble(paramBlur) * 100.0
            onValueChanged: {
                keyFrame.controlValueChanged(bslider)
            }
        }
        UndoButton {
            onClicked: 
            {
                bslider.value = 50
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
