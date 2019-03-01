/*
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author:
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

    property bool bBlockSignal: false

    property rect colorRect

    signal synchroData()
    signal loadKeyFrame()
    function findDefaultIndex(strValue,modelList){
        if(modelList.length <= 0){
            return 0
        }
        for(var i=0;i<modelList.length;i++){

            if(strValue == modelList[i]){
                return i
            }
        }
        return 0
    }
    // 滤镜初始化
    function initFilter(layoutRoot){
        if(metadata.keyframes.parameters.length == 1)
            filter.setInAndOut(0, timeline.getCurrentClipParentLength())

        //导入上次工程保存的关键帧
        //bBlockSignal = true
        var metaParamList = metadata.keyframes.parameters
        if(metaParamList.length <= 0) return
        // 由于string没有关键帧，所以通过string类型的参数获取关键帧个数会出错，因此不能用string类型的参数去获取关键帧个数和关键帧位置
        var keyParam = 0
        for(keyParam=0;keyParam<metaParamList.length;keyParam++){
            if(metaParamList[keyParam].paraType != 'string'){
                break;
            }
        }

        var keyFrameCount = 0
        if(keyParam < metaParamList.length){
            keyFrameCount = filter.getKeyFrameCountOnProject(metaParamList[keyParam].property);
            if(keyFrameCount < 0){
                keyFrameCount = filter.getKeyFrameCountOnProject(metaParamList[keyParam].property);
            }
            
            bBlockSignal = true
            for(var keyIndex=0; keyIndex<keyFrameCount;keyIndex++)
            {
                var nFrame = filter.getKeyFrameOnProjectOnIndex(keyIndex, metaParamList[keyParam].property);
                for(var paramIndex=0;paramIndex<metaParamList.length;paramIndex++){
                    var prop = metaParamList[paramIndex].property
                    var keyValue = '';
                    if(metaParamList[paramIndex].paraType == 'rect'){
                        keyValue = filter.getAnimRectValue(nFrame, prop);
                        filter.setKeyFrameParaRectValue(nFrame, prop, keyValue)
                    }else{
                        keyValue = filter.getKeyValueOnProjectOnIndex(keyIndex, prop);
                        filter.setKeyFrameParaValue(nFrame, prop, keyValue.toString())
                    }
                }
            }
            bBlockSignal = false
            filter.combineAllKeyFramePara();
            if(keyFrameCount > 0){
                loadKeyFrame()
            }
        }

        // 初始化关键帧控件
        if (filter.isNew && keyFrameCount<=0){
            
            
            for(var paramIndex=0;paramIndex<metaParamList.length;paramIndex++){
                var parameter = metaParamList[paramIndex]
                var control = findControl(parameter.objectName,layoutRoot)
                if(control == null)
                    continue;
                switch(parameter.controlType)
                {
                case "SliderSpinner":
                
                    control.value = parseFloat(parameter.defaultValue) * 100
                    // filter.set(parameter.property,saveValueCalc(control.value,parameter.factorFunc))
                    break;

                case "CheckBox":
                    control.checked = Math.round(parseFloat(parameter.defaultValue))
                    // filter.set(parameter.property,Number(control.checked))
                    break;

                case "ColorWheelItem":
                    var parameter2 = metaParamList[paramIndex+1]
                    var parameter3 = metaParamList[paramIndex+2]
                    control.color = Qt.rgba(saveValueCalc(parameter.defaultValue,parameter.factorFunc), saveValueCalc(parameter2.defaultValue,parameter2.factorFunc), saveValueCalc(parameter3.defaultValue,parameter3.factorFunc), 1.0 )
                    filter.set(parameter.property,saveValueCalc(parameter.defaultValue,parameter.factorFunc))
                    filter.set(parameter2.property,saveValueCalc(parameter2.defaultValue,parameter2.factorFunc))
                    filter.set(parameter3.property,saveValueCalc(parameter3.defaultValue,parameter3.factorFunc))
                    paramIndex = paramIndex+2
                
                    break;
                
                case "ColorPicker":
                    var rgb = parameter.defaultValue.split(" ")
                    control.value = Qt.rgba(parseFloat(rgb[0]),parseFloat(rgb[1]),parseFloat(rgb[2]),1.0)
                    // filter.set(parameter.property,control.value)
                    break;

                case "Slider":
                    control.value = parseFloat(parameter.defaultValue)
                    break;

                case "StringCtr":
                    var index0 = findDefaultIndex(parameter.defaultValue,control.model)
                    control.currentIndex = index0
                
                default :
                    break;
                }

            }
        }

        loadKeyFrame()
    }

    // 控件发生修改时反应
    function controlValueChanged(id){
        console.log("controlValueChangedcontrolValueChanged:")
        var userChange = false
        var valueChange = false

        bBlockSignal = true
        // 可能一个控件对应几个配置项
        var parameterList = findParameter(id)
        for(var paramIndex=0;paramIndex<parameterList.length;paramIndex++){
            var parameter = metadata.keyframes.parameters[parameterList[paramIndex]]
            switch(parameter.controlType)
            {
            case "SliderSpinner":
            
                if(filter.bKeyFrame(currentFrame))
                {
                    filter.setKeyFrameParaValue(currentFrame, parameter.property, saveValueCalc(id.value,parameter.factorFunc).toString())
                    filter.combineAllKeyFramePara()
                //如果这次的改变是程序往里面写值，则不做处理，下同
                }else if((Math.abs((id.value - parameter.value) / (id.maximumValue - id.minimumValue)) < 0.01)||(Math.abs(id.value - parameter.value) < 1)){
                    
                }else if((parameter.value > id.value)&&(id.value == id.maximumValue)){
                    valueChange = true

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
                }else if((id.checked == parameter.value)||(Math.abs(id.checked - parameter.value) < 1)){
                    
                }else{
                    filter.set(parameter.property, Number(id.checked))
                    userChange = true
                }
                break;

            case "ColorWheelItem":
                var temp1 = (id.color).toString()
                var value10 = Number('0x' + temp1.substring(1,3))
                var value11 = Number('0x' + temp1.substring(3,5))
                var value12 = Number('0x' + temp1.substring(5,7))
                var temp2 = (parameter.value).toString()
                var value20 = Number('0x' + temp2.substring(1,3))
                var value21 = Number('0x' + temp2.substring(3,5))
                var value22 = Number('0x' + temp2.substring(5,7))

                
                var parameter2 = metadata.keyframes.parameters[parameterList[paramIndex+1]]
                var parameter3 = metadata.keyframes.parameters[parameterList[paramIndex+2]]

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

            case "ColorPicker":
                var rv = parseInt("0x" + id.value.slice(1, 3))
                var gv = parseInt("0x" + id.value.slice(3, 5))
                var bv = parseInt("0x" + id.value.slice(5, 7))
                colorRect.x = saveValueCalc(rv,parameter.factorFunc)
                colorRect.y = saveValueCalc(gv,parameter.factorFunc)
                colorRect.width = saveValueCalc(bv,parameter.factorFunc)

                var rp = parseInt("0x" + parameter.value.slice(1, 3))
                var gp = parseInt("0x" + parameter.value.slice(3, 5))
                var bp = parseInt("0x" + parameter.value.slice(5, 7))
            
                if(filter.bKeyFrame(currentFrame))
                {
                    filter.setKeyFrameParaRectValue(currentFrame, parameter.property, colorRect)
                    filter.combineAllKeyFramePara()
                //如果这次的改变是程序往里面写值，则不做处理，下同
                }else if((id.value == parameter.value)||(Math.abs(rv+gv+bv - rp - gp - bp) < 8)){

                }else{
                    filter.set(parameter.property, colorRect)
                    userChange = true
                }
                break;

            case "Slider":
                if(filter.bKeyFrame(currentFrame))
                {
                    filter.setKeyFrameParaValue(currentFrame, parameter.property, saveValueCalc(id.value,parameter.factorFunc).toString())
                    filter.combineAllKeyFramePara()
                //如果这次的改变是程序往里面写值，则不做处理，下同
                }else if((id.value == parameter.value)||(Math.abs((id.value - parameter.value) / (id.maximumValue - id.minimumValue)) < 0.01)||(Math.abs(id.value - parameter.value) < 1)){

                }else{
                    filter.set(parameter.property, saveValueCalc(id.value,parameter.factorFunc))
                    userChange = true
                }
                break;

            case "StringCtr":
                if(filter.bKeyFrame(currentFrame))
                {
                    filter.setKeyFrameParaValue(currentFrame, parameter.property, id.currentText)
                    filter.combineAllKeyFramePara()
                //如果这次的改变是程序往里面写值，则不做处理，下同
                }else if(id.currentText == parameter.value){

                }else{
                    filter.set(parameter.property, id.currentText)
                    userChange = true
                }
                break;

            default :
                break;
            }
        }
        bBlockSignal = false
        
        // 添加关键帧
        if ((filter.getKeyFrameNumber() > 0)&&(userChange))
        {
            if (!bAutoSetAsKeyFrame) 
            {
                return
            }

            bKeyFrame = true
            synchroData()
            addKeyFrameValue()
        }
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

    // 添加为关键帧
    function addKeyFrameValue(){
        
        console.log("11111111111111111111111111111111111: ")
        var position = timeline.getPositionInCurrentClip()
        console.log("position: " + position)
        if (position < 0) return

        bBlockSignal = true
        //添加首尾关键帧
        if (filter.getKeyFrameNumber() <= 0)
        {
            var paramCount = metadata.keyframes.parameterCount
            for(var i = 0; i < paramCount; i++)
            {
                var key = metadata.keyframes.parameters[i].property
                var paraType = metadata.keyframes.parameters[i].paraType
                var value = ''
                var position2 = timeline.getCurrentClipLength() - 1//filter.producerOut - filter.producerIn + 1
                if(paraType == 'rect'){
                    value = filter.getAnimRectValue(position,key)
                    filter.setKeyFrameParaRectValue(position2, key, value)
                    filter.setKeyFrameParaRectValue(0, key, value)
                }else{
                    value = filter.get(key)
                    filter.setKeyFrameParaValue(position2, key, value.toString());
                    filter.setKeyFrameParaValue(0, key, value.toString());
                }
            }
        }

        bBlockSignal = false

        //重复点击不生效
        var bKeyFrame = filter.bKeyFrame(position)
        if (bKeyFrame)
            return
        bBlockSignal = true
        //插入关键帧
        var paramCount = metadata.keyframes.parameterCount
        console.log("paramCountparamCountparamCount: " + paramCount)
        for(var i = 0; i < paramCount; i++)
        {
            
            var key = metadata.keyframes.parameters[i].property
            var paraType = metadata.keyframes.parameters[i].paraType
            var value ;
            switch(paraType){
            case 'int':
                value = filter.getAnimIntValue(position,key)
                filter.setKeyFrameParaValue(position, key, value.toString());
                break;
            case 'double':
                value = filter.getAnimDoubleValue(position,key)
                filter.setKeyFrameParaValue(position, key, value.toString());
                break;
            case 'string':
                value = filter.getAnimStringValue(position,key)
                filter.setKeyFrameParaValue(position, key, value.toString());
                break;
            case 'rect':
                value = filter.getAnimRectValue(position,key)
                filter.setKeyFrameParaRectValue(position, key, value);
                break;
            default:
                console.log("addKeyFrameValueERROR: " + position + ' ' + key)
                break;
            }
        }
        
        console.log("1111111111111111-0: ")
        
        filter.combineAllKeyFramePara();
        bKeyFrame = true

        bBlockSignal = false


        for(var i = 0; i < paramCount; i++)
        {
            var key = metadata.keyframes.parameters[i].property
            var t = filter.get(key)
        }

        showAddFrameInfo(position)
    }

    //帧位置改变时加载控件参数
    function loadFrameValue(layoutRoot){
        if(bBlockSignal == true) return
        currentFrame = timeline.getPositionInCurrentClip()
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

            case "ColorPicker":
                loadColorPicker(control, paramIndex)
                break;

            case "Slider":
                loadSlider(control,paramIndex)
            case "StringCtr":
                loadStringCtr(control,paramIndex)

            default :
                break;
            }
            // 一个控件对应几个参数的，取一次就可以反算出来了
            var paramList = findParameter(control)
            paramIndex = paramIndex + paramList.length -1
        }
    }
    // 数据写入，将控件的数值set到filter里面
    function setDatas(layoutRoot){
        clearAllFilterAnimationStatus()
        //resetAnim2No(layoutRoot)

        bBlockSignal = true
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

            case "ColorPicker":
                colorRect.x = saveValueCalc(parseInt("0x" + control.value.slice(1, 3)),parameter.factorFunc)
                colorRect.y = saveValueCalc(parseInt("0x" + control.value.slice(3, 5)),parameter.factorFunc)
                colorRect.width = saveValueCalc(parseInt("0x" + control.value.slice(5, 7)),parameter.factorFunc)
                filter.set(parameter.property,colorRect)
                break;

            case "Slider":
                filter.set(parameter.property,saveValueCalc(control.value,parameter.factorFunc))
                break;

            case "StringCtr":
                filter.set(parameter.property,control.currentText)
                break;

            default :
                control.value = parameter.defaultValue
                filter.set(parameter.property,control.value)
                break;
            }

        }

        bBlockSignal = false
    }

    function clearAllFilterAnimationStatus() {
        if(filter.getKeyFrameNumber() > 0) return 

        var metaParamList = metadata.keyframes.parameters
        for(var i = 0; i < metaParamList.length; i++)
        {
            var parameter = metaParamList[i]
            filter.resetProperty(parameter.property)
        }
    }

    function resetAnim2No(layoutRoot){
        //最后一个关键帧移除之后触发用的
        var metaParamList1 = metadata.keyframes.parameters
        var parameter = metaParamList1[0]
        var control = findControl(parameter.objectName,layoutRoot)
        if(filter.getKeyFrameNumber() <= 0){
            switch(parameter.controlType)
            {
            case "SliderSpinner":
                var tmp = control.value
                control.value = parseFloat(parameter.defaultValue) / 2
                control.value = parseFloat(parameter.defaultValue) * 2
                control.value = tmp
            break;

            case "CheckBox":
                var tmp = control.value
                control.value = Number(parameter.defaultValue) / 2
                control.value = Number(parameter.defaultValue) * 2
                control.value = tmp
                break;

            case "ColorWheelItem":
                var tmp2 = Qt.rgba(control.red / 255, control.green / 255, control.blue / 255, 1.0 )
                control.color = Qt.rgba( 0, 0, 0, 1.0 )
                control.color = Qt.rgba( 0.5, 0.5, 0.5, 1.0 )
                control.color = tmp2
                break;

            case "ColorPicker":
            case "Slider":
            default :
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
        console.log("loadValueCalcloadValueCalc2: " + rt)
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
        for(var i=0;i<controlList.length;i++){
            if(!isEmptyObject(controlList[i].children)){
                var controlList1 = controlList[i].children
                for(var j=0;j<controlList1.length;j++){
                    if(objectName === controlList1[j].objectName){
                        return controlList1[j]
                    }
                }
            }
        }
        return null;
    }
    function isEmptyObject(obj) {
      for (var key in obj) {
        return false;
      }
      return true;
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
        if(filter.bKeyFrame(currentFrame)){
            var tempValue = filter.getKeyFrameParaDoubleValue(currentFrame, parameter.property);
            if(tempValue != -1.0)
            {
                control.value = loadValueCalc(tempValue,parameter.factorFunc)
                
            }
        }else{
            filter.get(parameter.property)
            //filter.combineAllKeyFramePara();
            var tempValue = filter.getAnimDoubleValue(currentFrame, parameter.property)
            filter.get(parameter.property)
            parameter.value = loadValueCalc(tempValue,parameter.factorFunc)
            
            // 一定要先设配置参数，再设control的value，不然control的value一旦改变，就会触发新的动作，而那里面会用到parameter的value
            var parameterList = findParameter(control)
            for(var i=0;i< parameterList.length;i++){ //所有参数的value都要设，不然后面比较的时候会有问题
                metadata.keyframes.parameters[parameterList[i]].value = parameter.value
            }
            //非线性插值，有可能超出规定范围
            var changeValue = false
            if(parameter.value > control.maximumValue){
                control.value = control.maximumValue
                changeValue = true
            }else if(parameter.value < control.minimumValue){
                control.value = control.minimumValue
                changeValue = true
            }else{
                control.value = parameter.value
            }
            if(changeValue){
                for(var i=0;i< parameterList.length;i++){
                    parameter = metadata.keyframes.parameters[parameterList[i]]
                    filter.set(parameter.property,saveValueCalc(control.value,parameter.factorFunc))
                    // filter.setKeyFrameParaValue(currentFrame, parameter.property, saveValueCalc(control.value,parameter.factorFunc).toString());
                }
            }
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
        else{
            filter.get(parameter.property)
            var tempValue = filter.getAnimIntValue(currentFrame, parameter.property)
            filter.get(parameter.property)
            control.checked = parameter.value = Boolean(tempValue)
        }
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
        
        
    }
    function loadColorPicker(control,paramIndex){
        var parameter = metadata.keyframes.parameters[paramIndex]

        filter.get(parameter.property)
        var tempValue = filter.getAnimRectValue(currentFrame, parameter.property)
        filter.get(parameter.property)
        parameter.value = Qt.rgba(parseFloat(tempValue.x),parseFloat(tempValue.y),parseFloat(tempValue.width),1.0)
        // 一定要先设配置参数，再设control的value，不然control的value一旦改变，就会触发新的动作，而那里面会用到parameter的value
        control.value = parameter.value
        
    }
    function loadSlider(control,paramIndex){
        var parameter = metadata.keyframes.parameters[paramIndex]
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
            parameter.value = loadValueCalc(tempValue,parameter.factorFunc)
            // 一定要先设配置参数，再设control的value，不然control的value一旦改变，就会触发新的动作，而那里面会用到parameter的value
            var parameterList = findParameter(control)
            for(var i=0;i< parameterList.length;i++){ //所有参数的value都要设，不然后面比较的时候会有问题
                metadata.keyframes.parameters[parameterList[i]].value = parameter.value
            }
            control.value = parameter.value
        }
    }
    function loadStringCtr(control,paramIndex){
        var parameter = metadata.keyframes.parameters[paramIndex]
        if(filter.bKeyFrame(currentFrame)){
            var tempValue = filter.getKeyFrameParaValue(currentFrame, parameter.property);
            if(tempValue != -1.0)
            {
                var index0 = findDefaultIndex(tempValue,control.model)
                control.currentIndex = index0
            }
        }
    }
    function getCurrentFrame(){
        return currentFrame;
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
                
                filter.removeKeyFrameParaValue(nFrame);
                filter.combineAllKeyFramePara();
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

    //关键帧上线之后这个要去掉，避免和上面 onFrameChanged 重复
    // Connections {
    //     target: filterDock
    //     onPositionChanged: {
    //          var currentFrame = timeline.getPositionInCurrentClip()
    //     }
    // }

}

