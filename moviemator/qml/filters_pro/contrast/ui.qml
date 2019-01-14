/*
 * Copyright (c) 2016 Meltytech, LLC
 *
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: wyl <wyl@pylwyl.local>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
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
        anchors.margins: 20
        rowSpacing:15


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
            text: qsTr('Preset') + "   "
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        Preset {
            Layout.columnSpan: 2
            parameters: defaultParameters
            onPresetSelected: {
                setControls()
            }
        }

        SeparatorLine {
            Layout.columnSpan: 3
            Layout.minimumWidth: parent.width
            Layout.maximumWidth: parent.width
        }

        Label {
            text: qsTr('Contrast')
            Layout.alignment: Qt.AlignLeft
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
