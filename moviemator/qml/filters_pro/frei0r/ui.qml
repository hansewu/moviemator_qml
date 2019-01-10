
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import MovieMator.Controls 1.0
import "frei0rInterface.js" as Handdle

Item {
    id:root
    width: 350
    height: 250

    property rect color
    property var levelValue: 100
    property var keyFrame
    function findControl(objectName,root){
        var controlList = root.children
        for(var i=0;i<controlList.length;i++){
            if(objectName == controlList[i].objectName){
                return controlList[i]
            }
        }
        return null;
    }
    function findParameter(id){
        var rt = [];
        for(var i=0;i<metadata.keyframes.parameters.length;i++){
            if(id.objectName == metadata.keyframes.parameters[i].objectName)
            rt.push(i)
        }
        return  rt;
    }
    // 复选框响应函数
    function checkBoxClicked(objectName){
        var ctr = keyFrame.findControl(objectName,layoutRoot)
        var paramIndexList = findParameter(ctr)
        filter.set(Handdle.metaParamList[paramIndexList[0]].property,""+Number(ctr.checked))
    }
    // 滑条响应函数
    function sliderValueChanged(objectName){
        var ctr = keyFrame.findControl(objectName,layoutRoot)

        // var paramIndexList = findParameter(ctr)
        // filter.set(Handdle.metaParamList[paramIndexList[0]].property,""+ctr.value/100)

        keyFrame.controlValueChanged(ctr)
    }
    // 滑条还原函数
    function sliderUndoClicked(objectName){
        var ctr = keyFrame.findControl(objectName,layoutRoot)
        var paramIndexList = findParameter(ctr)
        ctr.value = parseFloat(Handdle.metaParamList[paramIndexList[0]].defaultValue) * 100
    }
    // 颜色响应函数
    function colorPickerChanged(objectName){
        var ctr = findControl(objectName,layoutRoot)
        keyFrame.controlValueChanged(ctr)
    }

    function colorUndoClicked(objectName){
        var ctr = keyFrame.findControl(objectName,layoutRoot)
        var paramIndexList = findParameter(ctr)
        var rgb = Handdle.metaParamList[paramIndexList[0]].defaultValue.split(" ")
        ctr.value = Qt.rgba(parseFloat(rgb[0]),parseFloat(rgb[1]),parseFloat(rgb[2]),1.0)
    }
    // 位置响应函数
    function positionChanged(objectName){
        var ctr = keyFrame.findControl(objectName,layoutRoot)
        var paramIndexList = keyFrame.findParameter(ctr)
        if(paramIndexList.length != 2){
            console.log("findParameter Error: "+paramIndexList.length)
            return;
        }
        filter.set(filter.set(Handdle.metaParamList[paramIndexList[0]].property,(ctr.children)[0].text))
        filter.set(filter.set(Handdle.metaParamList[paramIndexList[1]].property,(ctr.children)[2].text))
    }

    function positionUndoClicked(objectName){
        var ctr = keyFrame.findControl(objectName,layoutRoot)
        (ctr.children)[0].value = String(0)
        (ctr.children)[2].value = String(0)
    }
    // 文本响应函数
    function stringValueChanged(objectName){
        var ctr = findControl(objectName,layoutRoot)
        var paramIndexList = findParameter(ctr)
        if(paramIndexList.length <= 0){
            console.log("findParameter Error: "+paramIndexList.length)
            return;
        }
        if(ctr.editable){
            filter.set(Handdle.metaParamList[paramIndexList[0]].property,ctr.editText)
        }
        else{
            filter.set(Handdle.metaParamList[paramIndexList[0]].property,ctr.currentText)
        }
        
    }

    function strinCtrUndoClicked(objectName){
        var ctr = findControl(objectName,layoutRoot)
        ctr.currentIndex = 0
    }
    // 关键帧操作——同步数据响应
    function keyFrameSynchroData(){
        keyFrame.setDatas(layoutRoot)
    }
    // 关键帧操作——时间线改变之后加载数据
    function keyFrameLoad(){
        keyFrame.loadFrameValue(layoutRoot)
    }

    
    Component.onCompleted: {
        

        // 根据参数计算参数控件容器的高度
        var paramNum = metadata.keyframes.parameters.length
        if(paramNum > 0){
            var h = paramNum * 26 + 50
            root.height = (h > root.height)? h : root.height
        }
        Handdle.init()
        keyFrame = findControl("keyFrame",layoutRoot)

        
    }

    GridLayout{
        id:layoutRoot
        anchors.fill: parent
        columns: 3
        anchors.margins: 8
    }
    Dialog {
        id:myDialog
        visible: false
        title: "Blue sky dialog"

        contentItem: Rectangle {
            color: "lightskyblue"
            implicitWidth: 400
            implicitHeight: 400
            TextField {
                id:infomation
                text: ""
                anchors.fill: parent
            }
        }
        // var paramList = metadata.keyframes.parameters
        // for(var i=0;i<paramList.length;i++){
        //     var param = paramList[i]
            
        //     console.log("33333333333333333: " + param.paraType)
            
        //     if(param.paraType == 'string'){
        //         infomation.text = metadata.name + " : "+'string'
        //         myDialog.visible = true
        //         break;
        //     }
        // }
    }
    
    
}
