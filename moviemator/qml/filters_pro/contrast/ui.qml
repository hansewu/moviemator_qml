
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    property var defaultParameters: ['gamma_r', 'gamma_g', 'gamma_b', 'gain_r', 'gain_g', 'gain_b']
    property double gammaFactor: 2.0
    property double gainFactor: 2.0
    width: 300
    height: 250
    
    function setControls() {
        var keyFrameCount = filter.getKeyFrameCountOnProject("gamma_r");
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
                var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "gamma_r");
                var keyValue = filter.getKeyValueOnProjectOnIndex(index, "gamma_r");
                var sliderValue = keyValue/gammaFactor*100.0;
                var gammaValue = (1.0 - sliderValue/100.0) * gammaFactor;
                var gainValue = sliderValue/100.0 * gainFactor;

                filter.setKeyFrameParaValue(nFrame,"gamma_r", gammaValue.toString() );
                filter.setKeyFrameParaValue(nFrame,"gamma_g", gammaValue.toString() )
                filter.setKeyFrameParaValue(nFrame,"gamma_b", gammaValue.toString() )

                filter.setKeyFrameParaValue(nFrame,"gain_r", gainValue.toString() )
                filter.setKeyFrameParaValue(nFrame,"gain_g", gainValue.toString() )
                filter.setKeyFrameParaValue(nFrame,"gain_b", gainValue.toString() )

            }
            filter.combineAllKeyFramePara();

            contrastSlider.value = filter.getKeyValueOnProjectOnIndex(0, "gamma_r") / gammaFactor * 100.0
        }
        else
        {
            contrastSlider.value = filter.getDouble("gamma_r") / gammaFactor * 100.0
        }
    }

    Component.onCompleted: {
        keyFrame.initFilter(layoutRoot)
    }

    GridLayout {
        id: layoutRoot
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
            Layout.columnSpan: 2
            parameters: defaultParameters
            onPresetSelected: {
                setControls()
            }
        }

        Label {
            text: qsTr('Contrast')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'contrastSlider'
            id: contrastSlider
            minimumValue: 0
            maximumValue: 100
            decimals: 1
            spinnerWidth: 80
            suffix: ' %'
            onValueChanged: {
                keyFrame.controlValueChanged(contrastSlider)
            }
        }
        UndoButton {
            onClicked: contrastSlider.value = 50
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
