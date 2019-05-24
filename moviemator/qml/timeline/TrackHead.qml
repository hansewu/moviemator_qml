/*
 * Copyright (c) 2013-2016 Meltytech, LLC
 * Author: Dan Dennedy <dan@dennedy.org>
 *
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

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0 as MovieMator

Rectangle {
    id: trackHeadRoot
    property string trackName: ''
    property bool isMute
    property bool isHidden
    property int isComposite
    property bool isLocked
    property bool isVideo
    property bool isAudio
    property bool isText
    property int trackType
    property bool isFilter
    property bool selected: false
    property bool current: false
    signal clicked()

    function pulseLockButton() {
        lockButtonAnim.restart();
    }

    SystemPalette { id: activePalette; colorGroup: SystemPalette.Active}
    color: selected ? selectedTrackColor : normalColor  //(index % 2)? activePalette.alternateBase : activePalette.base
    border.color: selected? 'white' : backgroundColor//'transparent'
    border.width: selected? 2 : 1
    clip: true
    state: 'normal'
    states: [
        State {
            name: 'selected'
            when: trackHeadRoot.selected
            PropertyChanges {
                target: trackHeadRoot
                color: activePalette.highlight
            }
        },
        State {
            name: 'current'
            when: trackHeadRoot.current
            PropertyChanges {
                target: trackHeadRoot
                color: selectedTrackColor
            }
        },
        State {
            when: !trackHeadRoot.selected && !trackHeadRoot.current
            name: 'normal'
            PropertyChanges {
                target: trackHeadRoot
                color: normalColor //(index % 2)? activePalette.alternateBase : activePalette.base
            }
        }
    ]
    transitions: [
        Transition {
            to: '*'
            ColorAnimation { target: trackHeadRoot; duration: 100 }
        }
    ]

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            parent.clicked()
            if (mouse.button === Qt.RightButton)
                menu.popup()
        }
    }
    Column {
        id: trackHeadColumn
        spacing: (trackHeadRoot.height < 60)? 0 : 6
        anchors {
            verticalCenter: parent.verticalCenter
            margins: 0//(trackHeadRoot.height < 50)? 0 : 4
        }

        RowLayout {
            x:0
            spacing: 0
            Label {
                text: trackName
                color: activePalette.windowText
                elide: Qt.ElideRight
                width: 22
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: 22
            }

            CheckBox {
                id: muteButton
                checked: isMute
                visible: !isText
                style: CheckBoxStyle {
                    indicator: Rectangle {
                        implicitWidth: 18
                        implicitHeight: 18
                        color: 'transparent'
                        Image {
                            visible: isMute
                            sourceSize.width: 18
                            sourceSize.height: 18
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            source: selected? 'qrc:///icons/light/32x32/mute-white.png' : 'qrc:///icons/light/32x32/mute-blue.png'
                        }

                        Image {
                            visible: !isMute
                            sourceSize.width: 18
                            sourceSize.height: 18
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            source: 'qrc:///icons/light/32x32/volume-normal.png'
                        }
                    }
                }

                onClicked: {
                    console.assert(timeline);
                    if(timeline)
                        timeline.toggleTrackMute(index)
                }
                MovieMator.ToolTip { text: qsTr('Mute') }
            }

            CheckBox {
                    id: hideButton
                    visible: isVideo
                    checked: isHidden
                    style: CheckBoxStyle {
                        indicator: Rectangle {
                            implicitWidth: 18
                            implicitHeight: 18
                            color: 'transparent'
                            Image {
                                visible: isHidden
                                sourceSize.width: 18
                                sourceSize.height: 18
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                source: selected? 'qrc:///icons/light/32x32/unvisible-white.png' : 'qrc:///icons/light/32x32/unvisible-blue.png'
                            }

                            Image {
                                visible: !isHidden
                                sourceSize.width: 18
                                sourceSize.height: 18
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                source: 'qrc:///icons/light/32x32/visible-normal.png'
                            }
                        }
                    }


                   onClicked: {
                        console.assert(timeline);
                        if(timeline)
                            timeline.toggleTrackHidden(index)
                   }
                   MovieMator.ToolTip { text: qsTr('Hide') }
            }

            CheckBox {
                id: lockButton
                checked: isLocked
                style: CheckBoxStyle {
                    indicator: Rectangle {
                        implicitWidth: 18
                        implicitHeight: 18
                        color: 'transparent'
                        Image {
                            visible: isLocked
                            sourceSize.width: 18
                            sourceSize.height: 18
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            source: selected? 'qrc:///icons/light/32x32/lock-white.png' : 'qrc:///icons/light/32x32/lock-blue.png'
                        }

                        Image {
                            visible: !isLocked
                            sourceSize.width: 18
                            sourceSize.height: 18
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            source: 'qrc:///icons/light/32x32/unlock-normal.png'
                        }
                    }
                }

                SequentialAnimation {
                    id: lockButtonAnim
                    loops: 2
                    NumberAnimation {
                        target: lockButton
                        property: "scale"
                        to: 1.8
                        duration: 200
                    }
                    NumberAnimation {
                        target: lockButton
                        property: "scale"
                        to: 1
                        duration: 200
                    }
                }

                onClicked: {
                    console.assert(timeline);
                    if(timeline)
                        timeline.setTrackLock(index, !isLocked)
                }
                MovieMator.ToolTip { text: qsTr('Lock track') }
            }
      }
  }
}

