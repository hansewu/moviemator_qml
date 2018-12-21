
import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.1
import MovieMator.Controls 1.0

Item {
    property string fillProperty
    property string distortProperty
    property string rectProperty
    property string valignProperty
    property string halignProperty
    property var _locale: Qt.locale(application.numericLocale)
    property rect filterRect : filter.getRect(rectProperty)
    property rect rectTmp
    property var clickedButton
    property bool bTile: false
    property bool bFit: false
    property bool bFitCrop: false

    width: 350
    height: 250

    Component.onCompleted: {
        //导入上次工程保存的关键帧
        var metaParamList = metadata.keyframes.parameters
        var keyFrameCount = filter.getKeyFrameCountOnProject(metaParamList[0].property);
        for(var keyIndex=0; keyIndex<keyFrameCount;keyIndex++)
        {
            var nFrame = filter.getKeyFrameOnProjectOnIndex(keyIndex, metaParamList[0].property)
            for(var paramIndex=0;paramIndex<metaParamList.length;paramIndex++){
                var prop = metaParamList[paramIndex].property
                var keyValue = filter.getAnimRectValue(nFrame, prop)
                filter.setKeyFrameParaRectValue(nFrame, prop, keyValue)
            }
        }
        filter.combineAllKeyFramePara();

        if (filter.isNew) {
            filter.set(fillProperty, 1)
            filter.set(distortProperty, 0)

            rectTmp.x = 0.0
            rectTmp.y = 0.0
            rectTmp.width = 1.0
            rectTmp.height = 1.0
            
            console.log("Component.onCompletedComponent.onCompleted-1: rectTmp" + rectTmp)
            
            filter.set(rectProperty, rectTmp)
            filter.set(valignProperty, 'top')
            filter.set(halignProperty, 'left')
            filter.savePreset(preset.parameters)
        }
        setControls()

        // metadata.keyframes.parameters[0].value = rectTmp
    }

    function setFilter() {
        console.log("setFiltersetFiltersetFilter-1: ")
        
        var x = parseFloat(rectX.text)
        var y = parseFloat(rectY.text)
        var w = parseFloat(rectW.text)
        var h = parseFloat(rectH.text)
        filterRect.x = x / profile.width
        filterRect.y = y / profile.height
        filterRect.width = w / profile.width
        filterRect.height = h / profile.height
        rectTmp.x = x / profile.width
        rectTmp.y = y / profile.height
        rectTmp.width = w / profile.width
        rectTmp.height = h / profile.height
        filter.set(rectProperty, rectTmp)
        console.log("setFiltersetFiltersetFilter-3: rectProperty："+rectProperty)
        if (filter.getKeyFrameNumber() > 0)
        {
            var nFrame = keyFrame.getCurrentFrame()
            
            if (!filter.bKeyFrame(nFrame)) keyFrame.showAddFrameInfo(nFrame)

            var rectValue = filter.getRect(rectProperty)
            filter.setKeyFrameParaRectValue(nFrame, rectProperty, rectValue,1.0)
            filter.combineAllKeyFramePara();
            console.log("setFiltersetFiltersetFilter-2: "+rectValue)
        }
    }

    function saveValues() {
        console.log("saveValuessaveValuessaveValues-0: ")
        
        var x = parseFloat(rectX.text)
        var y = parseFloat(rectY.text)
        var w = parseFloat(rectW.text)
        var h = parseFloat(rectH.text)
        filterRect.x = x / profile.width
        filterRect.y = y / profile.height
        filterRect.width = w / profile.width
        filterRect.height = h / profile.height

        rectTmp.x = x / profile.width
        rectTmp.y = y / profile.height
        rectTmp.width = w / profile.width
        rectTmp.height = h / profile.height
        filter.set(rectProperty, rectTmp)
        console.log("saveValuessaveValuessaveValues-2: "+rectTmp)
        
    }

    function setControls() {
        // if((filter.getKeyFrameNumber() > 0)){
        //     fitRadioButton.checked = false //这样后面6个都enabled == false
        //     fitRadioButton.enabled = false
        //     fillRadioButton.enabled = false
        //     distortRadioButton.enabled = false
        // }else{
        //     fitRadioButton.enabled = true
        //     fillRadioButton.enabled = true
        //     distortRadioButton.enabled = true

            if (filter.get(distortProperty) === '1')
                distortRadioButton.checked = true
            else if (filter.get(fillProperty) === '1')
                fillRadioButton.checked = true
            else
                fitRadioButton.checked = true
            var align = filter.get(halignProperty)
            if (align === 'left')
                leftRadioButton.checked = true
            else if (align === 'center' || align === 'middle')
                centerRadioButton.checked = true
            else if (filter.get(halignProperty) === 'right')
                rightRadioButton.checked = true
            align = filter.get(valignProperty)
            if (align === 'top')
                topRadioButton.checked = true
            else if (align === 'center' || align === 'middle')
                middleRadioButton.checked = true
            else if (align === 'bottom')
                bottomRadioButton.checked = true
        // }
        
    }

    function changeMode(){
        if(fitRadioButton.checked == true){
            filter.set(fillProperty, 1)
            filter.set(distortProperty, 1)
            
            filter.set(fillProperty, 0)
            filter.set(distortProperty, 0)
        }else if(fillRadioButton.checked == true){
            filter.resetProperty(fillProperty)
            filter.resetProperty(distortProperty)

            filter.set(fillProperty, 1)
            filter.set(distortProperty, 0)
        }else if(distortRadioButton.checked = true){
            filter.resetProperty(fillProperty)
            filter.resetProperty(distortProperty)

            filter.set(fillProperty, 1)
            filter.set(distortProperty, 1)
        }
    }

    function setPerset(){
        var position = timeline.getPositionInCurrentClip()
        filter.get(rectProperty)
        var rect = filter.getAnimRectValue(position, rectProperty)
        var rect3 = filter.get(rectProperty)
        console.log("getAnimRectValuegetAnimRectValuegetAnimRectValue2: rect: " + rect)
        console.log("getAnimRectValuegetAnimRectValuegetAnimRectValue3: rect3: " + rect3)

        filterRect.x = rect.x
        filterRect.y = rect.y
        filterRect.width = rect.width
        filterRect.height = rect.height

        setFilter()
        setControls()
    }

    function tile()
    {
        bTile = false

        filter.resetProperty(fillProperty)
        filter.resetProperty(distortProperty)

        filter.set(fillProperty, 1)
        filter.set(distortProperty, 1)

        filterRect.x = 0
        filterRect.y = 0
        filterRect.width = 1
        filterRect.height = 1

        setFilter()
        setControls()
    }

    function fit()
    {
        bFit = false

        filter.resetProperty(fillProperty)
        filter.resetProperty(distortProperty)

        filter.set(fillProperty, 1)
        filter.set(distortProperty, 0)

        if(filter.producerAspect > profile.width/profile.height) 
        {
            filterRect.height   = 1.0/filter.producerAspect * profile.width/profile.height
            filterRect.width    = 1
        }
        else
        {
            filterRect.width    = filter.producerAspect * profile.height/profile.width
            filterRect.height   = 1
        }
        filterRect.x        = (1.0 - filterRect.width)/2.0
        filterRect.y        = (1.0 - filterRect.height)/2.0


        setFilter()
        setControls()
    }

    function fitCrop()
    {
        bFitCrop = false

        filter.resetProperty(fillProperty)
        filter.resetProperty(distortProperty)

        filter.set(fillProperty, 1)
        filter.set(distortProperty, 0)


        if(filter.producerAspect > profile.width/profile.height) 
        {
            filterRect.height   = 1.0 
            filterRect.width    = 1.0/(1.0/filter.producerAspect * profile.width/profile.height)
        }
        else
        {
            filterRect.width    = 1.0
            filterRect.height   = 1/(filter.producerAspect * profile.height/profile.width)
        }
        filterRect.x        = (1.0 - filterRect.width)/2.0
        filterRect.y        = (1.0 - filterRect.height)/2.0

        setFilter()
        setControls()
    }

    ExclusiveGroup { id: sizeGroup }
    ExclusiveGroup { id: halignGroup }
    ExclusiveGroup { id: valignGroup }

    GridLayout {
        columns: 5
        rowSpacing: 13
        columnSpacing: 5
        anchors.fill: parent
        anchors.margins: 18

        KeyFrame{
            id: keyFrame
            Layout.columnSpan:5
            onSynchroData:{
                if((!keyFrame.bKeyFrame)&&(filter.getKeyFrameNumber() <= 0)){
                    var x = parseFloat(rectX.text) / profile.width
                    var y = parseFloat(rectY.text) / profile.height
                    var w = parseFloat(rectW.text) / profile.width
                    var h = parseFloat(rectH.text) / profile.height

                    rectTmp.x = 0
                    rectTmp.y = 0
                    rectTmp.width = 0
                    rectTmp.height = 0
                    filter.set(rectProperty, rectTmp)
                    rectTmp.x = x
                    rectTmp.y = y
                    rectTmp.width = w
                    rectTmp.height = h
                    filter.set(rectProperty, rectTmp)
                }
            }
            onSetAsKeyFrame:{
                var nFrame = keyFrame.getCurrentFrame()
                console.log("111111111111111111111111111111111111111111111111-0: "+ nFrame)
                console.log("111111111111111111111111111111111111111111111111-0: "+ rectProperty)
                saveValues()
            
                var rectValue = filter.getRect(rectProperty)
                console.log("rectValuerectValuerectValuerectValue: " + rectValue)
                if (filter.getKeyFrameNumber() <= 0)
                {
                    var position2 = filter.producerOut - filter.producerIn + 1 - 5
                    filter.setKeyFrameParaRectValue(position2, rectProperty, rectValue,1.0)
                    filter.setKeyFrameParaRectValue(0, rectProperty, rectValue)
                    filter.combineAllKeyFramePara();
                }
                filter.setKeyFrameParaRectValue(nFrame, rectProperty, rectValue,1.0)
                filter.combineAllKeyFramePara();
                console.log("111111111111111111111111111111111111111111111111-1: ")
                setControls()
            }
            onLoadKeyFrame:{
                filter.getKeyFrameParaValue(keyFrameNum, rectProperty)
                console.log("22222222222222222222222222222222222222222222222-0: " + keyFrameNum)
                console.log("22222222222222222222222222222222222222222222222-0: " + rectProperty)

                filter.get(rectProperty)
                var rect = filter.getAnimRectValue(keyFrameNum, rectProperty)
                var rect3 = filter.get(rectProperty)
                console.log("getAnimRectValuegetAnimRectValuegetAnimRectValue2: rect: " + rect)
                console.log("getAnimRectValuegetAnimRectValuegetAnimRectValue3: rect3: " + rect3)

                filterRect.x = rect.x
                filterRect.y = rect.y
                filterRect.width = rect.width
                filterRect.height = rect.height       
                metadata.keyframes.parameters[0].value = 'X'+ rect.x +'Y'+rect.y+'W'+rect.width+'H'+rect.height 

                var textValue = filter.getKeyFrameParaValue(keyFrameNum, halignProperty);
                if(textValue === "left")
                    leftRadioButton.checked = true;
                else if(textValue === "center")
                    centerRadioButton.checked = true;
                else if(textValue === "right")
                    rightRadioButton.checked = true;

                textValue = filter.getKeyFrameParaValue(keyFrameNum, valignProperty);
                if(textValue === "top")
                    topRadioButton.checked = true;
                else if(textValue === "middle")
                    middleRadioButton.checked = true;
                else if(textValue === "bottom")
                    bottomRadioButton.checked = true;
                
                filter.getAnimRectValue(keyFrameNum, rectProperty)

                console.log("22222222222222222222222222222222222222222222222-1: ")
                setControls()
            }
        }

        Label {
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        Preset {
            id: preset
            parameters: [fillProperty, distortProperty, rectProperty, halignProperty, valignProperty]
            Layout.columnSpan: 4
            onPresetSelected: setPerset()
        }

        SeparatorLine {
            Layout.columnSpan: 5
            Layout.minimumWidth: parent.width
            Layout.maximumWidth: parent.width
        }

        Label {
            text: qsTr('Size mode')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
       
        RadioButton {
            id: fitRadioButton
            text: qsTr('Fit')
            visible:false
            exclusiveGroup: sizeGroup
            onClicked: {
                if(filter.getKeyFrameNumber() > 0){
                    sizeKeyFrameWarning.visible = true
                }
                else{
                    filter.set(fillProperty, 1)
                    filter.set(distortProperty, 1)

                    filter.set(fillProperty, 0)
                    filter.set(distortProperty, 0)
                }
                
            }
        }
        RadioButton {
            id: fillRadioButton
            text: qsTr('Fill')
            exclusiveGroup: sizeGroup
            onClicked: {
                if(filter.getKeyFrameNumber() > 0){
                    sizeKeyFrameWarning.visible = true
                }
                else{
                    filter.set(fillProperty, 1)
                    filter.set(distortProperty, 0)
                }
            }
        }
        RadioButton {
            id: distortRadioButton
            text: qsTr('Distort')
            exclusiveGroup: sizeGroup
            onClicked: {
                if(filter.getKeyFrameNumber() > 0){
                    sizeKeyFrameWarning.visible = true
                }
                else{
                    filter.set(fillProperty, 1)
                    filter.set(distortProperty, 1)
                }
                
            }
        }

        Item { Layout.fillWidth: true }
/*
        Label {
            text: qsTr('Horizontal fit')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        RadioButton {
            id: leftRadioButton
            text: qsTr('Left')
            exclusiveGroup: halignGroup
            enabled: fitRadioButton.checked
            onClicked: filter.set(halignProperty, 'left')
        }
        RadioButton {
            id: centerRadioButton
            text: qsTr('Center')
            exclusiveGroup: halignGroup
            enabled: fitRadioButton.checked
            onClicked: filter.set(halignProperty, 'center')
        }
        RadioButton {
            id: rightRadioButton
            text: qsTr('Right')
            exclusiveGroup: halignGroup
            enabled: fitRadioButton.checked
            onClicked: filter.set(halignProperty, 'right')
        }
        Item { Layout.fillWidth: true }

        Label {
            text: qsTr('Vertical fit')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        RadioButton {
            id: topRadioButton
            text: qsTr('Top')
            exclusiveGroup: valignGroup
            enabled: fitRadioButton.checked
            onClicked: filter.set(valignProperty, 'top')
        }
        RadioButton {
            id: middleRadioButton
            text: qsTr('Middle')
            exclusiveGroup: valignGroup
            enabled: fitRadioButton.checked
            onClicked: filter.set(valignProperty, 'middle')
        }
        RadioButton {
            id: bottomRadioButton
            text: qsTr('Bottom')
            exclusiveGroup: valignGroup
            enabled: fitRadioButton.checked
            onClicked: filter.set(valignProperty, 'bottom')
        }
        //Item { Layout.fillWidth: true }
*/

        Label {
            text: qsTr('Position')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
            visible: false
        }
        RowLayout {
            Layout.columnSpan: 4
            visible: false
            TextField {
                id: rectX
                text: (filterRect.x * profile.width).toFixed()
                horizontalAlignment: Qt.AlignRight
                onEditingFinished: setFilter()
            }
            Label { 
                text: ',' 
                color: '#ffffff'
            }
            TextField {
                id: rectY
                text: (filterRect.y * profile.height).toFixed()
                horizontalAlignment: Qt.AlignRight
                onEditingFinished: setFilter()
            }
        }
        Label {
            text: qsTr('Size')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
            visible: false
        }
        RowLayout {
            visible: false
            Layout.columnSpan: 4
            //minimumHeight:4
            TextField {
                id: rectW
                text: (filterRect.width * profile.width).toFixed()
                horizontalAlignment: Qt.AlignRight
                onEditingFinished: setFilter()
            }
            Label { 
                text: 'x' 
                color: '#ffffff'
            }
            TextField {
                id: rectH
                text: (filterRect.height * profile.height).toFixed()
                horizontalAlignment: Qt.AlignRight
                onEditingFinished: setFilter()
            }
            
        }
        
        //Item { Layout.fillHeight: true }

        SeparatorLine {
            Layout.columnSpan: 5
            Layout.minimumWidth: parent.width
            Layout.maximumWidth: parent.width
        }

        Button {
            id: fitButton
            text: qsTr('Fit')
            tooltip: qsTr('Fit')
            iconSource: "qrc:///icons/light/32x32/bg.png"
            Layout.alignment: Qt.AlignRight
            onClicked: {
                bFit = true

                if(filter.getKeyFrameNumber() > 0)   // 关键帧
                {   
                    if(fillRadioButton.checked)   //填配模式
                    {
                        fit()
                    }
                    else
                        sizeKeyFrameWarning.visible = true
                }
                else          
                {
                    fit()
                }
            }
        }

        Button {
            id: fitCropButton
            text: qsTr('FitCrop')
            tooltip: qsTr('FitCrop')
            iconSource: "qrc:///icons/light/32x32/bg.png"
            Layout.alignment: Qt.AlignRight
            onClicked: {
                bFitCrop = true

                if(filter.getKeyFrameNumber() > 0)   // 关键帧
                {   
                    if(fillRadioButton.checked)   //填配模式
                    {
                        fitCrop()
                    }
                    else
                        sizeKeyFrameWarning.visible = true
                }
                else          
                {
                    fitCrop()
                }
            }
        }

        Button {
            id: tileButton
            text: qsTr('Tile')
            tooltip: qsTr('Tile')
            iconSource: "qrc:///icons/light/32x32/bg.png"
            //width:100
            Layout.alignment: Qt.AlignRight
            onClicked: {
                bTile = true

                if(filter.getKeyFrameNumber() > 0)   // 关键帧
                {   
                    if(distortRadioButton.checked)   //变形模式
                    {
                        tile()
                    }
                    else
                        sizeKeyFrameWarning.visible = true
                }
                else          
                {
                    tile()
                }
            }
        }

        
    }

    Connections {
        target: filter
        onChanged: {
            var keyFrameNum = timeline.getPositionInCurrentClip()
            var newValue = filter.getRect(rectProperty)
            if (filterRect !== newValue)
                filterRect = newValue
        }
    }

    MessageDialog {
        id: sizeKeyFrameWarning
        title: qsTr("May I have your attention please")
        text: qsTr("Change mode will remove all of the key frames, are you sure to do?")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            var keyFrameNum = timeline.getPositionInCurrentClip()
            filter.get(rectProperty)
            var rect = filter.getAnimRectValue(keyFrameNum, rectProperty)
            var rect3 = filter.get(rectProperty)
            keyFrame.removeAllKeyFrame()
            filter.set(rectProperty,rect)
            changeMode()
            
            if (bTile) tile()
            if (bFit) fit()
            if (bFitCrop) fitCrop()
        }
        onNo: {
            if (bTile) bTile = false
            if (bFit) bFit = false
            if (bFitCrop) bFitCrop = false

            setControls()  
        }
        Component.onCompleted: visible = false
    }
}
