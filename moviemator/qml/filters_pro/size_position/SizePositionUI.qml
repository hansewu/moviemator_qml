
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
    property rect filterRect: filter.getRect(rectProperty)

    width: 350
    height: 180

    Component.onCompleted: {
        // rectProperty = "transition.rect"
        if (filter.isNew) {
            filter.set(fillProperty, 0)
            filter.set(distortProperty, 0)
            filter.set(rectProperty,   '0/50%:50%x50%')
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'left')
            filter.savePreset(preset.parameters, qsTr('Bottom Left'))

            filter.set(rectProperty,   '50%/50%:50%x50%')
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'right')
            filter.savePreset(preset.parameters, qsTr('Bottom Right'))

            filter.set(rectProperty,   '0/0:50%x50%')
            filter.set(valignProperty, 'top')
            filter.set(halignProperty, 'left')
            filter.savePreset(preset.parameters, qsTr('Top Left'))

            filter.set(rectProperty,   '50%/0:50%x50%')
            filter.set(valignProperty, 'top')
            filter.set(halignProperty, 'right')
            filter.savePreset(preset.parameters, qsTr('Top Right'))

            filter.set(rectProperty,   '0/0:100%x100%')
            filter.set(valignProperty, 'top')
            filter.set(halignProperty, 'left')
            filter.savePreset(preset.parameters)
        }

        var keyFrameCount = filter.getKeyFrameCountOnProject("halign");
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
              var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "halign");
              var keyValue = filter.getStringKeyValueOnProjectOnIndex(index, "halign");
              filter.setKeyFrameParaValue(nFrame, halignProperty, keyValue)


              keyValue = filter.getStringKeyValueOnProjectOnIndex(index, "valign");
              filter.setKeyFrameParaValue(nFrame, valignProperty, keyValue)

            }

            filter.combineAllKeyFramePara();

            var align = filter.getStringKeyValueOnProjectOnIndex(0, "halign")
            if (align === 'left')
                leftRadioButton.checked = true
            else if (align === 'center' || align === 'middle')
                centerRadioButton.checked = true
            else if (filter.get(halignProperty) === 'right')
                rightRadioButton.checked = true
            align = filter.getStringKeyValueOnProjectOnIndex(0, "valign")
            if (align === 'top')
                topRadioButton.checked = true
            else if (align === 'center' || align === 'middle')
                middleRadioButton.checked = true
            else if (align === 'bottom')
                bottomRadioButton.checked = true
        }


        setControls()
    }

    function setControls() {
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

     function setFilter() {
         console.log("5555555555555555555555555555555555-0: ")
        var x = parseFloat(rectX.text)
        var y = parseFloat(rectY.text)
        var w = parseFloat(rectW.text)
        var h = parseFloat(rectH.text)
        
        console.log("x: " + x)
        console.log("y: " + y)
        console.log("w: " + w)
        console.log("h: " + h)
        console.log("filterRect.x: " + filterRect.x)
        console.log("filterRect.y: " + filterRect.y)
        console.log("filterRect.width: " + filterRect.width)
        console.log("filterRect.height: " + filterRect.height)
        
        // if (x !== filterRect.x ||
        //     y !== filterRect.y ||
        //     w !== filterRect.width ||
        //     h !== filterRect.height) {
            filterRect.x = x
            filterRect.y = y
            filterRect.width = w
            filterRect.height = h
            if(keyFrame.bKeyFrame)
            {
                
                var nFrame = keyFrame.getCurrentFrame()
                console.log("5555555555555555555555555555555555-1: "+ nFrame)
                filter.setKeyFrameParaValue(nFrame, rectProperty, '%1%/%2%:%3%x%4%'
                           .arg((x / profile.width * 100).toLocaleString(_locale))
                           .arg((y / profile.height * 100).toLocaleString(_locale))
                           .arg((w / profile.width * 100).toLocaleString(_locale))
                           .arg((h / profile.height * 100).toLocaleString(_locale)))
                filter.setKeyFrameParaValue(nFrame, "transition.rect", '%1%/%2%:%3%x%4%'
                           .arg((x / profile.width * 100).toLocaleString(_locale))
                           .arg((y / profile.height * 100).toLocaleString(_locale))
                           .arg((w / profile.width * 100).toLocaleString(_locale))
                           .arg((h / profile.height * 100).toLocaleString(_locale)))
                filter.setKeyFrameParaValue(nFrame, "test", '%1%/%2%:%3%x%4%'
                           .arg(x)
                           .arg(y)
                           .arg(w)
                           .arg(h))
            }
            else
            {
                console.log("5555555555555555555555555555555555-2: ")

                filter.set(rectProperty, '%1%/%2%:%3%x%4%'
                       .arg((x / profile.width * 100).toLocaleString(_locale))
                       .arg((y / profile.height * 100).toLocaleString(_locale))
                       .arg((w / profile.width * 100).toLocaleString(_locale))
                       .arg((h / profile.height * 100).toLocaleString(_locale)))
                filter.set("transition.rect", '%1%/%2%:%3%x%4%'
                       .arg((x / profile.width * 100).toLocaleString(_locale))
                       .arg((y / profile.height * 100).toLocaleString(_locale))
                       .arg((w / profile.width * 100).toLocaleString(_locale))
                       .arg((h / profile.height * 100).toLocaleString(_locale)))
                filter.set("test", '%1%/%2%:%3%x%4%'
                       .arg(x)
                       .arg(y)
                       .arg(w)
                       .arg(h))
            }
            
        // }
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
            onLoadKeyFrame:
            {
                console.log("onLoadKeyFrameonLoadKeyFrameonLoadKeyFrame: " + keyFrameNum)
                
                var textValue = filter.getKeyFrameParaValue(keyFrameNum, "test");
                console.log("textValue: " + textValue)
                if((textValue != -1)&&(textValue != "")){
                    var x = textValue.substring(0,textValue.lastIndexOf("\/")-1)
                    var y = textValue.substring(textValue.lastIndexOf("\/")+1,textValue.lastIndexOf("\:")-1)
                    var w = textValue.substring(textValue.lastIndexOf("\:")+1,textValue.lastIndexOf("x")-1)
                    var h = textValue.substring(textValue.lastIndexOf("x")+1,textValue.length-1)
                    rectX.text = x
                    rectY.text = y
                    rectW.text = w
                    rectH.text = h
                    
                    
                    console.log("x: " + x)
                    console.log("y: " + y)
                    console.log("w: " + w)
                    console.log("h: " + h)
                }

                textValue = filter.getKeyFrameParaValue(keyFrameNum, halignProperty);
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
                text: filterRect.x
                horizontalAlignment: Qt.AlignRight
                onEditingFinished: setFilter()
                onTextChanged:{
                    textFieldTimer.restart()
                }
            }
            Label { 
                text: ',' 
                color: '#ffffff'
            }
            TextField {
                id: rectY
                text: filterRect.y
                horizontalAlignment: Qt.AlignRight
                onEditingFinished: setFilter()
                onTextChanged:{
                    textFieldTimer.restart()
                }
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
                text: filterRect.width
                horizontalAlignment: Qt.AlignRight
                onEditingFinished: setFilter()
                onTextChanged:{
                    textFieldTimer.restart()
                }
            }
            Label { 
                text: 'x' 
                color: '#ffffff'
            }
            TextField {
                id: rectH
                text: filterRect.height
                horizontalAlignment: Qt.AlignRight
                onEditingFinished: setFilter()
                onTextChanged:{
                    textFieldTimer.restart()
                }
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
            var newValue = filter.getRect(rectProperty)
            if (filterRect !== newValue)
                filterRect = newValue
        }
    }

    Timer {
        id : textFieldTimer
        interval: 1000
        repeat: false
        onTriggered: 
        {
            console.log("5555555555555555555555555555555555555555555: ")
            setFilter()
        }
    }
}
