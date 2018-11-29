/*
 * Copyright (c) 2013-2015 Meltytech, LLC
 * Author: Dan Dennedy <dan@dennedy.org>
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
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0

Item {
    width: 300
    height: 250
    property string gainParameter: 'gain'
    Component.onCompleted: {
        keyFrame.initFilter(layoutRoot)
    }

    ColumnLayout {
        
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

        RowLayout {
            id: layoutRoot
            Label {
                text: qsTr('Gain')
                color: '#ffffff'
            }
            SliderSpinner {
                objectName: 'slider'
                id: slider
                minimumValue: -50
                maximumValue: 24
                suffix: 'dB'
                decimals: 1
                spinnerWidth: 80
                value: toDb(filter.getDouble(gainParameter))
                onValueChanged: {
                    keyFrame.controlValueChanged(slider)
                }
                
            }
            UndoButton {
                onClicked: slider.value = 0
            }
        }
        Item {
            Layout.fillHeight: true;
        }
    }
}
