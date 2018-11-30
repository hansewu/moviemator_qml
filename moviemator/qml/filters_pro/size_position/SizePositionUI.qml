
import QtQuick 2.0
import QtQuick.Controls 1.1
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

    width: 350
    height: 180

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
            filter.set(fillProperty, 0)
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
        console.log("setFiltersetFiltersetFilter-3: rectTmp"+rectTmp)
        if (filter.getKeyFrameNumber() > 0)
        {
            var nFrame = keyFrame.getCurrentFrame()
            
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
        if((filter.getKeyFrameNumber() > 0)){
            fitRadioButton.checked = false //这样后面6个都enabled == false
            fitRadioButton.enabled = false
            fillRadioButton.enabled = false
            distortRadioButton.enabled = false
        }else{
            fitRadioButton.enabled = true
            fillRadioButton.enabled = true
            distortRadioButton.enabled = true

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
        }
        
    }

    ExclusiveGroup { id: sizeGroup }
    ExclusiveGroup { id: halignGroup }
    ExclusiveGroup { id: valignGroup }

    GridLayout {
        columns: 5
        anchors.fill: parent
        anchors.margins: 8

        KeyFrame{
            id: keyFrame
            Layout.columnSpan:5
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
            onLoadKeyFrame:
            {
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
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        Preset {
            id: preset
            parameters: [fillProperty, distortProperty, rectProperty, halignProperty, valignProperty]
            Layout.columnSpan: 4
            onPresetSelected: setControls()
        }

        Label {
            text: qsTr('Position')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        RowLayout {
            Layout.columnSpan: 4
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
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        RowLayout {
            Layout.columnSpan: 4
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

        Label {
            text: qsTr('Size mode')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        RowLayout {
            Layout.columnSpan: 4
            RadioButton {
                id: fitRadioButton
                text: qsTr('Fit')
                exclusiveGroup: sizeGroup
                onClicked: {
                    filter.set(fillProperty, 0)
                    filter.set(distortProperty, 0)
                }
            }
            RadioButton {
                id: fillRadioButton
                text: qsTr('Fill')
                exclusiveGroup: sizeGroup
                onClicked: {
                    filter.set(fillProperty, 1)
                    filter.set(distortProperty, 0)
                }
            }
            RadioButton {
                id: distortRadioButton
                text: qsTr('Distort')
                exclusiveGroup: sizeGroup
                onClicked: {
                    filter.set(fillProperty, 1)
                    filter.set(distortProperty, 1)
                }
            }
        }

        Label {
            text: qsTr('Horizontal fit')
            Layout.alignment: Qt.AlignRight
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
            Layout.alignment: Qt.AlignRight
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
        Item { Layout.fillWidth: true }

        Item { Layout.fillHeight: true }
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
}
