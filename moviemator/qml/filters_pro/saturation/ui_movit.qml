
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    width: 300
    height: 250
    property string saturationParameter: 'saturation'
    Component.onCompleted: {
        if (filter.isNew) {
            // Set default parameter values
            filter.set(saturationParameter, 1.0)
            slider.value = 100
        }

        var keyFrameCount = filter.getKeyFrameCountOnProject("saturation");
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
                var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "saturation");
                var keyValue = filter.getKeyValueOnProjectOnIndex(index, "saturation");

                filter.setKeyFrameParaValue(nFrame, saturationParameter, keyValue )
            }
            filter.combineAllKeyFramePara();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8

        KeyFrame{
            id: keyFrame
            Layout.columnSpan:3
            onLoadKeyFrame:
            {
                var saturationValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, saturationParameter);
                if(saturationValue != -1.0)
                {
                    slider.value = saturationValue * 100.0
                }

            }
        }

        RowLayout {
            anchors.fill: parent

            Label {
                text: qsTr('Saturation')
                color: '#ffffff'
            }
            SliderSpinner {
                id: slider
                minimumValue: 0
                maximumValue: 300
                suffix: ' %'
                value: filter.getDouble(saturationParameter) * 100
                onValueChanged: {
                    if(keyFrame.bKeyFrame)
                    {
                        var nFrame = keyFrame.getCurrentFrame();
                        filter.setKeyFrameParaValue(nFrame,saturationParameter ,  (value / frei0rMaximum))
                        filter.combineAllKeyFramePara()
                    }
                    else
                        filter.set(saturationParameter, value / 100)
                }
            }
            UndoButton {
                onClicked: slider.value = 100
            }
        }
        Item {
            Layout.fillHeight: true;
        }
    }
}
