
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    width: 300
    height: 250
    Component.onCompleted: {
        filter.set('start', 1)
        if (filter.isNew) {
            // Set default parameter values
            filter.set('level', 1)
            filter.set('alpha', 100.0 / 100.0)
            filter.set('opacity', filter.getDouble('alpha'))
            slider.value = filter.getDouble('alpha') * 100.0
        }
        var keyFrameCount = filter.getKeyFrameCountOnProject("alpha");
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
              var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "alpha");
              var keyValue = filter.getKeyValueOnProjectOnIndex(index, "alpha");
              filter.setKeyFrameParaValue(nFrame, "0", keyValue)
            }
            filter.combineAllKeyFramePara();
        }
    }

    function setKeyFrameValue(bKeyFrame)
    {
        var nFrame = keyFrame.getCurrentFrame();
        if(bKeyFrame)
        {

            filter.setKeyFrameParaValue(nFrame, "alpha", (slider.value/100).toString())
            filter.combineAllKeyFramePara();
        }
        else
        {
            //Todo, delete the keyframe date of the currentframe
            filter.removeKeyFrameParaValue(nFrame);
            if(!filter.getKeyFrameNumber())
            {
                filter.anim_set("alpha","")
            }
            filter.set("alpha", slider.value/100);

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
                 var glowValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "alpha");
                 if(glowValue != -1.0)
                 {
                     slider.value = glowValue * 100.0

                 }

             }
         }

        Label {
            text: qsTr('Opacity')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            id: slider
            minimumValue: 0
            maximumValue: 100
            suffix: ' %'
            value: filter.getDouble('alpha') * 100.0
            onValueChanged: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "alpha", value / 100.0)
                    filter.setKeyFrameParaValue(nFrame, "opacity", value)
                    filter.combineAllKeyFramePara()
                }
                else{
                    filter.set('alpha', value / 100.0)
                    filter.set('opacity', filter.getDouble('alpha'))
                }
                
            }
        }
        UndoButton {
            onClicked: slider.value = 100
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
