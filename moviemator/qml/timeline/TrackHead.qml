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

// 轨道头
Rectangle {
    id: trackHeadRoot
    // 显示轨道的名称
    property string trackName: ''
    // 轨道是否静音
    property bool isMute
    // 轨道是否隐藏
    property bool isHidden
    // 轨道的复合模式
    property int isComposite
    // 轨道是否锁定
    property bool isLocked
    // 轨道是否是视频轨道
    property bool isVideo
    // 轨道是否是音频轨道
    property bool isAudio
    // 轨道是否是文本轨道
    property bool isText
    // 轨道的类型？？？
    property int trackType
    // 轨道是否是滤镜轨道？
    property bool isFilter
    // 轨道是否被选中
    property bool selected: false
    // 轨道是否是当前轨道
    property bool current: false

    // 轨道头被单击时发出的信号
    signal clicked()

    // 点击被锁定的轨道时播放轨道头锁定按钮的缩放动画
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

    // 轨道头鼠标可以操作的区域
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            parent.clicked()
//            nameEdit.visible = false
            if (mouse.button === Qt.RightButton)
                menu.popup()
        }
    }
    // 每一列轨道的轨道头
    Column {
        id: trackHeadColumn
        spacing: (trackHeadRoot.height < 60)? 0 : 6
        anchors {
//            top: parent.top
//            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: 0//(trackHeadRoot.height < 50)? 0 : 4
        }

//        Rectangle {
//            color: 'transparent'
//            width: trackHeadRoot.width - trackHeadColumn.anchors.margins * 2
//            radius: 2
//            border.color: trackNameMouseArea.containsMouse? activePalette.shadow : 'transparent'
//            height: nameEdit.height
//            MouseArea {
//                id: trackNameMouseArea
//                height: parent.height
//                width: nameEdit.width
//                hoverEnabled: true
//                onClicked: {
//                    nameEdit.visible = true
//                    nameEdit.selectAll()
//                }
//            }
//            Label {
//                text: trackName
//                color: activePalette.windowText
//                elide: Qt.ElideRight
//                x: 4
//                y: 3
//                width: parent.width - 8
//            }
//            TextField {
//                id: nameEdit
//                visible: false
//                width: trackHeadRoot.width - trackHeadColumn.anchors.margins * 2
//                text: trackName
//                onAccepted: {
//                    timeline.setTrackName(index, text)
//                    visible = false
//                }
//                onFocusChanged: visible = focus
//            }
//        }
        RowLayout {
            x:0
            spacing: 0
//            CheckBox {
//                id: muteButton
//                checked: isMute
//                //visible: isVideo || isAudio
//                style: CheckBoxStyle {
//                    indicator: Rectangle {
//                        implicitWidth: 16
//                        implicitHeight: 16
//                        radius: 2
//                        color: isMute? activePalette.highlight : trackHeadRoot.color
//                        border.color: activePalette.shadow
//                        border.width: 1

//                        Text {
//                            id: muteText
//                            anchors.horizontalCenter: parent.horizontalCenter
//                            anchors.verticalCenter: parent.verticalCenter
//                            text: qsTr('M', 'Mute')
//                            color: isMute? activePalette.highlightedText : activePalette.windowText
//                        }
//                    }
//                }
//                onClicked: timeline.toggleTrackMute(index)
//                MovieMator.ToolTip { text: qsTr('Mute') }
//            }


//            CheckBox {
//                id: hideButton
//                checked: isHidden
//                visible: isVideo || isFilter
//                style: CheckBoxStyle {
//                    indicator: Rectangle {
//                        implicitWidth: 16
//                        implicitHeight: 16
//                        radius: 2
//                        color: isHidden? activePalette.highlight : trackHeadRoot.color
//                        border.color: activePalette.shadow
//                        border.width: 1
//                        Text {
//                            id: hideText
//                            anchors.horizontalCenter: parent.horizontalCenter
//                            anchors.verticalCenter: parent.verticalCenter
//                            text: qsTr('H', 'Hide')
//                            color: isHidden? activePalette.highlightedText : activePalette.windowText
//                        }
//                    }
//                }
//                onClicked: timeline.toggleTrackHidden(index)
//                MovieMator.ToolTip { text: qsTr('Hide') }
//            }

//            CheckBox {
//                id: compositeButton
//                //visible: isVideo
//                visible: false
//                checked: isComposite
//                style: CheckBoxStyle {
//                    indicator: Rectangle {
//                        implicitWidth: 16
//                        implicitHeight: 16
//                        radius: 2
//                        color: isComposite? activePalette.highlight : trackHeadRoot.color
//                        border.color: activePalette.shadow
//                        border.width: 1
//                        Text {
//                            id: compositeText
//                            anchors.horizontalCenter: parent.horizontalCenter
//                            anchors.verticalCenter: parent.verticalCenter
//                            text: qsTr('C', 'Composite')
//                            color: isComposite? activePalette.highlightedText : activePalette.windowText
//                        }
//                    }
//                }
//                onClicked: timeline.setTrackComposite(index, checkedState)
//                MovieMator.ToolTip { text: qsTr('Composite') }
//            }

            Label {
                text: trackName
                color: activePalette.windowText
                elide: Qt.ElideRight
                width: 22
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: 22
            }
            // 静音按钮
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
            // 隐藏按钮
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
            // 锁定按钮
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

//            ToolButton {
//                id: muteButton
//                visible: true
//                checkable: false
//                implicitWidth: 24
//                implicitHeight: 24
//                iconName: 'mute'
//                iconSource: 'qrc:///icons/light/32x32/mute-blue.png' //checked? tr() : tr('qrc:///icons/light/32x32/volume-normal.png')
//                tooltip: qsTr('Toggle snapping')
//                onClicked: timeline.toggleTrackMute(index)
//                MovieMator.ToolTip { text: qsTr('Mute') }
//            }

//            Button {
//                id: hideButton
//                visible: true
//                checkable: false
//                checked: false
//                implicitWidth: 24
//                implicitHeight: 24
//                iconName: 'visible'
//                iconSource: 'qrc:///icons/light/32x32/visible-normal.png'

//                onClicked: timeline.toggleTrackHidden(index)
//                MovieMator.ToolTip { text: qsTr('Hide') }
//            }

//            Button {
//                id: lockButton
//                visible: true
//                style: ButtonStyle {
//                    background: Rectangle {
//                        implicitWidth: 24
//                        implicitHeight: 24
//                        color: 'transparent'
//                    }
//                }

//                implicitWidth: 24
//                implicitHeight: 24
//                iconName: 'lock'
//                iconSource: isLocked ? 'qrc:///icons/light/32x32/unlock-normal.png' : 'qrc:///icons/light/32x32/visible-normal.png'
//             //   tooltip: qsTr('Toggle snapping')
//                onClicked: {
//                    timeline.setTrackLock(index, !isLocked)
//                }
//                MovieMator.ToolTip { text: qsTr('Lock track') }



//                SequentialAnimation {
//                                    id: lockButtonAnim
//                                    loops: 2
//                                    NumberAnimation {
//                                        target: lockButton
//                                        property: "scale"
//                                        to: 1.8
//                                        duration: 200
//                                    }
//                                    NumberAnimation {
//                                        target: lockButton
//                                        property: "scale"
//                                        to: 1
//                                        duration: 200
//                                    }
//                }
//            }

      }
  }
}

