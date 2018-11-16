
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
   width: 300
    height: 250
    Component.onCompleted: {
        filter.set('start', 1)
     //   filter.set('blur', '0=0.1;100=1;200=0.1')
        var keyFrameCount = filter.getKeyFrameCountOnProject("hori");
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
              var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "hori");
             var horikeyValue = filter.getKeyValueOnProjectOnIndex(index, "hori");
             var verKeyValue = filter.getKeyValueOnProjectOnIndex(index, "vert");

             filter.setKeyFrameParaValue(nFrame, "hori", horikeyValue.toString())
             filter.setKeyFrameParaValue(nFrame, "vert", verKeyValue.toString())

            }

            filter.combineAllKeyFramePara();
            wslider.value =     filter.getKeyValueOnProjectOnIndex(0, "hori");
            hslider.value = filter.getKeyValueOnProjectOnIndex(0, "vert");
        }

        if (filter.isNew) {
            // Set default parameter values
            filter.set('hori', 2)
            wslider.value = 2;
            filter.set('vert', 2)
            hslider.value = 2

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
                
                
                console.log("onLoadKeyFrameonLoadKeyFrame: position: " + keyFrameNum)
                
                var blurValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "hori");
                console.log("hori: " + blurValue)
                if(blurValue != -1.0)
                {
                    wslider.value = blurValue
                }
                blurValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "vert");
                console.log("vert: " + blurValue)
                if(blurValue != -1.0)
                {
                    hslider.value = blurValue
                }
            }
        }

        Label {
            text: qsTr('Width')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            id: wslider
            minimumValue: 1
            maximumValue: 99
            suffix: ' px'
            value: filter.getDouble('hori')
            onValueChanged: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "hori", value.toString())
                    filter.combineAllKeyFramePara()
                }
                else
                    filter.set('hori', value)

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
            id: hslider
            minimumValue: 1
            maximumValue: 99
            suffix: ' px'
            value: filter.getDouble('vert')
            onValueChanged: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "vert", value.toString())
                    filter.combineAllKeyFramePara()
                }
                else
                  filter.set('vert', value)

                
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
