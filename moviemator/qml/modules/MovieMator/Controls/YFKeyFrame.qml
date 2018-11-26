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
    signal loadKeyFrame()

    function initFilter(layoutRoot){
        //导入上次工程保存的关键帧
        var metaParamList = metadata.keyframes.parameters
        var keyFrameCount = filter.getKeyFrameCountOnProject(metaParamList[0].property);
        for(var keyIndex=0; keyIndex<keyFrameCount;keyIndex++)
        {
            var nFrame = filter.getKeyFrameOnProjectOnIndex(keyIndex, metaParamList[0].property);
            for(var paramIndex=0;paramIndex<metaParamList.length;paramIndex++){
                var prop = metaParamList[paramIndex].property
                var keyValue = filter.getKeyValueOnProjectOnIndex(keyIndex, prop);
                filter.setKeyFrameParaValue(nFrame, prop, keyValue.toString())
            }
        }
        filter.combineAllKeyFramePara();

        //初始化关键帧控件
        if (filter.isNew){
            
            console.log("initFilterinitFilterinitFilterinitFilterinitFilter: ")
            
            for(var paramIndex=0;paramIndex<metaParamList.length;paramIndex++){
                var parameter = metaParamList[paramIndex]
                console.log("parameter.objectName: " + parameter.objectName)
                var control = findControl(parameter.objectName,layoutRoot)
                console.log("control.objectName: " + control.objectName)
                if(control == null)
                    continue;
                switch(parameter.controlType)
                {
                case "SliderSpinner":
                    control.value = parseFloat(parameter.defaultValue)
                    filter.set(parameter.property,saveValueCalc(control.value,parameter.factorFunc))
                    break;

                case "CheckBox":
                    control.checked = Boolean(parameter.defaultValue)
                    filter.set(parameter.property,Number(control.checked))
                    break;

                case "ColorWheelItem":
                    var parameter2 = metaParamList[paramIndex+1]
                    var parameter3 = metaParamList[paramIndex+2]
                    control.color = Qt.rgba(saveValueCalc(parameter.defaultValue,parameter.factorFunc), saveValueCalc(parameter2.defaultValue,parameter2.factorFunc), saveValueCalc(parameter3.defaultValue,parameter3.factorFunc), 1.0 )
                    filter.set(parameter.property,saveValueCalc(parameter.defaultValue,parameter.factorFunc))
                    filter.set(parameter2.property,saveValueCalc(parameter2.defaultValue,parameter2.factorFunc))
                    filter.set(parameter3.property,saveValueCalc(parameter3.defaultValue,parameter3.factorFunc))
                    paramIndex = paramIndex+2
                    
                    console.log("control.colorcontrol.color: " + control.color)
                    console.log("parameter.property: " + parameter.property)
                    console.log("saveValueCalc(parameter.defaultValue,parameter.factorFunc): " + saveValueCalc(parameter.defaultValue,parameter.factorFunc))
                    console.log("parameter2.property: " + parameter2.property)
                    console.log("saveValueCalc(parameter2.defaultValue,parameter2.factorFunc): " + saveValueCalc(parameter2.defaultValue,parameter2.factorFunc))
                    console.log("parameter3.property: " + parameter3.property)
                    console.log("saveValueCalc(parameter3.defaultValue,parameter3.factorFunc): " + saveValueCalc(parameter3.defaultValue,parameter3.factorFunc))

                    
                    break;
                
                default :
                    control.value = parameter.defaultValue
                    filter.set(parameter.property,control.value)
                    break;
                }

            }
        }
    }
    function controlValueChanged(id){
        var parameterList = findParameter(id)
        for(var paramIndex=0;paramIndex<parameterList.length;paramIndex++){
            var parameter = parameterList[paramIndex]
            switch(parameter.controlType)
            {
            case "SliderSpinner":
                if(filter.bKeyFrame(currentFrame))
                {
                    filter.setKeyFrameParaValue(currentFrame, parameter.property, saveValueCalc(id.value,parameter.factorFunc).toString())
                    filter.combineAllKeyFramePara()
                }else if(Math.abs(id.value - parameter.value) < 1){

                }else{
                    filter.set(parameter.property, saveValueCalc(id.value,parameter.factorFunc))
                }
                break;

            case "CheckBox":
                if(filter.bKeyFrame(currentFrame))
                {
                    filter.setKeyFrameParaValue(currentFrame, parameter.property, Number(id.checked).toString())
                    filter.combineAllKeyFramePara()
                }else if(Math.abs(id.checked - parameter.checked) < 1){

                }else{
                    filter.set(parameter.property, Number(id.checked))
                }
                break;

            case "ColorWheelItem":
                console.log("ColorWheelItemColorWheelItemColorWheelItem: id.objectName:" + id.objectName)
                console.log("ColorWheelItemColorWheelItemColorWheelItem: paramIndex:" + paramIndex)
                console.log("id.colorid.colorid.color: " + id.color)
                console.log("parameter.valueparameter.value: " + parameter.value)
                var temp1 = (id.color).toString()
                var value10 = Number('0x' + temp1.substring(1,3))
                var value11 = Number('0x' + temp1.substring(3,5))
                var value12 = Number('0x' + temp1.substring(5,7))
                var temp2 = (parameter.value).toString()
                var value20 = Number('0x' + temp2.substring(1,3))
                var value21 = Number('0x' + temp2.substring(3,5))
                var value22 = Number('0x' + temp2.substring(5,7))
                
                console.log("temp1: " + temp1)
                console.log("value10: " + value10)
                console.log("value11: " + value11)
                console.log("value12: " + value12)
                console.log("temp2: " + temp2)
                console.log("value20: " + value20)
                console.log("value21: " + value21)
                console.log("value22: " + value22)

                
                var parameter2 = parameterList[paramIndex+1]
                var parameter3 = parameterList[paramIndex+2]

                if(filter.bKeyFrame(currentFrame))
                {
                    filter.setKeyFrameParaValue(currentFrame, parameter.property, saveValueCalc(id.red,parameter.factorFunc).toString())
                    filter.setKeyFrameParaValue(currentFrame, parameter2.property, saveValueCalc(id.green,parameter2.factorFunc).toString())
                    filter.setKeyFrameParaValue(currentFrame, parameter3.property, saveValueCalc(id.blue,parameter3.factorFunc).toString())
                    filter.combineAllKeyFramePara()
                }else if((value10 - value20 <= 1)&&(value11 - value21 <= 1)&&(value12 - value22 <= 1)){
                    console.log("9999999999999999999999999999-1: " )
                }else{
                    filter.set(parameter.property,saveValueCalc(id.red,parameter.factorFunc))
                    filter.set(parameter2.property,saveValueCalc(id.green,parameter2.factorFunc))
                    filter.set(parameter3.property,saveValueCalc(id.blue,parameter3.factorFunc))
                    console.log("9999999999999999999999999999-2: " )
                }
                paramIndex = paramIndex+2
                break;
            
            default :
                control.value = parameter.defaultValue
                filter.set(parameter.property,control.value)
                break;
            }
        }
        
    }
    function addKeyFrameValue(){
        
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
                
                filter.setKeyFrameParaValue(position2, key, value.toString());
                filter.setKeyFrameParaValue(0, key, value.toString());
            }
        }

        //删除当前的帧
        var bKeyFrame = filter.bKeyFrame(position)
        if (bKeyFrame)
            return

        //插入关键帧
        var paramCount = metadata.keyframes.parameterCount
        for(var i = 0; i < paramCount; i++)
        {
            var key = metadata.keyframes.parameters[i].property
            var value = filter.get(key)
            
            console.log("key: "+key)
            console.log("value: "+value)
            console.log("values: "+value.toString())
            
            filter.setKeyFrameParaValue(position, key, value.toString());
            
        }
        filter.combineAllKeyFramePara();
        bKeyFrame = true

        console.log("2222222222222222222222222222222222222222: ")
        

    }
    function loadFrameValue(layoutRoot){
        var metaParamList = metadata.keyframes.parameters
        for(var paramIndex=0;paramIndex<metaParamList.length;paramIndex++){
            var parameter = metaParamList[paramIndex]
            var control = findControl(parameter.objectName,layoutRoot)
            if(control == null)
                continue;
            switch(parameter.controlType)
            {
            case "SliderSpinner":
                loadControlSlider(control,parameter)
                break;

            case "CheckBox":
                loadControlCheckbox(control,parameter)
                break;

            case "ColorWheelItem":
                var parameter2 = metaParamList[paramIndex+1]
                var parameter3 = metaParamList[paramIndex+2]
                loadControlColorWheel(control,parameter,parameter2,parameter3)
                // paramIndex = paramIndex+2
                break;
            
            default :
                control.value = filter.getKeyFrameParaDoubleValue(currentFrame, parameter.property)
                break;
            }
            // 一个控件对应几个参数的，取一次就可以了
            var paramList = findParameter(control)
            paramIndex = paramIndex + paramList.length -1
        }
    }
    function setDatas(layoutRoot){
        var metaParamList = metadata.keyframes.parameters
        for(var paramIndex=0;paramIndex<metaParamList.length;paramIndex++){
            var parameter = metaParamList[paramIndex]
            var control = findControl(parameter.objectName,layoutRoot)
            if(control == null)
                continue;
            switch(parameter.controlType)
            {
            case "SliderSpinner":
                filter.set(parameter.property,saveValueCalc(control.value,parameter.factorFunc))
                break;

            case "CheckBox":
                filter.set(parameter.property,Number(control.checked))
                break;

            case "ColorWheelItem":
                var parameter2 = metaParamList[paramIndex+1]
                var parameter3 = metaParamList[paramIndex+2]
                filter.set(parameter.property,saveValueCalc(control.red,parameter.factorFunc))
                filter.set(parameter2.property,saveValueCalc(control.green,parameter2.factorFunc))
                filter.set(parameter3.property,saveValueCalc(control.blue,parameter3.factorFunc))
                paramIndex = paramIndex+2
                break;
            
            default :
                control.value = parameter.defaultValue
                filter.set(parameter.property,control.value)
                break;
            }

        }
    }
    //加减乘除 分别用 + - x c 被除b
    function saveValueCalc(value,factorFunc){
        var rt = value
        for(var i=0;i<factorFunc.length;i++){
            var calc = factorFunc[i]
            var calcSymbol = calc.substring(0,calc.lastIndexOf(":"))
            var calcValue = parseFloat(calc.substring(calc.lastIndexOf(":")+1,calc.length))
            switch(calcSymbol)
            {
            case '+':
                rt = rt + calcValue
                break;

            case '-':
                rt = rt - calcValue
                break;

            case 'x':
                rt = rt * calcValue
                break;

            case 'c':
                rt = rt / calcValue
                break;
            
            case 'b':
                rt = calcValue / rt
                break;
            }
        }
        return rt;
    }
    function loadValueCalc(value,factorFunc){
        var rt = value
        for(var i=factorFunc.length-1;i>=0;i--){
            var calc = factorFunc[i]
            var calcSymbol = calc.substring(0,calc.lastIndexOf(":"))
            var calcValue = parseFloat(calc.substring(calc.lastIndexOf(":")+1,calc.length))
            switch(calcSymbol)
            {
            case '+':
                rt = rt - calcValue
                break;

            case '-':
                rt = rt + calcValue
                break;

            case 'x':
                rt = rt / calcValue
                break;

            case 'c':
                rt = rt * calcValue
                break;

            case 'b':
                rt = calcValue / rt
                break;
            }
        }
        return rt;
    }
    function findControl(objectName,root){
        var controlList = root.children
        for(var i=0;i<controlList.length;i++){
            if(objectName === controlList[i].objectName){
                return controlList[i]
            }
        }
        return null;
    }
    function findParameter(id){
        var rt = [];
        for(var i=0;i<metadata.keyframes.parameters.length;i++){
            if(id.objectName === metadata.keyframes.parameters[i].objectName)
            rt.push(metadata.keyframes.parameters[i])
        }
        return  rt;
    }
    function loadControlSlider(control,parameter){
        if(filter.bKeyFrame(currentFrame)){
            var tempValue = filter.getKeyFrameParaDoubleValue(currentFrame, parameter.property);
            if(tempValue != -1.0)
            {
                control.value = loadValueCalc(tempValue,parameter.factorFunc)
            }
        }else{
            filter.get(parameter.property)
            var tempValue = filter.getAnimDoubleValue(currentFrame, parameter.property)
            filter.get(parameter.property)
            if(tempValue >= 0)
                control.value = parameter.value = loadValueCalc(tempValue,parameter.factorFunc)
        }
    }
    function loadControlCheckbox(control,parameter){
        if(filter.bKeyFrame(currentFrame)){
            var test = filter.get(parameter.property)
            var tempValue = filter.getKeyFrameParaDoubleValue(currentFrame, parameter.property);
            if(tempValue != -1.0)
            {
                control.checked = Boolean(tempValue)
            }
        }
        // else{
        //     filter.get(parameter.property)
        //     var tempValue = filter.getAnimIntValue(currentFrame, parameter.property)
        //     filter.get(parameter.property)
        //     control.checked = parameter.value = Boolean(tempValue)
        // }
    }
    function loadControlColorWheel(control,parameter1,parameter2,parameter3){
        var rValue = filter.getKeyFrameParaDoubleValue(currentFrame, parameter1.property);
        var gValue = filter.getKeyFrameParaDoubleValue(currentFrame, parameter2.property);
        var bValue = filter.getKeyFrameParaDoubleValue(currentFrame, parameter3.property);
        if(rValue == -1.0)
        {
            filter.get(parameter1.property)
            rValue = filter.getAnimDoubleValue(currentFrame, parameter1.property);
            filter.get(parameter1.property)
            filter.get(parameter2.property)
            gValue = filter.getAnimDoubleValue(currentFrame, parameter2.property);
            filter.get(parameter2.property)
            filter.get(parameter3.property)
            bValue = filter.getAnimDoubleValue(currentFrame, parameter3.property);
            filter.get(parameter3.property)
        }
        var tempRed = loadValueCalc(rValue,parameter1.factorFunc)
        var tempGreen = loadValueCalc(gValue,parameter2.factorFunc)
        var tempBlue = loadValueCalc(bValue,parameter3.factorFunc)
        if(!bKeyFrame){
            parameter1.value = parameter2.value = parameter3.value = Qt.rgba( tempRed / 255.0, tempGreen / 255.0, tempBlue / 255.0, 1.0 )
            control.color = parameter1.value
        }
        control.red = tempRed
        control.green = tempGreen
        control.blue = tempBlue
        
        console.log("loadControlColorWheelloadControlColorWheel: control.objectName" + control.objectName)
        console.log("control.color: " + control.color)
        
    }
    function getCurrentFrame(){
        return currentFrame;
    }

    Component.onCompleted:
    {
        currentFrame = timeline.getPositionInCurrentClip()
    }

    Connections {
             target: keyFrameControl
             onAddFrameChanged: {
                 bKeyFrame = true
                 synchroData()
                 addKeyFrameValue()
             }
    }
    Connections {
             target: keyFrameControl
             onFrameChanged: {
                 currentFrame = keyFrameNum
                 bKeyFrame = filter.bKeyFrame(currentFrame)
                 loadKeyFrame()
             }
    }
    Connections {
             target: keyFrameControl
             onRemoveKeyFrame: {
                bKeyFrame = false
                var nFrame = keyFrame.getCurrentFrame();
                synchroData()
                filter.removeKeyFrameParaValue(nFrame);
             }
    }

    //关键帧上线之后这个要去掉，避免和上面 onFrameChanged 重复
    // Connections {
    //     target: filterDock
    //     onPositionChanged: {
    //          var currentFrame = timeline.getPositionInCurrentClip()
    //     }
    // }

}

