/*
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: vgawen <gdb_1986@163.com>
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

import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import MovieMator.Controls 1.0
import QtQuick.Dialogs 1.1

Rectangle {
    id:keyFrame

    color: 'transparent'//activePalette.window
    width: parent.width
    height: 90

    signal enableKeyFrameChanged(bool bEnable)
    signal autoAddKeyFrameChanged(bool bEnable)

    signal addFrameChanged()
    signal frameChanged(double keyFrameNum)
    signal removeKeyFrame()
    signal removeAllKeyFrame()

    function refreshFrameButtonsEnable()
    {
        var position = timeline.getPositionInCurrentClip()

        addKeyFrameButton.enabled   = enableKeyFrameCheckBox.checked && !autoAddKeyFrameCheckBox.checked && metadata && (metadata.keyframes.parameterCount > 0) 

        preKeyFrameButton.enabled   = enableKeyFrameCheckBox.checked && metadata && (metadata.keyframes.parameterCount > 0) && filter.bHasPreKeyFrame(position)

        nextKeyFrameButton.enabled  = enableKeyFrameCheckBox.checked && metadata && (metadata.keyframes.parameterCount > 0) && filter.bHasNextKeyFrame(position)

        removeKeyFrameButton.enabled= enableKeyFrameCheckBox.checked && metadata && (metadata.keyframes.parameterCount > 0) && filter.bKeyFrame(position) && (position != 0) && (position != (timeline.getCurrentClipLength() - 1))

        autoAddKeyFrameCheckBox.enabled = enableKeyFrameCheckBox.checked
    }

    Connections {
        target: filterDock
        onPositionChanged: {
             refreshFrameButtonsEnable()

             var position = timeline.getPositionInCurrentClip()
             frameChanged(position)
        }
    }

    GroupBox{
        width: parent.width
        height: parent.height
        title: " " + qsTr('Key Frame') + " "
        //font.pixelSize: 15
        flat:true
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 0
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 8
        }
        
        GridLayout {
            columns: 4
            CheckBox {
                id: enableKeyFrameCheckBox
                Layout.columnSpan: 4
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: parent.top
                anchors.topMargin: -5
                text: qsTr('Enable Key Frames')
                checked: (filter && filter.getKeyFrameNumber() > 0)
                style: CheckBoxStyle {
                    indicator: Rectangle {
                        color:'red'
                        radius: 3
                        z:1
                        implicitWidth: 13
                        implicitHeight: 13
                        Image {
                            z:2
                            anchors.fill: parent
                            source:enableKeyFrameCheckBox.checked ? '1.jpg':'2.jpg'
                        }
                    }
                }
                onClicked: {
                    if(checked)
                    {   
                        if(metadata.keyframes.parameterCount > 0)
                        {   
                            addFrameChanged()
                            refreshFrameButtonsEnable()
                            autoAddKeyFrameCheckBox.checked = true
                        }  
                    }
                    else
                    {  
                        if(filter.getKeyFrameNumber() > 0)
                            removeKeyFrameWarning.visible = true
                    }
                }
                onCheckedChanged: {
                    refreshFrameButtonsEnable()
                    enableKeyFrameChanged(checked)
                }
            }
            CheckBox {
                id: autoAddKeyFrameCheckBox
                Layout.columnSpan: 4
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: enableKeyFrameCheckBox.bottom
                anchors.topMargin: 0
                text: qsTr('Auto Add Key Frames')
                checked: true
                opacity: enableKeyFrameCheckBox.checked ? 1.0 : 0.5
                onClicked: {
                }
                style: CheckBoxStyle {
                    indicator: Rectangle {
                        color:'red'
                        radius: 3
                        z:1
                        implicitWidth: 13
                        implicitHeight: 13
                        Image {
                            z:2
                            anchors.fill: parent
                            source:autoAddKeyFrameCheckBox.checked ? '1.jpg':'2.jpg'
                        }
                    }
                }
                onCheckedChanged: 
                {
                    refreshFrameButtonsEnable() 
                    autoAddKeyFrameChanged(checked)
                }    
            }

            Button {
                id:addKeyFrameButton
                anchors {
                    top: autoAddKeyFrameCheckBox.bottom
                    left: parent.left
                    leftMargin: 15
                    topMargin: 7
                }
                implicitWidth: 25
                implicitHeight: 25

                enabled: refreshFrameButtonsEnable() 
                opacity: enabled ? 1.0 : 0.5
                tooltip: qsTr('Add key frame')
                //customIconSource: 'qrc:///icons/light/32x32/list-add.png'
                //customText: qsTr('Add')
                //buttonWidth : 85
                onClicked: {
                    addFrameChanged()
                    refreshFrameButtonsEnable() 
                }

                style: ButtonStyle {
                    background: Rectangle {
                        color: 'transparent'
                    }  
                }
                Image {
                    fillMode: Image.PreserveAspectCrop
                    anchors.fill: parent
                    source: addKeyFrameButton.pressed ? "qrc:///icons/light/32x32/add_keyframe-on.png" : (enabled?'qrc:///icons/light/32x32/add_keyframe.png':'qrc:///icons/light/32x32/add_keyframe_disable.png')
                }
            }

            Button {
                id:removeKeyFrameButton
                anchors {
                    top: addKeyFrameButton.top
                    left: addKeyFrameButton.right
                    leftMargin: 30
                    topMargin: 1
                }
                implicitWidth: 25
                implicitHeight: 25

                opacity: enabled ? 1.0 : 0.5
                tooltip: qsTr('Remove key frame')
                //customIconSource: 'qrc:///icons/light/32x32/list-remove.png'
                //customText: qsTr('Remove')
                //buttonWidth : 85

                style: ButtonStyle {
                    background: Rectangle {
                        color: 'transparent'
                    }  
                }
                Image {
                    fillMode: Image.PreserveAspectCrop
                    anchors.fill: parent
                    source: removeKeyFrameButton.pressed ? "qrc:///icons/light/32x32/remove_keyframe-on.png" : (enabled?'qrc:///icons/light/32x32/remove_keyframe.png':'qrc:///icons/light/32x32/remove_keyframe_disable.png')
                }

                onClicked: {
                    var position        = timeline.getPositionInCurrentClip()

                    if((position == 0) || (position == (timeline.getCurrentClipLength() - 1))) 
                        return   //首尾帧无法删除

                    var bKeyFrame       = filter.bKeyFrame(position)
                    if (bKeyFrame)
                        filter.removeKeyFrameParaValue(position)
                        removeKeyFrame()

                    refreshFrameButtonsEnable() 
                }
            }

            Button {
                id:preKeyFrameButton
                anchors {
                    top: addKeyFrameButton.top
                    left: removeKeyFrameButton.right
                    leftMargin: 30
                    topMargin: 1
                }
                implicitWidth: 25
                implicitHeight: 25

                opacity: enabled ? 1.0 : 0.5
                tooltip: qsTr('Prev key frame')
                //customIconSource: enabled?'qrc:///icons/light/32x32/previous_keyframe.png' :'qrc:///icons/light/32x32/previous_keyframe_disable.png'
                //customText: qsTr('<<')
                //buttonWidth : 85
                onClicked: {
                    var nFrame = filter.getPreKeyFrameNum(timeline.getPositionInCurrentClip())
                    if(nFrame != -1)
                    {
                        filterDock.position = nFrame
                    }
                }

                style: ButtonStyle {
                    background: Rectangle {
                        color: 'transparent'
                    }  
                }
                Image {
                    fillMode: Image.PreserveAspectCrop
                    anchors.fill: parent
                    source: preKeyFrameButton.pressed? "qrc:///icons/light/32x32/previous_keyframe-on.png" : (enabled?'qrc:///icons/light/32x32/previous_keyframe.png':'qrc:///icons/light/32x32/previous_keyframe_disable.png')
                }
            }

            Button {
                id:nextKeyFrameButton
                anchors {
                    top: addKeyFrameButton.top
                    left: preKeyFrameButton.right
                    leftMargin: 30
                    topMargin: 1
                }
                implicitWidth: 25
                implicitHeight: 25

                opacity: enabled ? 1.0 : 0.5
                tooltip: qsTr('Next key frame')
                //customIconSource: 'qrc:///icons/light/32x32/bg.png'
                //customIconSource: enabled?'qrc:///icons/light/32x32/next_keyframe.png':'qrc:///icons/light/32x32/next_keyframe_disable.png'
                //customText: qsTr('>>')
                //buttonWidth : 85
                onClicked: {
                    var nFrame = filter.getNextKeyFrameNum(timeline.getPositionInCurrentClip())
                    if(nFrame != -1)
                    {
                        filterDock.position = nFrame
                        //frameChanged(nFrame)
                    }
                }
                style: ButtonStyle {
                    background: Rectangle {
                        color: 'transparent'
                    }  
                }
                Image {
                    fillMode: Image.PreserveAspectCrop
                    anchors.fill: parent
                    source: nextKeyFrameButton.pressed? "qrc:///icons/light/32x32/next_keyframe-on.png" : (enabled?'qrc:///icons/light/32x32/next_keyframe.png':'qrc:///icons/light/32x32/next_keyframe_disable.png')
                }
            }
        }

    }

    MessageDialog {
        id: removeKeyFrameWarning
        visible: false
        title: qsTr("Confirm Removing Keyframes")
        text: qsTr('This will remove all keyframes.<p>Do you still want to do this?')
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            enableKeyFrameCheckBox.checked = false

            removeAllKeyFrame()
        }
        onNo: 
            enableKeyFrameCheckBox.checked = true  
        
    }



    Connections {
        target: filterDock
        onCurrentFilterChanged: {
            enableKeyFrameCheckBox.checked = ( filter && filter.getKeyFrameNumber() > 0)

            autoAddKeyFrameChanged(autoAddKeyFrameCheckBox.checked)
        }
    }

    Connections {
        target: filter
        onChanged: {
            enableKeyFrameCheckBox.checked = (filter && filter.getKeyFrameNumber() > 0)

            autoAddKeyFrameChanged(autoAddKeyFrameCheckBox.checked)
        }
    }
/*
    Label {
        text: qsTr('Key Frame :')
        Layout.alignment: Qt.AlignRight
        color: '#ffffff'
        anchors {
            left: parent.left
            leftMargin: 5
            bottom :addKeyFrameButton.bottom
            bottomMargin: 9
        }
    }

   

    CustomFilterButton {
        id:removeAllKeyFrameButton
        anchors {
            top: addKeyFrameButton.top
            left: nextKeyFrameButton.right
            leftMargin: 30
            topMargin: 0
        }
        implicitWidth: 32
        implicitHeight: 32

        visible: false
        enabled: filter.bHasNextKeyFrame(timeline.getPositionInCurrentClip()) || filter.bHasNextKeyFrame(timeline.getPositionInCurrentClip())
        opacity: enabled ? 1.0 : 0.5
        tooltip: qsTr('Remove all key frame')
        customIconSource: 'qrc:///icons/light/32x32/bg.png'
        //customIconSource: enabled?'qrc:///icons/light/32x32/next_keyframe.png':'qrc:///icons/light/32x32/next_keyframe_disable.png'
        customText: qsTr('Remove all')
        buttonWidth : 100
        onClicked: {
            removeAllKeyFrame()
        }
    }
    
*/
}
