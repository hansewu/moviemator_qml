/*
 * Copyright (c) 2014-2016 Meltytech, LLC
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
    property var defaultParameters: ['radius','blur_mix','highlight_cutoff']
    width: 300
    height: 250
    property double radiusValue: 20.0
    property double blurValue: 1.0
    property double cutoffValue: 0.2

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
            onSyncUIDataToProject:{
                keyFrame.syncDataToProject(layoutRoot)
            }
            onRefreshUI:{
                keyFrame.updateParamsUI(layoutRoot)
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
                radiusslider.value = filter.getDouble("radius")
                blurslider.value = filter.getDouble("blur_mix")
                cutoffslider.value = filter.getDouble("highlight_cutoff")
            }
        }

        // Row 1
        Label {
            text: qsTr('Radius')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'radiusslider'
            id: radiusslider
            minimumValue: 0
            maximumValue: 100
            decimals: 1
            value: filter.getDouble("radius")
            onValueChanged: {
                keyFrame.controlValueChanged(radiusslider)
            }
        }
        UndoButton {
            onClicked: radiusslider.value = 20
        }

        // Row 2
        Label { 
            text: qsTr('Highlight blurriness')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'blurslider'
            id: blurslider
            minimumValue: 0.0
            maximumValue: 1.0
            decimals: 2
            value: filter.getDouble("blur_mix")
            onValueChanged: {
                keyFrame.controlValueChanged(blurslider)
            }
        }
        UndoButton {
            onClicked: blurslider.value = 1.0
        }

        // Row 3
        Label {
            text: qsTr('Highlight cutoff')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'cutoffslider'
            id: cutoffslider
            minimumValue: 0.1
            maximumValue: 1.0
            decimals: 2
            value: filter.getDouble("highlight_cutoff")
            onValueChanged: {
                keyFrame.controlValueChanged(cutoffslider)
            }
        }
        UndoButton {
            onClicked: cutoffslider.value = 0.2
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
