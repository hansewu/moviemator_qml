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

    // 滤镜初始化
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
    // 控件发生修改时反应
    function controlValueChanged(id){
        console.log("controlValueChangedcontrolValueChanged:")
        var  userChange = false
        // 可能一个控件对应几个配置项
        var parameterList = findParameter(id)
        for(var paramIndex=0;paramIndex<parameterList.length;paramIndex++){
            var parameter = metadata.keyframes.parameters[parameterList[paramIndex]]
            switch(parameter.controlType)
            {
            case "SliderSpinner":
                
                console.log("id.valueid.valueid.valueid.value: " + id.value)
                console.log("parameter.propertyparameter.property: " + parameter.property)
                console.log("parameter.valueparameter.valueparameter.value: " + parameter.value)
            
                if(filter.bKeyFrame(currentFrame))
                {
                    filter.setKeyFrameParaValue(currentFrame, parameter.property, saveValueCalc(id.value,parameter.factorFunc).toString())
                    filter.combineAllKeyFramePara()
                //如果这次的改变是程序往里面写值，则不做处理，下同
                }else if((Math.abs((id.value - parameter.value) / (id.maximumValue - id.minimumValue)) < 0.01)||(Math.abs(id.value - parameter.value) < 1)){
                    
                }else{
                    filter.set(parameter.property, saveValueCalc(id.value,parameter.factorFunc))
                    userChange = true
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
                    userChange = true
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
                    userChange = false
                }else{
                    filter.set(parameter.property,saveValueCalc(id.red,parameter.factorFunc))
                    filter.set(parameter2.property,saveValueCalc(id.green,parameter2.factorFunc))
                    filter.set(parameter3.property,saveValueCalc(id.blue,parameter3.factorFunc))
                    userChange = true
                }
                paramIndex = paramIndex+2
                break;
            
            default :
                break;
            }
        }
        // 添加关键帧
        if ((filter.getKeyFrameNumber() > 0)&&userChange)
        {
            bKeyFrame = true
            synchroData()
            addKeyFrameValue()
        }
    }
    // 添加为关键帧
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

        //重复点击不生效
        var bKeyFrame = filter.bKeyFrame(position)
        if (bKeyFrame)
            return

        //插入关键帧
        var paramCount = metadata.keyframes.parameterCount
        for(var i = 0; i < paramCount; i++)
        {
            var key = metadata.keyframes.parameters[i].property
            var paraType = metadata.keyframes.parameters[i].paraType
            var value ;
            switch(paraType){
            case 'int':
                value = filter.getAnimIntValue(position,key)
                console.log("key: "+key)
                console.log("value: "+value)
                console.log("values: "+value.toString())
                filter.setKeyFrameParaValue(position, key, value.toString());
                break;
            case 'double':
                value = filter.getAnimDoubleValue(position,key)
                console.log("key: "+key)
                console.log("value: "+value)
                console.log("values: "+value.toString())
                filter.setKeyFrameParaValue(position, key, value.toString());
                break;
            case 'string':
                value = filter.getAnimStringValue(position,key)
                console.log("key: "+key)
                console.log("value: "+value)
                console.log("values: "+value.toString())
                filter.setKeyFrameParaValue(position, key, value.toString());
                break;
            case 'rect':
                value = filter.getAnimRectValue(position,key)
                console.log("key: "+key)
                console.log("value: "+value)
                console.log("values: "+value.toString())
                filter.setKeyFrameParaRectValue(position, key, value);
                break;
            }
        }
        filter.combineAllKeyFramePara();
        bKeyFrame = true

        console.log("2222222222222222222222222222222222222222: ")
        

    }
    //帧位置改变时加载控件参数
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
                loadControlSlider(control, paramIndex)
                break;

            case "CheckBox":
                loadControlCheckbox(control,paramIndex)
                break;

            case "ColorWheelItem":
                var parameter2 = metaParamList[paramIndex+1]
                var parameter3 = metaParamList[paramIndex+2]
                loadControlColorWheel(control,paramIndex,paramIndex+1,paramIndex+2)
                // paramIndex = paramIndex+2
                break;
            
            default :
                control.value = filter.getKeyFrameParaDoubleValue(currentFrame, parameter.property)
                break;
            }
            // 一个控件对应几个参数的，取一次就可以反算出来了
            var paramList = findParameter(control)
            paramIndex = paramIndex + paramList.length -1
        }
    }
    // 数据写入，将控件的数值set到filter里面
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
    //加减乘除 分别用 + - x c 被除b，对数log，指数pow
    // 控件到程序的写入保存计算
    function saveValueCalc(value,factorFunc){
        
        console.log("saveValueCalcsaveValueCalc: " + value +" : " + factorFunc)
        
        var rt = value
        for(var i=0;i<factorFunc.length;i++){
            var calc = factorFunc[i]
            var calcSymbol = calc.substring(0,calc.lastIndexOf(":"))
            var calcValue = parseFloat(calc.substring(calc.lastIndexOf(":")+1,calc.length))
            console.log(rt + ":saveValueCalcsaveValueCalc-1: " + calcSymbol +" : " + calcValue)
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

            case 'log':
            //非线性插值，有可能超出规定范围
                rt = Math.log(Math.abs(rt)) / Math.log(Math.abs(calcValue))
                break;

            case 'pow':
                rt = Math.pow(calcValue, rt);
                break;
            }
        }
        console.log("saveValueCalcsaveValueCalc2: " + rt)
        return rt;
    }
    // 程序到控件参数的加载计算，刚好与写入保存相反
    function loadValueCalc(value,factorFunc){
        console.log("loadValueCalcloadValueCalc: " + value +" : " + factorFunc)
        var rt = value
        for(var i=factorFunc.length-1;i>=0;i--){
            var calc = factorFunc[i]
            var calcSymbol = calc.substring(0,calc.lastIndexOf(":"))
            var calcValue = parseFloat(calc.substring(calc.lastIndexOf(":")+1,calc.length))
            console.log(rt + ":loadValueCalcloadValueCalc-1: " + calcSymbol +" : " + calcValue)
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

            case 'log':
                rt = Math.pow(calcValue, rt);
                break;

            case 'pow':
                rt = Math.log(Math.abs(rt)) / Math.log(Math.abs(calcValue))
                break;
            }
        }
        console.log("loadValueCalcloadValueCalc: " + rt)
        return rt;
    }
    // 根据objectName和root节点查找子节点
    function findControl(objectName,root){
        var controlList = root.children
        for(var i=0;i<controlList.length;i++){
            if(objectName === controlList[i].objectName){
                return controlList[i]
            }
        }
        return null;
    }
    // 根据控件id查找配置项
    function findParameter(id){
        var rt = [];
        for(var i=0;i<metadata.keyframes.parameters.length;i++){
            if(id.objectName === metadata.keyframes.parameters[i].objectName)
            rt.push(i)
        }
        return  rt;
    }
    // 加载单条滑条数据 : 由于是需要对meta里面的value进行直接修改，所以不能传对象，只能传地址
    function loadControlSlider(control,paramIndex){
        var parameter = metadata.keyframes.parameters[paramIndex]
        console.log("loadControlSliderloadControlSliderloadControlSlider: ")
        if(filter.bKeyFrame(currentFrame)){
            var tempValue = filter.getKeyFrameParaDoubleValue(currentFrame, parameter.property);
            if(tempValue != -1.0)
            {
                control.value = loadValueCalc(tempValue,parameter.factorFunc)
                
                console.log("loadControlSliderloadControlSlider-1: " + control.value)
                
            }
        }else{
            filter.get(parameter.property)
            var tempValue = filter.getAnimDoubleValue(currentFrame, parameter.property)
            filter.get(parameter.property)
            console.log("loadControlSliderloadControlSlider-2:tempValue: " + tempValue)
            parameter.value = loadValueCalc(tempValue,parameter.factorFunc)
            console.log("parameter.propertyparameter.property: " + parameter.property)
            console.log("parameter.valueparameter.valueparameter.value: " + parameter.value)
            //非线性插值，有可能超出规定范围
            if(parameter.value > control.maximumValue)
                parameter.value = control.maximumValue
            if(parameter.value < control.minimumValue)
                parameter.value = control.minimumValue
            // 一定要先设配置参数，再设control的value，不然control的value一旦改变，就会触发新的动作，而那里面会用到parameter的value
            var parameterList = findParameter(control)
            for(var i=0;i< parameterList.length;i++){ //所有参数的value都要设，不然后面比较的时候会有问题
                metadata.keyframes.parameters[parameterList[i]].value = parameter.value
            }
            control.value = parameter.value
            console.log("loadControlSliderloadControlSlider-2:parameter.value: " + parameter.value)
            console.log("loadControlSliderloadControlSlider-2:control.value: " + control.value)
        }
    }
    function loadControlCheckbox(control,paramIndex){
        var parameter = metadata.keyframes.parameters[paramIndex]
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
    function loadControlColorWheel(control,paramIndex1,paramIndex2,paramIndex3){
        var parameter1 = metadata.keyframes.parameters[paramIndex1]
        var parameter2 = metadata.keyframes.parameters[paramIndex2]
        var parameter3 = metadata.keyframes.parameters[paramIndex3]
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
        // 一定要先改参数值，再改control值
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
    // 添加关键帧信号
    Connections {
             target: keyFrameControl
             onAddFrameChanged: {
                 bKeyFrame = true
                 synchroData()
                 addKeyFrameValue()
             }
    }
    // 帧位置改变信号
    Connections {
             target: keyFrameControl
             onFrameChanged: {
                 currentFrame = keyFrameNum
                 bKeyFrame = filter.bKeyFrame(currentFrame)
                 loadKeyFrame()
             }
    }
    // 移除关键帧信号
    Connections {
             target: keyFrameControl
             onRemoveKeyFrame: {
                bKeyFrame = false
                var nFrame = keyFrame.getCurrentFrame();
                synchroData()
                filter.removeKeyFrameParaValue(nFrame);
                filter.combineAllKeyFramePara();
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

