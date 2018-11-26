
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

    function setControls() {
        var keyFrameCount = filter.getKeyFrameCountOnProject("noise");
        console.log("1....., keyFrameCount:")
        console.log(keyFrameCount)
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
                var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "noise");
                var keyValue = filter.getKeyValueOnProjectOnIndex(index, "noise");

                filter.setKeyFrameParaValue(nFrame, "noise", keyValue)

                keyValue = filter.getKeyValueOnProjectOnIndex(index, "brightness");
                filter.setKeyFrameParaValue(nFrame, "brightness", keyValue)
            }

            filter.combineAllKeyFramePara();
            console.log(filter.getKeyValueOnProjectOnIndex(0, "noise"))
            console.log(filter.getKeyValueOnProjectOnIndex(0, "brightness"))

            noiseSlider.value = filter.getKeyValueOnProjectOnIndex(0, "noise")
            brightnessSlider.value = filter.getKeyValueOnProjectOnIndex(0, "brightness")
        }
        else
        {
            console.log("12...")
            console.log(filter.get('noise'))
            console.log(filter.get('brightness'))

            noiseSlider.value = filter.get('noise')
            brightnessSlider.value = filter.get('brightness')
        }
    }
    GridLayout {
        id: 'layoutRoot'
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
            parameters: ['noise', 'brightness']
            Layout.columnSpan: 2
            onPresetSelected: setControls()
        }

        Label {
            text: qsTr('Noise')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'noiseSlider'
            id: noiseSlider
            minimumValue: 1
            maximumValue: 200
            suffix: ' %'
            value: filter.get('noise')
            onValueChanged: {
                keyFrame.controlValueChanged(noiseSlider)
            }
        }
        UndoButton {
            onClicked: noiseSlider.value = 40
        }

        Label {
            text: qsTr('Brightness')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'brightnessSlider'
            id: brightnessSlider
            minimumValue: 0
            maximumValue: 400
            value: filter.get('brightness')
            onValueChanged:{
                keyFrame.controlValueChanged(brightnessSlider)
            }
        }
        UndoButton {
            onClicked: brightnessSlider.value = 83

        }

        Item {
            Layout.fillHeight: true
        }
    }
}
