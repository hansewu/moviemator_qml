/*
 * Copyright (c) 2014-2015 Meltytech, LLC
 * Author: Dan Dennedy <dan@dennedy.org>
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
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import MovieMator.Controls 1.0
import QtQuick.Dialogs 1.1

Item {
    property string rectProperty: 'geometry'
    property string valignProperty: 'valign'
    property string halignProperty: 'halign'
    property rect filterRect: filter.getRect(rectProperty)
    property var _locale: Qt.locale(application.numericLocale)
    width: 330
    height: 370

    Component.onCompleted: {
        if (filter.isNew) {
            if (application.OS === 'Windows')
                filter.set('family', 'Verdana')
            filter.set('fgcolour', '#ffffffff')
            filter.set('bgcolour', '#00000000')
            filter.set('olcolour', '#ff000000')
            filter.set('weight', 500)

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

            filter.set(rectProperty,   '0/76%:100%x14%')
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'center')
            filter.savePreset(preset.parameters, qsTr('Lower Third'))

            filter.set(rectProperty, '0/0:100%x100%')
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'center')
            filter.set('size', filterRect.height)
            filter.savePreset(preset.parameters)

            //filter.set(rectProperty, filter.getRect(rectProperty))
        }

        var keyFrameCount = filter.getKeyFrameCountOnProject("argument");
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
              var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "argument");
              var keyValue = filter.getStringKeyValueOnProjectOnIndex(index, "argument");
              filter.setKeyFrameParaValue(nFrame, "argument", keyValue)

              keyValue = filter.getStringKeyValueOnProjectOnIndex(index, "fgcolour");
              filter.setKeyFrameParaValue(nFrame, "fgcolour", keyValue)


              keyValue = filter.getStringKeyValueOnProjectOnIndex(index, "family");
              filter.setKeyFrameParaValue(nFrame, "family", keyValue)

              keyValue = filter.getKeyValueOnProjectOnIndex(index, "weight");
              filter.setKeyFrameParaValue(nFrame, "weight", keyValue)

              keyValue = filter.getStringKeyValueOnProjectOnIndex(index, "olcolour");
              filter.setKeyFrameParaValue(nFrame, "olcolour", keyValue)

              keyValue = filter.getKeyValueOnProjectOnIndex(index, "outline");
              filter.setKeyFrameParaValue(nFrame, "outline", keyValue)

              keyValue = filter.getStringKeyValueOnProjectOnIndex(index, "bgcolour");
              filter.setKeyFrameParaValue(nFrame, "bgcolour", keyValue)

              keyValue = filter.getKeyValueOnProjectOnIndex(index, "pad");
              filter.setKeyFrameParaValue(nFrame, "pad", keyValue)

              keyValue = filter.getStringKeyValueOnProjectOnIndex(index, "halign");
              filter.setKeyFrameParaValue(nFrame, halignProperty, keyValue)


              keyValue = filter.getStringKeyValueOnProjectOnIndex(index, "valign");
              filter.setKeyFrameParaValue(nFrame, valignProperty, keyValue)

            }

            filter.combineAllKeyFramePara();

            textArea.text = filter.getStringKeyValueOnProjectOnIndex(0, "argument")
            fgColor.value = filter.getStringKeyValueOnProjectOnIndex(0, "fgcolour")
            fontButton.text = filter.getStringKeyValueOnProjectOnIndex(0, "family")
            weightCombo.currentIndex = weightCombo.valueToIndex()
            outlineColor.value = filter.getStringKeyValueOnProjectOnIndex(0, "olcolour")
            outlineSpinner.value = filter.getKeyValueOnProjectOnIndex(0, "outline")
            bgColor.value = filter.getStringKeyValueOnProjectOnIndex(0, "bgcolour")
            padSpinner.value = parseFloat(filter.getKeyValueOnProjectOnIndex(0, "pad"))
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
        textArea.text = filter.get('argument')
        fgColor.value = filter.get('fgcolour')
        fontButton.text = filter.get('family')
        weightCombo.currentIndex = weightCombo.valueToIndex()
        outlineColor.value = filter.get('olcolour')
        outlineSpinner.value = filter.getDouble('outline')
        bgColor.value = filter.get('bgcolour')
        padSpinner.value = filter.getDouble('pad')
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
        var x = parseFloat(rectX.text)
        var y = parseFloat(rectY.text)
        var w = parseFloat(rectW.text)
        var h = parseFloat(rectH.text)
        if (x !== filterRect.x ||
            y !== filterRect.y ||
            w !== filterRect.width ||
            h !== filterRect.height) {
            filterRect.x = x
            filterRect.y = y
            filterRect.width = w
            filterRect.height = h
            if(keyFrame.bKeyFrame)
            {
                var nFrame = keyFrame.getCurrentFrame()
                filter.setKeyFrameParaValue(nFrame, rectProperty, '%1%/%2%:%3%x%4%'
                           .arg((x / profile.width * 100).toLocaleString(_locale))
                           .arg((y / profile.height * 100).toLocaleString(_locale))
                           .arg((w / profile.width * 100).toLocaleString(_locale))
                           .arg((h / profile.height * 100).toLocaleString(_locale)))
                
                console.log("3333333333333333333333333333333331: ")
                
                console.log("rectProperty: " + filter.getKeyFrameParaValue(nFrame, rectProperty))
                
            }
            else
            {
                filter.set(rectProperty, '%1%/%2%:%3%x%4%'
                       .arg((x / profile.width * 100).toLocaleString(_locale))
                       .arg((y / profile.height * 100).toLocaleString(_locale))
                       .arg((w / profile.width * 100).toLocaleString(_locale))
                       .arg((h / profile.height * 100).toLocaleString(_locale)))
               // filter.set(rectProperty, filter.getRect(rectProperty))
                console.log("3333333333333333333333333333333332: ")
                console.log("rectProperty: " + filter.get(rectProperty))
            }
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
            onLoadKeyFrame:
            {
                
                // console.log("onLoadKeyFrameonLoadKeyFrameonLoadKeyFrame: " + keyFrameNum)
                // console.log("rectProperty: " + rectProperty)
                
                // var textValue = filter.getKeyFrameParaValue(keyFrameNum, rectProperty);
                // var x = textValue.substring(0,textValue.lastIndexOf("\/")-1)
                // var y = textValue.substring(textValue.lastIndexOf("\/")+1,textValue.lastIndexOf("\:")-1)
                // var w = textValue.substring(textValue.lastIndexOf("\:")+1,textValue.lastIndexOf("x")-1)
                // var h = textValue.substring(textValue.lastIndexOf("x")+1,textValue.length)
                // rectX.text = x
                // rectY.text = y
                // rectW.text = w
                // rectH.text = h
                
                // console.log("textValue: " + textValue)
                // console.log("x: " + x)
                // console.log("y: " + y)
                // console.log("w: " + w)
                // console.log("h: " + h)

                textValue = filter.getKeyFrameParaValue(keyFrameNum, "fgcolour");
                if(textValue != "")
                    fgColor.value = textValue;

                textValue = filter.getKeyFrameParaValue(keyFrameNum, "argument");
                if(textValue != "")
                    textArea.text = textValue;

                textValue = filter.getKeyFrameParaValue(keyFrameNum, "family");
                if(textValue != "")
                    fontButton.text = textValue;

                textValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, "weight");
                if(textValue != "")
                    weightCombo.currentIndex = weightCombo.valueToIndex();

                textValue = filter.getKeyFrameParaValue(keyFrameNum, "olcolour");
                if(textValue != "")
                    outlineColor.value = textValue;

                textValue = filter.getKeyFrameParaValue(keyFrameNum, "bgcolour");
                if(textValue != "")
                    bgColor.value = textValue;

                textValue = filter.getKeyFrameParaValue(keyFrameNum, "pad");
                if(textValue != "")
                    padSpinner.value = textValue;

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

            parameters: [rectProperty, halignProperty, valignProperty, 'argument', 'size',
            'fgcolour', 'family', 'weight', 'olcolour', 'outline', 'bgcolour', 'pad']
            Layout.columnSpan: 4
            onPresetSelected: {
                setControls()
               // filter.set(rectProperty, filter.getRect(rectProperty))
            }
        }

        Label {
            text: qsTr('Text')
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            color: '#ffffff'
        }
        TextArea {
            id: textArea
            Layout.columnSpan: 4
            textFormat: TextEdit.PlainText
            wrapMode: TextEdit.NoWrap
            Layout.minimumHeight: 40
            Layout.maximumHeight: 80
            Layout.minimumWidth: preset.width
            Layout.maximumWidth: preset.width
            text: '__empty__' // workaround initialization problem
            property int maxLength: 256
            onTextChanged: {
                if (text === '__empty__') return
                if (length > maxLength) {
                    text = text.substring(0, maxLength)
                    cursorPosition = maxLength
                }

                var nFrame = keyFrame.getCurrentFrame();
                if(keyFrame.bKeyFrame)
                {
                    filter.setKeyFrameParaValue(nFrame, "argument", text)
                    filter.combineAllKeyFramePara();
                }
                else
                    filter.set('argument', text)
            }
        }

        Label {
            text: qsTr('Insert field')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        RowLayout {
            Layout.columnSpan: 4
            Button {
                text: qsTr('Timecode')
                onClicked: textArea.insert(textArea.cursorPosition, '#timecode#')
            }
            Button {
                text: qsTr('Frame #', 'Frame number')
                onClicked: textArea.insert(textArea.cursorPosition, '#frame#')
            }
        }
        
        Label {
               text: qsTr('Insert field')
               Layout.alignment: Qt.AlignRight
               color: '#ffffff'
            }

        RowLayout{
            Layout.columnSpan: 4
            

            Button {
                text: qsTr('File date')
                onClicked: textArea.insert(textArea.cursorPosition, '#localfiledate#')
            }
            Button {
                text: qsTr('File name')
                onClicked: textArea.insert(textArea.cursorPosition, '#resource#')
            }
        }

        Label {
            text: qsTr('Font')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        
        RowLayout {
            Layout.columnSpan: 4

            ColorPicker {
                id: fgColor
                eyedropper: false
                alpha: true
                onValueChanged: 
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    if(keyFrame.bKeyFrame)
                    {
                        filter.setKeyFrameParaValue(nFrame, "fgcolour",value)
                        filter.combineAllKeyFramePara()
                    }
                    else
                        filter.set("fgcolour", value);

                }
            }

            Button {
                id: fontButton
                onClicked: {
                    fontDialog.font = Qt.font({ family: filter.get('family'), pointSize: 24, weight: Font.Normal })
                    fontDialog.open()
                }
                FontDialog {
                    id: fontDialog
                    title: "Please choose a font"
                    onFontChanged: {
                        if(keyFrame.bKeyFrame)
                        {
                            fontButton.fontFamily = font.family
                            filter.setKeyFrameParaValue(nFrame, "family",font.family)
                            filter.combineAllKeyFramePara()
                        }
                        else
                        {
                            filter.set('family', font.family)
                        }
                    }
                    onAccepted: fontButton.text = font.family
                    onRejected: {
                        if(keyFrame.bKeyFrame)
                        {
                            fontButton.fontFamily = fontButton.text
                            filter.setKeyFrameParaValue(nFrame, "family",fontButton.text)
                            filter.combineAllKeyFramePara()
                        }
                        else
                            filter.set('family', fontButton.text)
                    }
                }
            }
            ComboBox {
                id: weightCombo
                model: [qsTr('Normal'), qsTr('Bold'), qsTr('Light', 'thin font stroke')]
                property var values: [Font.Normal, Font.Bold, Font.Light]
                function valueToIndex() {
                    var w = filter.getDouble('weight')
                    for (var i = 0; i < values.length; ++i)
                        if (values[i] === w) break;
                    if (i === values.length) i = 0;
                    return i;
                }
                onActivated: {
                    if(keyFrame.bKeyFrame)
                    {
                        var nFrame = keyFrame.getCurrentFrame();
                        filter.setKeyFrameParaValue(nFrame, "weight", 10 * values[index])
                        filter.combineAllKeyFramePara()
                    }
                    else
                        filter.set('weight', 10 * values[index])
                }
           }
        }
        Label {
            text: qsTr('Outline')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
          //  Layout.column: 0
        }
        ColorPicker {
            id: outlineColor
            eyedropper: false
            alpha: true
            onValueChanged: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "olcolour", value)
                    filter.combineAllKeyFramePara()
                }
                else
                    filter.set('olcolour', value)
            }
        }
        Label {
            text: qsTr('Thickness')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SpinBox {
            id: outlineSpinner
            Layout.minimumWidth: 50
            Layout.columnSpan: 2
            minimumValue: 0
            maximumValue: 30
            decimals: 0
            onValueChanged: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "outline", value)
                    filter.combineAllKeyFramePara()
                }
                else
                    filter.set('outline', value)
            }
        }

        Label {
            text: qsTr('Background')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        ColorPicker {
            id: bgColor
            eyedropper: false
            alpha: true
            onValueChanged:
            {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "bgcolour",value)
                    filter.combineAllKeyFramePara()
                }
                else
                    filter.set('bgcolour', value)
            }
        }
        Label {
            text: qsTr('Padding')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SpinBox {
            id: padSpinner
            Layout.minimumWidth: 50
            Layout.columnSpan: 2
            minimumValue: 0
            maximumValue: 100
            decimals: 0
            onValueChanged:
            {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, "pad", value)
                    filter.combineAllKeyFramePara()
                }
                else
                    filter.set('pad', value)
            }
        }
////////////////////////////////////////////////////////////////
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
            }
        }

        Label {
            text: qsTr('X fit')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        RadioButton {
            id: leftRadioButton
            text: qsTr('Left')
            exclusiveGroup: halignGroup
            onClicked:
            {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, halignProperty, "left")
                    filter.combineAllKeyFramePara()
                }
                else
                    filter.set(halignProperty, 'left')
            }
        }
        RadioButton {
            id: centerRadioButton
            text: qsTr('Center')
            exclusiveGroup: halignGroup
            onClicked: {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, halignProperty, "center")
                }
                else
                     filter.set(halignProperty, 'center')
            }
        }
        RadioButton {
            id: rightRadioButton
            text: qsTr('Right')
            exclusiveGroup: halignGroup
            onClicked:{
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, halignProperty, "right")
                }
                else
                    filter.set(halignProperty, 'right')
            }
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
            onClicked:
            {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, valignProperty, "top")
                }
                else
                    filter.set(valignProperty, 'top')
            }
        }
        RadioButton {
            id: middleRadioButton
            text: qsTr('Middle')
            exclusiveGroup: valignGroup
            onClicked:
            {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, valignProperty, "middle")
                }
                else
                    filter.set(valignProperty, 'middle')
            }
        }
        RadioButton {
            id: bottomRadioButton
            text: qsTr('Bottom')
            exclusiveGroup: valignGroup
            onClicked:
            {
                if(keyFrame.bKeyFrame)
                {
                    var nFrame = keyFrame.getCurrentFrame();
                    filter.setKeyFrameParaValue(nFrame, valignProperty, "bottom")
                }
                else
                    filter.set(valignProperty, 'bottom')
            }
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
}

