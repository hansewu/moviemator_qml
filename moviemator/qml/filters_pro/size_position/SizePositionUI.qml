
import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.1
import MovieMator.Controls 1.0
import QtQuick.Controls.Styles 1.0

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

            loadPresets()

            rectTmp.x = 0.0
            rectTmp.y = 0.0
            rectTmp.width = 1.0
            rectTmp.height = 1.0
            
            filter.set(rectProperty, rectTmp)
            filter.set(valignProperty, 'top')
            filter.set(halignProperty, 'left')
            filter.savePreset(preset.parameters)
        }
        setControls()

        // metadata.keyframes.parameters[0].value = rectTmp

        keyFrame.initFilter()
    }
           
        
    function loadPresets()
    {
        rectTmp.x       = 0.0
        rectTmp.y       = 0.5
        rectTmp.width   = 0.5
        rectTmp.height  = 0.5

        filter.set(rectProperty,   rectTmp)
        filter.savePreset(preset.parameters, qsTr('Bottom Left'))

        rectTmp.x       = 0.5
        rectTmp.y       = 0.5
        rectTmp.width   = 0.5
        rectTmp.height  = 0.5
        filter.set(rectProperty,   rectTmp)
        filter.savePreset(preset.parameters, qsTr('Bottom Right'))

        rectTmp.x       = 0.0
        rectTmp.y       = 0.0
        rectTmp.width   = 0.5
        rectTmp.height  = 0.5
        filter.set(rectProperty,   rectTmp)
        filter.savePreset(preset.parameters, qsTr('Top Left'))

        rectTmp.x       = 0.5
        rectTmp.y       = 0.0
        rectTmp.width   = 0.5
        rectTmp.height  = 0.5
        filter.set(rectProperty,   rectTmp)
        filter.savePreset(preset.parameters, qsTr('Top Right'))
    } 

    function setFilter() {
        var x = parseFloat(rectX.text)
        var y = parseFloat(rectY.text)
        var w = parseFloat(rectW.text)
        var h = parseFloat(rectH.text)

        filterRect.x = x / profile.width
        filterRect.y = y / profile.height
        filterRect.width = w / profile.width
        filterRect.height = h / profile.height

        /*
        rectTmp.x = x / profile.width
        rectTmp.y = y / profile.height
        rectTmp.width = w / profile.width
        rectTmp.height = h / profile.height
        */

        filter.resetProperty(rectProperty)
        filter.set(rectProperty, filterRect)


        if ((keyFrame.bEnableKeyFrame && keyFrame.bAutoSetAsKeyFrame) || filter.bKeyFrame(keyFrame.getCurrentFrame()))
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
        
        var x = parseFloat(rectX.text)
        var y = parseFloat(rectY.text)
        var w = parseFloat(rectW.text)
        var h = parseFloat(rectH.text)
        filterRect.x        = x / profile.width
        filterRect.y        = y / profile.height
        filterRect.width    = w / profile.width
        filterRect.height   = h / profile.height
/*
        rectTmp.x = x / profile.width
        rectTmp.y = y / profile.height
        rectTmp.width = w / profile.width
        rectTmp.height = h / profile.height*/
        filter.set(rectProperty, filterRect)
        console.log("saveValuessaveValuessaveValues-2: "+rectTmp)
        
    }

    function setControls() {
        if (filter.get(distortProperty) === '1')
            distortRadioButton.checked = true
        else if (filter.get(fillProperty) === '1')
            fillRadioButton.checked = true
        else
            fitRadioButton.checked = true
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
        columnSpacing: 20
        anchors.fill: parent
        anchors.margins: 18

        KeyFrame{
            id: keyFrame
            Layout.columnSpan:5
            onSynchroData:{
                if(filter.getKeyFrameNumber() <= 0){
                    filter.resetProperty(rectProperty)

                    var x = parseFloat(rectX.text) / profile.width
                    var y = parseFloat(rectY.text) / profile.height
                    var w = parseFloat(rectW.text) / profile.width
                    var h = parseFloat(rectH.text) / profile.height

                    rectTmp.x = x
                    rectTmp.y = y
                    rectTmp.width = w
                    rectTmp.height = h
                    filter.set(rectProperty, rectTmp)
                }
                else
                {

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
                    var position2 = (timeline.getCurrentClipLength() - 1) //filter.producerOut - filter.producerIn + 1
                    filter.setKeyFrameParaRectValue(position2, rectProperty, rectValue,1.0)
                    filter.setKeyFrameParaRectValue(0, rectProperty, rectValue)
                    filter.combineAllKeyFramePara();
                }
                filter.setKeyFrameParaRectValue(nFrame, rectProperty, rectValue,1.0)
                filter.combineAllKeyFramePara();
                console.log("111111111111111111111111111111111111111111111111-1: ")

                setControls()
            }
            onLoadKeyFrame:
            {   
                var nFrame = keyFrame.getCurrentFrame()
                if (filter.bKeyFrame(nFrame)) filter.combineAllKeyFramePara()

                var rect = filter.getAnimRectValue(keyFrameNum, rectProperty)

                filterRect.x = rect.x
                filterRect.y = rect.y
                filterRect.width = rect.width
                filterRect.height = rect.height   

                metadata.keyframes.parameters[0].value = 'X'+ rect.x +'Y'+rect.y+'W'+rect.width+'H'+rect.height 

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
    

        SeparatorLine {
            Layout.columnSpan: 5
            Layout.minimumWidth: parent.width
            Layout.maximumWidth: parent.width
        }

        Button {
            id: fitButton
            //text: qsTr('Fit')
            tooltip: qsTr('Fit')
            //iconSource: "qrc:///icons/light/32x32/size-fit.png"
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

            implicitWidth: 56
            implicitHeight: 41
            style: ButtonStyle {
                background: Rectangle {
                    color: 'transparent'
                }  
            }
            Image {
                fillMode: Image.PreserveAspectCrop
                anchors.fill: parent
                source: fitButton.pressed? "qrc:///icons/light/32x32/size-fit-a.png" : "qrc:///icons/light/32x32/size-fit.png"
            }
        }

        Button {
            id: fitCropButton
            //text: qsTr('FitCrop')
            tooltip: qsTr('FitCrop')
            //iconSource: "qrc:///icons/light/32x32/size-fit-crop.png"
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
            implicitWidth: 56
            implicitHeight: 41
            style: ButtonStyle {
                background: Rectangle {
                    color: 'transparent'
                }  
            }
            Image {
                fillMode: Image.PreserveAspectCrop
                anchors.fill: parent
                source: fitCropButton.pressed? "qrc:///icons/light/32x32/size-fit-crop-a.png" : "qrc:///icons/light/32x32/size-fit-crop.png"
            }
        }

        Button {
            id: tileButton
            //text: qsTr('Tile')
            tooltip: qsTr('Tile')
            //iconSource: "qrc:///icons/light/32x32/size-tile.png"
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
            implicitWidth: 56
            implicitHeight: 41
            style: ButtonStyle {
                background: Rectangle {
                    color: 'transparent'
                }  
            }
            Image {
                fillMode: Image.PreserveAspectCrop
                anchors.fill: parent
                source: tileButton.pressed? "qrc:///icons/light/32x32/size-tile-a.png" : "qrc:///icons/light/32x32/size-tile.png"
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
