
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    property var defaultParameters: ['circle_radius','gaussian_radius', 'correlation', 'noise']
    width: 300
    height: 250
    Component.onCompleted: {
        if (filter.isNew) {
            // Set default parameter values
            filter.set('circle_radius', 2.0)
            filter.set('gaussian_radius', 0.0)
            filter.set('correlation', 0.95)
            filter.set('noise', 0.01)
            filter.savePreset(defaultParameters)
            cradiusslider.value = filter.getDouble("circle_radius")
            gradiusslider.value = filter.getDouble("gaussian_radius")
            corrslider.value = filter.getDouble("correlation")
            noiseslider.value = filter.getDouble("noise")
        }
        var keyFrameCount = filter.getKeyFrameCountOnProject("anim-circle_radius");
        var index=0
        for(index=0; index<keyFrameCount;index++)
        {
            var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "anim-circle_radius");
            var keyValue = filter.getKeyValueOnProjectOnIndex(index, "anim-circle_radius");
            filter.setKeyFrameParaValue(nFrame, "circle_radius", keyValue)

            keyValue = filter.getKeyValueOnProjectOnIndex(index, "anim-gaussian_radius");
            filter.setKeyFrameParaValue(nFrame, "gaussian_radius", keyValue)

            keyValue = filter.getKeyValueOnProjectOnIndex(index, "anim-correlation");
            filter.setKeyFrameParaValue(nFrame, "correlation", sharpenValue.toString)

            keyValue = filter.getKeyValueOnProjectOnIndex(index, "anim-noise");
            filter.setKeyFrameParaValue(nFrame, "noise", sharpenValue.toString())
        }
        filter.combineAllKeyFramePara();
    }

    function setKeyFrameValue(bKeyFrame)
     {
         var nFrame = keyFrame.getCurrentFrame();
         if(bKeyFrame)
         {

             var sharpenValue = cradiusslider.value;
             filter.setKeyFrameParaValue(nFrame, "circle_radius", sharpenValue.toString())

             sharpenValue = gradiusslider.value;
             filter.setKeyFrameParaValue(nFrame, "gaussian_radius", sharpenValue.toString())

             sharpenValue = corrslider.value;
             filter.setKeyFrameParaValue(nFrame, "correlation", sharpenValue.toString)

             sharpenValue = noiseslider.value;
             filter.setKeyFrameParaValue(nFrame, "noise", sharpenValue.toString())

             filter.combineAllKeyFramePara();
         }
         else
         {
             //Todo, delete the keyframe date of the currentframe
             filter.removeKeyFrameParaValue(nFrame);

             filter.set("circle_radius", cradiusslider.value)
             filter.set("gaussian_radius", gradiusslider.value)
             filter.set("correlation", corrslider.value)
             filter.set("noise", noiseslider.value)
         }
     }

    GridLayout {
        columns: 3
        anchors.fill: parent
        anchors.margins: 8

        KeyFrame{
             id: keyFrame
             Layout.columnSpan:3
        // 	currentPosition: filterDock.getCurrentPosition()
             onSetAsKeyFrame:
             {
                setKeyFrameValue(bKeyFrame)
             }

             onLoadKeyFrame:
             {
                 var sharpenValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "circle_radius");
                 if(sharpenValue != -1.0)
                 {
                     cradiusslider.value = sharpenValue
                 }

                 sharpenValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "gaussian_radius");
                 if(sharpenValue != -1.0)
                 {
                     gradiusslider.value = sharpenValue
                 }

                 sharpenValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "correlation");
                 if(sharpenValue != -1.0)
                 {
                     corrslider.value = sharpenValue
                 }

                 sharpenValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "noise");
                 if(sharpenValue != -1.0)
                 {
                     noiseslider.value = sharpenValue
                 }
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
            id: cradiusslider
            minimumValue: 0
            maximumValue: 99.99
            decimals: 2
            stepSize: 0.1
            value: filter.getDouble("circle_radius")
            onValueChanged:
            {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "circle_radius", value.toString())
                    filter.combineAllKeyFramePara()
                }
                else
                    filter.set("circle_radius", value)
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
            id: gradiusslider
            minimumValue: 0
            maximumValue: 99.99
            decimals: 2
            stepSize: 0.1
            value: filter.getDouble("gaussian_radius")
            onValueChanged: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "gaussian_radius", value.toString())
                    filter.combineAllKeyFramePara()
                }
                else
                    filter.set("gaussian_radius", value)
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
            id: corrslider
            minimumValue: 0.0
            maximumValue: 1.0
            decimals: 2
            value: filter.getDouble("correlation")
            onValueChanged:{
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "correlation", value.toString)
                    filter.combineAllKeyFramePara()
                }
                else
                    filter.set("correlation", value)
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
            id: noiseslider
            minimumValue: 0.0
            maximumValue: 1.0
            decimals: 2
            value: filter.getDouble("noise")
            onValueChanged:{
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "noise", value.toString())
                    filter.combineAllKeyFramePara()
                }
                else
                    filter.set("noise", value)
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
