
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    width: 300
    height: 250
    Component.onCompleted: {
        if (filter.isNew) {
            // Set default parameter values
            filter.set('noise', 40)
            filter.set('contrast', 100)
            filter.set('brightness', 83)
            filter.savePreset(preset.parameters)
        }
        setControls()
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
        columns: 3
        anchors.fill: parent
        anchors.margins: 8

        KeyFrame{
             id: keyFrame
             Layout.columnSpan:3
             onLoadKeyFrame:
             {
                 var grainValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "noise");
                 if(grainValue != -1.0)
                 {
                     console.log("5.... grainValue:")
                     console.log(grainValue)
                     noiseSlider.value = grainValue
                 }

                 grainValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "brightness");
                 if(grainValue != -1.0)
                 {
                      console.log("12....")
                      console.log(grainValue)
                      brightnessSlider.value = grainValue
                 }
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
            id: noiseSlider
            minimumValue: 1
            maximumValue: 200
            suffix: ' %'
            value: filter.get('noise')
            onValueChanged: {
                console.log("6... setKeyFrameValue will be called")
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "noise",value.toString())
                    filter.combineAllKeyFramePara()

                }
                else
                    filter.set('noise', value)
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
            id: brightnessSlider
            minimumValue: 0
            maximumValue: 400
            value: filter.get('brightness')
            onValueChanged:{
                console.log("7... setKeyFrameValue will be called")
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "brightness",value)
                    filter.combineAllKeyFramePara()

                }
                else
                    filter.set('brightness', value)
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
