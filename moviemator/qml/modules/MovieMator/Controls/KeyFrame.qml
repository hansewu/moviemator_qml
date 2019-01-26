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
import QtQuick.Controls.Styles 1.0

RowLayout{

    id: keyFrame
    visible: false
    
    function updateEnableKeyFrame(bEnable)
    {
        bEnableKeyFrame = bEnable
        filter.setEnableAnimation(bEnableKeyFrame)

        return bEnableKeyFrame
    }

    function updateAutoSetAsKeyFrame(bEnable)
    {
        bAutoSetAsKeyFrame = bEnable
        filter.setAutoAddKeyFrame(bAutoSetAsKeyFrame)

        return bAutoSetAsKeyFrame
    }

    property bool bEnableKeyFrame: updateEnableKeyFrame((filter.getKeyFrameNumber() > 0))
    property bool bAutoSetAsKeyFrame: updateAutoSetAsKeyFrame(true)
    
    property double currentFrame: 0
    property bool bKeyFrame: false
    
    signal synchroData()
    signal setAsKeyFrame()
    signal loadKeyFrame(double keyFrameNum)
    signal removedAllKeyFrame()

    function initFilter(){
        var currentFrame = timeline.getPositionInCurrentClip()
        loadKeyFrame(currentFrame)
    }

    function getCurrentFrame(){
        return currentFrame;
    }

    InfoDialog { 
        id: addFrameInfoDialog
        text: qsTr('Auto set as key frame at postion')+ ": " + position + "."
        property int position: 0 
    }

    function showAddFrameInfo(position)
    {
        if (bAutoSetAsKeyFrame == false) return

        addFrameInfoDialog.show     = false
        addFrameInfoDialog.show     = true
        addFrameInfoDialog.position = position
    }

    function addKeyFrameValue()
    {
        
        console.log("11111111111111111111111111111111111: ")
        var position = timeline.getPositionInCurrentClip()
        console.log("position: " + position)
        if (position < 0) return

        //添加首尾关键帧
        if (filter.getKeyFrameNumber() <= 0)
        {
            var paramCount = metadata.keyframes.parameterCount
            for(var i = 0; i < paramCount; i++)
            {
                var key = metadata.keyframes.parameters[i].property
                var value = filter.get(key)

                var position2 = (timeline.getCurrentClipLength() - 1) // filter.producerOut - filter.producerIn + 1
                
                filter.setKeyFrameParaValue(position2, key, value.toString() );
                filter.setKeyFrameParaValue(0, key, value.toString() );
            }
        }

        //插入关键帧
        var paramCount = metadata.keyframes.parameterCount
        for(var i = 0; i < paramCount; i++)
        {            
            var key = metadata.keyframes.parameters[i].property
            var paraType = metadata.keyframes.parameters[i].paraType
            if (paraType === "rect") {
                var rect = filter.getAnimRectValue(position, key)
                filter.setKeyFrameParaRectValue(position, key, rect, 1.0)
            } else {
                var value = filter.get(key)

                console.log("key: "+key)
                console.log("value: "+value)
                console.log("values: "+value.toString())

                filter.setKeyFrameParaValue(position, key, value.toString() );
            }
        }
        filter.combineAllKeyFramePara();
        console.log("2222222222222222222222222222222222222222: ")
        
        showAddFrameInfo(position)
    }

    function removeAllKeyFrame(){
        var position        = timeline.getCurrentClipLength() //filter.producerOut - filter.producerIn + 1
        
        filter.combineAllKeyFramePara();
        while(true) 
        {  
            position = filter.getPreKeyFrameNum(position)
            if(position == -1) break;
 
            filter.removeKeyFrameParaValue(position);
            filter.combineAllKeyFramePara();
            synchroData()
        }
    }

    Connections {
        target: filterDock
        onPositionChanged: {
            var currentFrame = timeline.getPositionInCurrentClip()
        }
    }

    Component.onCompleted:
    {
        currentFrame = timeline.getPositionInCurrentClip()
    }

    // 开启关键帧
    Connections {
        target: keyFrameControl
        onEnableKeyFrameChanged: {
            updateEnableKeyFrame(bEnable)
        }
    }

    // 自动添加关键帧信号，当参数改变时
    Connections {
        target: keyFrameControl
        onAutoAddKeyFrameChanged: {
            updateAutoSetAsKeyFrame(bEnable)
        }
    }

   Connections {
            target: keyFrameControl
            onAddFrameChanged: {
                if(bKeyFrame)
                    return
                bKeyFrame = true
                synchroData()
                setAsKeyFrame()
                // addKeyFrameValue()
            }
   }
   Connections {
            target: keyFrameControl
            onFrameChanged: {
                currentFrame = keyFrameNum
                bKeyFrame = filter.bKeyFrame(currentFrame)
                loadKeyFrame(keyFrameNum)
            }
   }
   Connections {
            target: keyFrameControl
            onRemoveKeyFrame: {
                bKeyFrame = false
                var nFrame = keyFrame.getCurrentFrame();
                synchroData()
                filter.removeKeyFrameParaValue(nFrame);
                if (filter.getKeyFrameNumber() <= 0) {
                    removedAllKeyFrame()
                }
                synchroData()
            }
   }

   // 移除所有关键帧信号
    Connections {
             target: keyFrameControl
             onRemoveAllKeyFrame: {
                bKeyFrame = false
                removeAllKeyFrame()
             }
    }

}

