/*
 * Copyright (c) 2014-2016 Meltytech, LLC
 *
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: wyl <wyl@pylwyl.local>
 * Author: fuyunhuaxin <2446010587@qq.com>
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
    property string paramAmount: '0'
    property string paramSize: '1'
    property var defaultParameters: [paramAmount, paramSize]
    width: 300
    height: 250
    Component.onCompleted: {
        keyFrame.initFilter(layoutRoot)
    }

    GridLayout {
        id: layoutRoot
        anchors.fill: parent
        anchors.margins: 18
        columns: 3
        rowSpacing: 13

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
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        Preset {
            Layout.columnSpan: 2
            parameters: defaultParameters
            onPresetSelected: {
                aslider.value = filter.getDouble(paramAmount) * 100.0
                sslider.value = filter.getDouble(paramSize) * 100.0
            }
        }

        SeparatorLine {
            Layout.fillWidth: true 
            Layout.columnSpan: 3
        }

        Label {
            text: qsTr('Amount')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'aslider'
            id: aslider
            minimumValue: 0
            maximumValue: 100
            suffix: ' %'
            decimals: 1
            value: filter.getDouble(paramAmount) * 100.0
            onValueChanged:{
                keyFrame.controlValueChanged(aslider) 
            }
        }
        UndoButton {
            onClicked: aslider.value = 50
        }

        Label {
            text: qsTr('Size')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'sslider'
            id: sslider
            minimumValue: 0
            maximumValue: 100
            suffix: ' %'
            decimals: 1
            value: filter.getDouble(paramSize) * 100.0
            onValueChanged:{
                keyFrame.controlValueChanged(sslider) 
            }
        }
        UndoButton {
            onClicked: sslider.value = 50
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
