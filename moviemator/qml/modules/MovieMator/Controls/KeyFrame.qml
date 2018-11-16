import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.0

RowLayout{

    id: keyFrame
    visible: false
    
    property double currentFrame: 0
    property bool bKeyFrame: false
    

    signal setAsKeyFrame(bool bKeyFrame)
    signal loadKeyFrame(double keyFrameNum)

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
            var value = filter.get(key)
            
            console.log("key: "+key)
            console.log("value: "+value)
            console.log("values: "+value.toString())
            
            

            filter.setKeyFrameParaValue(position, key, value.toString() );
            
        }
        filter.combineAllKeyFramePara();

        //确认关键帧是否加入成功
        console.log("121212121212121212121212121212211221212: " + position)
        //var textValue = filter.getKeyFrameParaValue(position, "transition.rect");
        for(var i = 0; i < paramCount; i++)
        {
            var key = metadata.keyframes.parameters[i].property
            var value = filter.getKeyFrameParaValue(position, key);
            
            console.log("key: "+key)
            console.log("value: "+value)
            console.log("values: "+value.toString())
            
            
        }
        console.log("2222222222222222222222222222222222222222: ")
        

    }


    // function addKeyFrameValue()
    // {
        
    //     console.log("11111111111111111111111111111111111: ")
    //     //查看set的数据
    //     var position = timeline.getPositionInCurrentClip()
    //     if (position < 0) return

    //     var paramCount = metadata.keyframes.parameterCount
    //     for(var i = 0; i < paramCount; i++)
    //     {
    //         var key = metadata.keyframes.parameters[i].property
    //         var value = filter.get(key)
    //         console.log(paramCount + ": position: " + position)
    //         console.log("key: " + key)
    //         console.log("value: " + value)
            
    //     }
        
    //     //添加关键帧
    //     for(var i = 0; i < paramCount; i++)
    //     {
    //         var key = metadata.keyframes.parameters[i].property
    //         var value = filter.get(key)
            
    //         console.log("position: " + position)
    //         console.log("key: " + key)
    //         console.log("value: " + value)

    //         filter.setKeyFrameParaValue(position, key, value.toString() );

    //         filter.combineAllKeyFramePara();
            
    //     }

    //     //初始化首尾关键帧
    //     // if (filter.getKeyFrameNumber() <= 0)
    //     // {
    //     //     var position2 = filter.producerOut - filter.producerIn + 1 - 5
    //     //     var paramCount = metadata.keyframes.parameterCount
    //     //     for(var i = 0; i < paramCount; i++)
    //     //     {
    //     //         var key = metadata.keyframes.parameters[i].property
    //     //         var value = filter.get(key)

    //     //         filter.setKeyFrameParaValue(position2, key, value.toString() );
    //     //         filter.setKeyFrameParaValue(0, key, value.toString() );

    //     //         filter.combineAllKeyFramePara();
                
    //     //     }
            
            
    //     // }

    //     //查看保存的数据是否正确
    //     console.log("121212121212121212121212121212121212121212121212: ")
    //     for(var i = 0; i < paramCount; i++)
    //     {
    //         var key = metadata.keyframes.parameters[i].property
    //         var value = filter.get(key)
            
    //         console.log("position: " + position)
    //         console.log("key: " + key)
    //         console.log("value: " + value)   
    //     }
        
    //     console.log("2222222222222222222222222222222222222222: ")
        

    //  }

    Component.onCompleted:
    {
        currentFrame = timeline.getPositionInCurrentClip()
    }

    Connections {
             target: keyFrameControl
             onAddFrameChanged: {
                 bKeyFrame = true
                 //setAsKeyFrame(true)
                 addKeyFrameValue()
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
             }
    }

}

