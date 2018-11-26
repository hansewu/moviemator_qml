
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    property var defaultParameters: ['circle_radius','gaussian_radius', 'correlation', 'noise']
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
                cradiusslider.value = filter.getDouble("circle_radius")
                gradiusslider.value = filter.getDouble("gaussian_radius")
                corrslider.value = filter.getDouble("correlation")
                noiseslider.value = filter.getDouble("noise")
            }
        }

        // Row 2
        Label {
            text: qsTr('Circle radius')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'cradiusslider'
            id: cradiusslider
            minimumValue: 0
            maximumValue: 99.99
            decimals: 2
            stepSize: 0.1
            value: filter.getDouble("circle_radius")
            onValueChanged: {
                keyFrame.controlValueChanged(cradiusslider) 
            }
            
        }
        UndoButton {
            onClicked: cradiusslider.value = 2
        }
        
        // Row 3
        Label {
            text: qsTr('Gaussian radius')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'gradiusslider'
            id: gradiusslider
            minimumValue: 0
            maximumValue: 99.99
            decimals: 2
            stepSize: 0.1
            value: filter.getDouble("gaussian_radius")
            onValueChanged: {
                keyFrame.controlValueChanged(gradiusslider) 
            }
        }
        UndoButton {
            onClicked: gradiusslider.value = 0
        }

        // Row 4
        Label {
            text: qsTr('Correlation')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'corrslider'
            id: corrslider
            minimumValue: 0.0
            maximumValue: 1.0
            decimals: 2
            value: filter.getDouble("correlation")
            onValueChanged: {
                keyFrame.controlValueChanged(corrslider) 
            }
        }
        UndoButton {
            onClicked: corrslider.value = 0.95
        }

        // Row 5
        Label {
            text: qsTr('Noise')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'noiseslider'
            id: noiseslider
            minimumValue: 0.0
            maximumValue: 1.0
            decimals: 2
            value: filter.getDouble("noise")
            onValueChanged: {
                keyFrame.controlValueChanged(noiseslider) 
            }
        }
        UndoButton {
            onClicked: noiseslider.value = 0.01
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
