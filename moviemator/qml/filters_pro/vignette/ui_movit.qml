
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    width: 300
    height: 250

    Component.onCompleted: {
        if (filter.isNew)
            filter.savePreset(preset.parameters)

        var keyFrameCount = filter.getKeyFrameCountOnProject("radius");
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
                var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "radius");
                var keyValue = filter.getKeyValueOnProjectOnIndex(index, "radius");

                filter.setKeyFrameParaValue(nFrame, "radius", keyValue)

                keyValue = filter.getKeyValueOnProjectOnIndex(index, "inner_radius");
                filter.setKeyFrameParaValue(nFrame, "inner_radius", keyValue)
            }
            filter.combineAllKeyFramePara();
        }
        else
        {
            filter.set("radius", radiusSlider.value/100);
            filter.set("inner_radius", innerSlider.value/100);
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
                     radiusSlider.value = vignetteValue* 100.0
                 }

                 vignetteValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "inner_radius");
                 if(vignetteValue != -1.0)
                 {
                      innerSlider.value = vignetteValue* 100.0
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
            Layout.columnSpan: 2
            parameters: ['radius', 'inner_radius']
            onPresetSelected: {
                radiusSlider.value = filter.getDouble('radius') * 100
                innerSlider.value = filter.getDouble('inner_radius') * 100
            }
        }

        Label {
            text: qsTr('Outer radius')
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
                    filter.setKeyFrameParaValue(nFrame, "radius", value / 100)
                    filter.combineAllKeyFramePara()
                }
                else
                  filter.set('radius', value / 100)
            }
            
        }
        UndoButton {
            onClicked: radiusSlider.value = 30
        }

        Label {
            text: qsTr('Inner radius')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            id: innerSlider
            minimumValue: 0
            maximumValue: 100
            suffix: ' %'
            value: filter.getDouble('inner_radius') * 100
            onValueChanged: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "inner_radius", value / 100)
                    filter.combineAllKeyFramePara()
                }
                else
                  filter.set('inner_radius', value / 100)
            }
        }
        UndoButton {
            onClicked: innerSlider.value = 30
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
