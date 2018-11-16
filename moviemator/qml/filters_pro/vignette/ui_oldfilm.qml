

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0
import QtQuick.Controls.Styles 1.4

Item {
    width: 300
    height: 250
    Component.onCompleted: {
        if (filter.isNew)
            filter.savePreset(preset.parameters)

        var keyFrameCount = filter.getKeyFrameCountOnProject("radius");
        console.log("1... keyFrameCount:")
        console.log(keyFrameCount)
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
                var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "radius");
                var keyValue = filter.getKeyValueOnProjectOnIndex(index, "radius");
                filter.setKeyFrameParaValue(nFrame, "radius", keyValue)

                keyValue = filter.getKeyValueOnProjectOnIndex(index, "smooth");
                filter.setKeyFrameParaValue(nFrame, "smooth", keyValue)

                keyValue = filter.getKeyValueOnProjectOnIndex(index, "opacity");
                filter.setKeyFrameParaValue(nFrame, "opacity", keyValue)

                // keyValue = filter.getKeyValueOnProjectOnIndex(index, "mode");
                // filter.setKeyFrameParaValue(nFrame, "mode", keyValue)
                filter.set("mode",  1);
            }

            console.log("2.... combineAllKeyFramePara will be called")
            filter.combineAllKeyFramePara();
        }
        else
        {
            filter.set("radius", radiusSlider.value / 100);
            filter.set("smooth", smoothSlider.value/100);
            filter.set("opacity", 1.0 - opacitySlider.value / 100);

            filter.set("mode",  modeCheckBox.checked);
        }
    }

    function setKeyFrameValue(bKeyFrame)
    {
        var nFrame = keyFrame.getCurrentFrame();
        if(bKeyFrame)
        {
            
            console.log("radius: " + (radiusSlider.value / 100).toString())
            console.log("smooth: " + (smoothSlider.value/100).toString())
            console.log("opacity: " + (1.0 - opacitySlider.value / 100).toString())
            console.log("mode: " + (smoothSlider.value/100).toString())

            filter.setKeyFrameParaValue(nFrame, "radius", (radiusSlider.value / 100).toString())
            filter.setKeyFrameParaValue(nFrame, "smooth", (smoothSlider.value/100).toString())
            filter.setKeyFrameParaValue(nFrame, "opacity", (1.0 - opacitySlider.value / 100).toString())
            filter.setKeyFrameParaValue(nFrame, "mode", modeCheckBox.checked.toString())

            console.log("7.... combineAllKeyFramePara will be called")
            filter.combineAllKeyFramePara();

        }
        else
        {
            //Todo, delete the keyframe date of the currentframe
            filter.removeKeyFrameParaValue(nFrame);
            if(!filter.getKeyFrameNumber())
             {
                filter.anim_set("radius","")
                filter.anim_set("smooth","")
                filter.anim_set("opacity","")
                filter.anim_set("mode","")
                
             }
            filter.set("radius", radiusSlider.value / 100);
            filter.set("smooth", smoothSlider.value/100);
            filter.set("opacity", 1.0 - opacitySlider.value / 100);

            filter.set("mode",  modeCheckBox.checked);
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
                var vignetteValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "radius");
                if(vignetteValue != -1.0)
                {
                    console.log("3... set radiusSlider value:")
                    console.log(vignetteValue)
                    radiusSlider.value = vignetteValue* 100.0
                }

                vignetteValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "smooth");
                if(vignetteValue != -1.0)
                {
                    console.log("4... set smoothSlider value:")
                    console.log(vignetteValue)
                    smoothSlider.value = vignetteValue* 100.0
                }

                vignetteValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "opacity");
                if(vignetteValue != -1.0)
                {
                    console.log("55... set opacitySlider value:")
                    console.log(vignetteValue)
                    opacitySlider.value = (1-vignetteValue)* 100.0
                }

                vignetteValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "mode");
                if(vignetteValue != -1.0)
                {
                     modeCheckBox.checked = vignetteValue
                }
            }
        }

        Label{
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        Preset {
            id: preset
            Layout.columnSpan: 2
            parameters: ['radius', 'smooth', 'opacity', 'mode']
            onPresetSelected: {
                radiusSlider.value = filter.getDouble('radius') * 100
                smoothSlider.value = filter.getDouble('smooth') * 100
                opacitySlider.value = (1.0 - filter.getDouble('opacity')) * 100
                modeCheckBox.checked = filter.get('mode') === '1'
            }
        }

        Label {
            text: qsTr('Radius')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            id: radiusSlider
            minimumValue: 0
            maximumValue: 100
            suffix: ' %'
            value: filter.getDouble('radius') * 100
            onValueChanged: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "radius", (value / 100))
                    filter.combineAllKeyFramePara()

                }
                else
                    filter.set('radius', value / 100)
            }
        }
        UndoButton {
            onClicked: radiusSlider.value = 50
        }

        Label {
            text: qsTr('Feathering')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            id: smoothSlider
            minimumValue: 0
            maximumValue: 500
            suffix: ' %'
            value: filter.getDouble('smooth') * 100
            onValueChanged: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "smooth", (value / 100))
                    filter.combineAllKeyFramePara()

                }
                else
                    filter.set('smooth', value / 100)
            }
        }
        UndoButton {
            onClicked: smoothSlider.value = 80
        }

        Label {}
        CheckBox {
            id: modeCheckBox
//            text: qsTr('Non-linear feathering')
            Layout.columnSpan: 2
            checked: filter.get('mode') === '1'
            property bool isReady: false
            Component.onCompleted: isReady = true
            onClicked: {
                if (isReady)
                {
                    if(keyFrame.bKeyFrame)
                    {
                        var nFrame = keyFrame.getCurrentFrame();
                        filter.setKeyFrameParaValue(nFrame, "mode", Number(checked))
                        filter.combineAllKeyFramePara()

                    }
                    else
                        filter.set('mode', Number(checked))
                }
            }
            style: CheckBoxStyle {
                        label: Text {
                            color: "white"
                            text: qsTr('Non-linear feathering')
                        }
            }
        }

        Label {
            text: qsTr('Opacity')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            id: opacitySlider
            minimumValue: 0
            maximumValue: 100
            suffix: ' %'
            value: (1.0 - filter.getDouble('opacity')) * 100
            onValueChanged:{
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "opacity", (1.0 - opacitySlider.value / 100))
                    filter.combineAllKeyFramePara()

                }
                else
                    filter.set('opacity', 1.0 - value / 100)
            }
        }
        UndoButton {
            onClicked: opacitySlider.value = 100
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
