/*
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: vgawen <gdb_1986@163.com>
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
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1

RowLayout {
    spacing: -3
    property real value
    property alias minimumValue: slider.minimumValue
    property alias maximumValue: slider.maximumValue
    property alias tickmarksEnabled: slider.tickmarksEnabled
    property real  ratio: 1.0
    property alias label: label.text
    property alias decimals: spinner.decimals
    property alias stepSize: spinner.stepSize
    property alias spinnerWidth: spinner.width
    property alias suffix: spinner.suffix
    property alias prefix: spinner.prefix

    SystemPalette { id: activePalette }

    onValueChanged: spinner.value = value / ratio

    Slider {
        id: slider

        Layout.fillWidth: true
        activeFocusOnTab: false

        property bool isReady: false
        Component.onCompleted: {
            isReady = true
            value = parent.value
        }
        onValueChanged: if (isReady) {
            spinner.value = value / ratio
            parent.value = value
        }

        style: SliderStyle {
            groove: Rectangle {
                radius: 3
                color: activePalette.alternateBase
                border.color: 'gray'
                border.width: 1
                implicitHeight: spinner.height

                // Hide the right border.
                Rectangle {
                    visible: !label.visible
                    anchors {
                        top: parent.top
                        right: parent.right
                        bottom: parent.bottom
                        topMargin: 1
                        bottomMargin: 1
                    }
                    width: 3
                    color: parent.color
                }

                // Indicate percentage full.
                Rectangle {
                    anchors {
                        top: parent.top
                        left: parent.left
                        bottom: parent.bottom
                        margins: 1
                    }
                    radius: parent.radius
                    width: parent.width       //(parent.width-50)
                           * (value - minimumValue) / (maximumValue - minimumValue)
                           - parent.border.width
                           - (label.visible? parent.border.width : 3)
                    color: enabled? activePalette.highlight : activePalette.midlight
                }
            }
            handle: Rectangle {
            }
        }
    }

    // Optional label between slider and spinner
    Rectangle {
        width: 4 - parent.spacing * 2
        visible: label.visible
    }
    Label {
        id: label
        visible: text.length
        color:'#ffffff'
    }
    Rectangle {
        width: 4 - parent.spacing * 2
        visible: label.visible
    }

    SpinBox {
        id: spinner

        Layout.minimumWidth: 70
        minimumValue: slider.minimumValue / ratio
        maximumValue: slider.maximumValue / ratio
        stepSize: 1 / Math.pow(10, decimals)
        onValueChanged: slider.value = value * ratio

        style: SpinBoxStyle {
            background: Rectangle {
                color: activePalette.base
                border.color: 'gray'
                border.width: 1
                implicitHeight: 18
                radius: 3

                // Hide the left border.
                Rectangle {
                    visible: !label.visible
                    anchors {
                        top: parent.top
                        left: parent.left
                        bottom: parent.bottom
                        topMargin: 1
                        bottomMargin: 1
                    }
                    width: 3
                    color: parent.color
                }
            }
            incrementControl: Rectangle {}
            decrementControl: Rectangle {}
        }
    }
}
