
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

        var keyFrameCount = filter.getKeyFrameCountOnProject("u");
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
               var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "u");
               var keyValue = filter.getKeyValueOnProjectOnIndex(index, "u");
               filter.setKeyFrameParaValue(nFrame, "u", keyValue)

               keyValue = filter.getKeyValueOnProjectOnIndex(index, "v");
               filter.setKeyFrameParaValue(nFrame, "v", keyValue)
            }
            filter.combineAllKeyFramePara();
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
                 var  sepiaValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "u");
                 if(sepiaValue != -1.0)
                 {
                     sliderBlue.value = sepiaValue
                 }

                 sepiaValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "v");
                 if(sepiaValue != -1.0)
                 {
                     sliderRed.value = sepiaValue
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
            parameters: ['u', 'v']
            onPresetSelected: {
                sliderBlue.value = filter.getDouble('u')
                sliderRed.value = filter.getDouble('v')
            }
        }

        Label {
            text: qsTr('Yellow-Blue')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            id: sliderBlue
            minimumValue: 0
            maximumValue: 255
            value: filter.getDouble('u')
            onValueChanged:{
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "u", value)
                    filter.combineAllKeyFramePara()

                }
                else
                    filter.set('u', value)
            }
        }

        UndoButton {
            onClicked: sliderBlue.value = 75
        }

        Label {
            text: qsTr('Cyan-Red')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            id: sliderRed
            minimumValue: 0
            maximumValue: 255
            value: filter.getDouble('v')
            onValueChanged: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "v", value)
                    filter.combineAllKeyFramePara()

                }
                else
                    filter.set('v', value)
            }
        }
        UndoButton {
            onClicked: sliderRed.value = 150
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
