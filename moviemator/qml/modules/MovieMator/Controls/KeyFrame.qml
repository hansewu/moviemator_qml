import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.0

RowLayout{

    id: keyFrame
    visible: false
    
    property double currentFrame: 0
    property bool bKeyFrame: false
    
    signal synchroData()
    signal setAsKeyFrame()
    signal loadKeyFrame(double keyFrameNum)
    signal removedAllKeyFrame()

    function getCurrentFrame(){
        return currentFrame;
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

                var position2 = filter.producerOut - filter.producerIn + 1 - 5
                
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
            }
   }

}

