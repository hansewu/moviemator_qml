
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0
import QtQuick.Controls.Styles 1.4

Item {
    width: 300
    height: 250

    Component.onCompleted: {
        if (filter.isNew) {
            filter.set('wave', 10)
            filter.set('speed', 5)
            filter.set('deformX', 1)
            filter.set('deformY', 1)
            filter.savePreset(preset.parameters)
        }

        var keyFrameCount = filter.getKeyFrameCountOnProject("wave");
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
                var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "wave");
                var keyValue = filter.getKeyValueOnProjectOnIndex(index, "wave");
                filter.setKeyFrameParaValue(nFrame, "wave", keyValue)

                keyValue = filter.getKeyValueOnProjectOnIndex(index, "speed");
                filter.setKeyFrameParaValue(nFrame, "speed", keyValue)

                keyValue = filter.getKeyValueOnProjectOnIndex(index, "deformX");
                filter.setKeyFrameParaValue(nFrame, "deformX", keyValue)

                keyValue = filter.getKeyValueOnProjectOnIndex(index, "deformY");
                filter.setKeyFrameParaValue(nFrame, "deformY", keyValue)

            }
            filter.combineAllKeyFramePara();
        }
        else
        {
            filter.set("wave", waveSlider.value);
            filter.set("speed", speedSlider.value);
            filter.set("deformX", deformXCheckBox.checked);
            filter.set("deformY",  deformYCheckBox.checked);
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
                
                console.log("onLoadKeyFrameonLoadKeyFrameonLoadKeyFrame: " + keyFrameNum)
                var waveValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "wave");
                if(waveValue != -1.0)
                {
                    waveSlider.value = waveValue;
                }
                console.log("wave: " + waveValue)
                
                waveValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "speed");
                if(waveValue != -1.0)
                {
                   speedSlider.value = waveValue;
                }
                console.log("speed: " + waveValue)

                waveValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "deformX");
                if(waveValue == 1)
                {
                   deformXCheckBox.checked = true;
                   filter.set("deformX",Number(true))
                }
                else{
                    deformXCheckBox.checked = false;
                    filter.set("deformX",Number(false))
                }
                    
                console.log("deformX: " + waveValue)

                waveValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "deformY");
                if(waveValue == 1)
                {
                   deformYCheckBox.checked = true;
                   filter.set("deformY",Number(true))
                }
                else{
                    deformYCheckBox.checked = false;
                    filter.set("deformY",Number(false))
                }
                console.log("deformY: " + waveValue)

            }
        }

        Label {
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignRight
            color:'#ffffff'
        }
        Preset {
            id: preset
            Layout.columnSpan: 2
            parameters: ['wave', 'speed', 'deformX', 'deformX']
            onPresetSelected: {
                waveSlider.value = filter.getDouble('wave')
                speedSlider.value = filter.getDouble('speed')
                deformXCheckBox.checked = filter.get('deformX') === '1'
                deformYCheckBox.checked = filter.get('deformY') === '1'
            }
        }

        Label {
            text: qsTr('Amplitude')
            Layout.alignment: Qt.AlignRight
            color:'#ffffff'
        }
        SliderSpinner {
            id: waveSlider
            minimumValue: 1
            maximumValue: 500
            value: filter.getDouble('wave')
            onValueChanged: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "wave", value)
                    filter.combineAllKeyFramePara()

                }
                else
                    filter.set('wave', value)
            }
        }
        UndoButton {
            onClicked: waveSlider.value = 10
        }

        Label {
            text: qsTr('Speed')
            Layout.alignment: Qt.AlignRight
            color:'#ffffff'
        }
        SliderSpinner {
            id: speedSlider
            minimumValue: 0
            maximumValue: 1000
            value: filter.getDouble('speed')
            onValueChanged: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "speed", value)
                    filter.combineAllKeyFramePara()

                }
                else
                    filter.set('speed', value)
            }
        }
        UndoButton {
            onClicked: speedSlider.value = 5
        }

        Label {}
        CheckBox {
            id: deformXCheckBox
//            text: qsTr('Deform horizontally?')
            Layout.columnSpan: 2
            checked: filter.get('deformX') === '1'
            property bool isReady: false
            Component.onCompleted: isReady = true
            onClicked: {
                if (isReady)
                {
                    if(keyFrame.bKeyFrame)
                    {
                        var nFrame = keyFrame.getCurrentFrame();
                        filter.setKeyFrameParaValue(nFrame, "deformX", Number(checked))
                        filter.combineAllKeyFramePara()
                    }
                    else
                        filter.set('deformX', Number(checked))
                }
            }

            style: CheckBoxStyle {
                        label: Text {
                            color: "white"
                            text: qsTr('Deform horizontally?')
                        }
            }
        }

        Label {}
        CheckBox {
            id: deformYCheckBox
         //   text: qsTr('Deform vertically?')
            Layout.columnSpan: 2
            checked: filter.get('deformY') === '1'
            property bool isReady: false
            Component.onCompleted: isReady = true
            onClicked: {
                if (isReady)
                {
                    if(keyFrame.bKeyFrame)
                    {
                        var nFrame = keyFrame.getCurrentFrame();
                        filter.setKeyFrameParaValue(nFrame, "deformY", Number(checked))
                        filter.combineAllKeyFramePara()
                    }
                    else
                        filter.set('deformY', Number(checked))
                }
            }
            style: CheckBoxStyle {
                        label: Text {
                            color: "white"
                            text: qsTr('Deform vertically?')
                        }
            }

        }

        Item {
            Layout.fillHeight: true
        }
    }
}
