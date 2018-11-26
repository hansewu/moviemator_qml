
import QtQuick 2.1
import QtQuick.Controls 1.1
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
            text: qsTr('Width')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'wslider'
            id: wslider
            minimumValue: 1
            maximumValue: 99
            suffix: ' px'
            value: filter.getDouble('hori')
            onValueChanged: {
                keyFrame.controlValueChanged(wslider)
            }
        }
        UndoButton {
            onClicked: wslider.value = 2
        }

        Label {
            text: qsTr('Height')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'hslider'
            id: hslider
            minimumValue: 1
            maximumValue: 99
            suffix: ' px'
            value: filter.getDouble('vert')
            onValueChanged: {
                keyFrame.controlValueChanged(hslider)
            }
        }
        UndoButton {
            onClicked: hslider.value = 2
        }
        
        Item {
            Layout.fillHeight: true
        }
    }
}
