
import QtQuick 2.1
import MovieMator.Controls 1.0

Flickable {
    id: spVui
    property string rectProperty
    property string fillProperty
    property string distortProperty
    property string halignProperty
    property string valignProperty
    property var _locale: Qt.locale(application.numericLocale)
    property rect rectCtr
    property rect rectCtr2
    property string metaValue: ''

    property var fillStat:filter.get(fillProperty)
    property var distortStat:filter.get(distortProperty)
    property var valignStat:filter.get(valignProperty)
    property var halignStat:filter.get(halignProperty)

    width: 400
    height: 200
    interactive: false
    clip: true
    property real zoom: (video.zoom > 0)? video.zoom : 1.0
    property rect filterRect: filter.getRect(rectProperty)
    contentWidth: video.rect.width * zoom
    contentHeight: video.rect.height * zoom
    contentX: video.offset.x
    contentY: video.offset.y

    function getAspectRatio() {
        return (filter.get(fillProperty) === '1' && filter.get(distortProperty) === '0')? filter.producerAspect : 0.0
    }

    function updateRectangleUI()
    {
        var rect = filter.getRect(rectProperty)

        if (filter.getKeyFrameNumber() > 0)
        {   
            var position        = timeline.getPositionInCurrentClip()
            rect = filter.getAnimRectValue(position, rectProperty)
        } 
        
        var rectHandles = Qt.rect(rect.x * profile.width, rect.y * profile.height, rect.width * profile.width, rect.height * profile.height)
        rectangle.setHandles(rectHandles)
    }

    Component.onCompleted: {
        var rectT = filter.getRect(rectProperty)
        console.log("Component.onCompletedComponent.onCompleted-2: rectT: " + rectT)
        console.log("Component.onCompletedComponent.onCompleted-2: filterRect: " + filterRect)
        rectT.x = filterRect.x * profile.width
        rectT.y = filterRect.y * profile.height
        rectT.width = filterRect.width * profile.width
        rectT.height = filterRect.height * profile.height
        rectangle.setHandles(rectT)
        console.log("Component.onCompletedComponent.onCompleted-2: rectT-2: " + rectT)
    }

    DropArea { anchors.fill: parent }

    Item {
        id: videoItem
        x: video.rect.x
        y: video.rect.y
        width: video.rect.width
        height: video.rect.height
        scale: zoom

        RectangleControl {
            id: rectangle
            widthScale: video.rect.width / profile.width
            heightScale: video.rect.height / profile.height
            aspectRatio: getAspectRatio()
            handleSize: Math.max(Math.round(8 / zoom), 4)
            borderSize: Math.max(Math.round(1.33 / zoom), 1)
            onWidthScaleChanged: {
                updateRectangleUI()

                console.log("onWidthScaleChangedonWidthScaleChangedonWidthScaleChanged")
            }
            onHeightScaleChanged: {
                updateRectangleUI()
            }
            onRectChanged:  {
                console.log("onRectChangedonRectChangedonRectChanged-1: rectangle.widthScale: "+rectangle.widthScale)
                console.log("onRectChangedonRectChangedonRectChanged-1: rectangle.heightScale: "+rectangle.heightScale)
                console.log("onRectChangedonRectChangedonRectChanged-1: rect: "+rect)
                filterRect.x = rect.x / rectangle.widthScale / profile.width
                filterRect.y = rect.y / rectangle.heightScale / profile.height
                filterRect.width = rect.width / rectangle.widthScale / profile.width
                filterRect.height = rect.height / rectangle.heightScale / profile.height
                console.log("onRectChangedonRectChangedonRectChanged-1: filterRect: "+filterRect)
                rectCtr.x = filterRect.x
                rectCtr.y = filterRect.y
                rectCtr.width = filterRect.width
                rectCtr.height = filterRect.height
                filter.set(rectProperty, rectCtr)
                console.log("onRectChangedonRectChangedonRectChanged-1: rectCtr: "+rectCtr)
                var position = timeline.getPositionInCurrentClip()
                var bKeyFrame = filter.bKeyFrame(position)
                vuiTimer1.restart()
            }
        
        }
    }


    function isModeChanged(){
        if((fillStat != filter.get(fillProperty))||(distortStat != filter.get(distortProperty))||(fillStat != filter.get(valignProperty))||(halignStat != filter.get(halignProperty))){
            fillStat = filter.get(fillProperty)
            distortStat = filter.get(distortProperty)
            valignStat = filter.get(valignProperty)
            halignStat = filter.get(halignProperty)
            return true
        }else{
            return false
        }
    }
    Connections {
        target: filter
        onChanged: {
            vuiTimer3.restart()
        }
    }
    Timer {
        id : vuiTimer3
        interval: 0
        repeat: false
        onTriggered: 
        {
            // if(isModeChanged()){
            //     onModeChanged()
            // }else{
                onFilterChanged()
            // }
        }
    }
    function onModeChanged(){
        rectangle.aspectRatio = getAspectRatio()
    }
    function onFilterChanged(){
        var rectTmp = filter.getRect(rectProperty)
        var newRect = rectTmp
        var position = timeline.getPositionInCurrentClip()
        var bKeyFrame = filter.bKeyFrame(position)
        if (bKeyFrame) {
            filter.get(rectProperty)
            rectTmp = filter.getAnimRectValue(position, rectProperty)
            filter.get(rectProperty)
        }
        console.log("onChangedonChangedonChanged-2: newRect: "+newRect)
        
        newRect.x = rectTmp.x * profile.width 
        newRect.y = rectTmp.y * profile.height
        newRect.width = rectTmp.width * profile.width
        newRect.height = rectTmp.height * profile.height
        console.log("RectangleControlRectangleControlRectangleControl-2-1:newRect: "+newRect)
        rectangle.setHandles(newRect)
        
        if (rectangle.aspectRatio !== getAspectRatio()) {
            rectangle.aspectRatio = getAspectRatio()
            rectangle.setHandles(newRect)
             var rect = rectangle.rectangle
             rectCtr.x = rect.x / profile.width / rectangle.widthScale
             rectCtr.y = rect.y / profile.height / rectangle.heightScale
             rectCtr.width = rect.width / profile.width / rectangle.widthScale
             rectCtr.height = rect.height / profile.height / rectangle.heightScale
            //filter.set(rectProperty, rectCtr)

            var position        = timeline.getPositionInCurrentClip()
            var bKeyFrame       = filter.bKeyFrame(position)
            if (bKeyFrame)
            {
                filter.setKeyFrameParaRectValue(position, rectProperty, rectCtr, 1.0)
                filter.combineAllKeyFramePara();
            } else {
                filter.resetProperty(rectProperty)
                filter.set(rectProperty, rectCtr)
            }
        }
    }

    Connections {
        target: filterDock
        onPositionChanged: {
            console.log("8888888888888888888: metaValue:"+ metaValue)
            if(metaValue != metadata.keyframes.parameters[0].value){
                metaValue = metadata.keyframes.parameters[0].value
                var x = metaValue.substring(1,metaValue.indexOf('Y'))
                var y = metaValue.substring(metaValue.indexOf('Y')+1,metaValue.indexOf('W'))
                var w = metaValue.substring(metaValue.indexOf('W')+1,metaValue.indexOf('H'))
                var h = metaValue.substring(metaValue.indexOf('H')+1)

                rectCtr2.x = parseFloat(x) * profile.width
                rectCtr2.y = parseFloat(y) * profile.height
                rectCtr2.width = parseFloat(w) * profile.width
                rectCtr2.height = parseFloat(h) * profile.height
                rectangle.setHandles(rectCtr2)
                
                console.log("onPositionChangedonPositionChangedonPositionChanged: " + rectCtr2)
                
            }
        }
    }

    Timer {
        id : vuiTimer1
        interval: 100
        repeat: false
        onTriggered: 
        {
            if (filter.getKeyFrameNumber() > 0)
            {
                var position = timeline.getPositionInCurrentClip()
                var rectValue = filter.getRect(rectProperty)
                filter.setKeyFrameParaRectValue(position, rectProperty, rectValue,1.0)
                filter.combineAllKeyFramePara();
            }
            
            
            console.log("onRectChangedonRectChangedonRectChanged-1: rectProperty: "+rectProperty)
            console.log("onRectChangedonRectChangedonRectChanged-1: rectValueTemp: "+rectValue)
        }
    }
    Timer {
        id : vuiTimer2
        interval: 50
        repeat: false
        onTriggered: 
        {
            filter.set(rectProperty, rectCtr)
        }
    }

    
    
}
