
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    property var defaultParameters: ['radius','blur_mix','highlight_cutoff']
    width: 300
    height: 250
    property var radiusValue: 20.0
    property var blurValue: 1.0
    property var cutoffValue: 0.2

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
                radiusslider.value = filter.getDouble("radius")
                blurslider.value = filter.getDouble("blur_mix")
                cutoffslider.value = filter.getDouble("highlight_cutoff")
            }
        }

        // Row 1
        Label {
            text: qsTr('Radius')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'radiusslider'
            id: radiusslider
            minimumValue: 0
            maximumValue: 100
            decimals: 1
            value: filter.getDouble("radius")
            onValueChanged: {
                keyFrame.controlValueChanged(radiusslider)
            }
        }
        UndoButton {
            onClicked: radiusslider.value = 20
        }

        // Row 2
        Label { 
            text: qsTr('Highlight blurriness')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'blurslider'
            id: blurslider
            minimumValue: 0.0
            maximumValue: 1.0
            decimals: 2
            value: filter.getDouble("blur_mix")
            onValueChanged: {
                keyFrame.controlValueChanged(blurslider)
            }
        }
        UndoButton {
            onClicked: blurslider.value = 1.0
        }

        // Row 3
        Label {
            text: qsTr('Highlight cutoff')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'cutoffslider'
            id: cutoffslider
            minimumValue: 0.1
            maximumValue: 1.0
            decimals: 2
            value: filter.getDouble("highlight_cutoff")
            onValueChanged: {
                keyFrame.controlValueChanged(cutoffslider)
            }
        }
        UndoButton {
            onClicked: cutoffslider.value = 0.2
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
