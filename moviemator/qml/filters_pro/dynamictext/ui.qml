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
    property rect filterRect
    property var _locale: Qt.locale(application.numericLocale)
    width: 500
    height: 500

    function getHexStrColor(position) {
        var colorRect = filter.getRectOfTextFilter("fgcolour")
        if (position >= 0) {
            colorRect = filter.getAnimRectValue(position, "fgcolour")
        }

        var aStr = parseInt(colorRect.x).toString(16)
        if (parseInt(colorRect.x) < 16) {
            aStr = "0" + aStr
        }

        var rStr = parseInt(colorRect.y).toString(16)
        if (parseInt(colorRect.y) < 16) {
            rStr = "0" + rStr
        }

        var gStr = parseInt(colorRect.width).toString(16)
        if (parseInt(colorRect.width) < 16) {
            gStr = "0" + gStr
        }

        var bStr = parseInt(colorRect.height).toString(16)
        if (parseInt(colorRect.height) < 16) {
            bStr = "0" + bStr
        }

        return "#" + aStr + rStr + gStr + bStr
    }

    function getRectColor(hexStrColor) {
        var aStr = hexStrColor.substring(1, 3)
        var rStr = hexStrColor.substring(3, 5)
        var gStr = hexStrColor.substring(5, 7)
        var bStr = hexStrColor.substring(7)
        if (hexStrColor.length <= 7) {
            aStr = "FF"
            rStr = hexStrColor.substring(1, 3)
            gStr = hexStrColor.substring(3, 5)
            bStr = hexStrColor.substring(5)
        }

        return Qt.rect(parseInt(aStr, 16), parseInt(rStr, 16), parseInt(gStr, 16), parseInt(bStr, 16))
    }

    function getAbsoluteRect(position) {
        var rect = filter.getRectOfTextFilter(rectProperty)
        if (position >= 0) {
            rect = filter.getAnimRectValue(position, rectProperty)
        }
        return Qt.rect(rect.x * profile.width, rect.y * profile.height, rect.width * profile.width, rect.height * profile.height)
    }

    function getRelativeRect(absoluteRect) {
        return Qt.rect(absoluteRect.x / profile.width, absoluteRect.y / profile.height, absoluteRect.width / profile.width, absoluteRect.height / profile.height)
    }

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
            if (application.OS === 'Windows')
                filter.set('family', 'Verdana')
            filter.set("fgcolour", Qt.rect(255.0, 255.0, 255.0, 255.0))
            filter.set('bgcolour', '#00000000')
            filter.set('olcolour', '#ff000000')
            filter.set('weight', 500)

            filter.set(rectProperty, Qt.rect(0.0, 0.5, 0.5, 0.5))
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'left')
            filter.savePreset(preset.parameters, qsTr('Bottom Left'))

            filter.set(rectProperty, Qt.rect(0.5, 0.5, 0.5, 0.5))
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'right')
            filter.savePreset(preset.parameters, qsTr('Bottom Right'))

            filter.set(rectProperty, Qt.rect(0.0, 0.0, 0.5, 0.5))
            filter.set(valignProperty, 'top')
            filter.set(halignProperty, 'left')
            filter.savePreset(preset.parameters, qsTr('Top Left'))

            filter.set(rectProperty, Qt.rect(0.5, 0.0, 0.5, 0.5))
            filter.set(valignProperty, 'top')
            filter.set(halignProperty, 'right')
            filter.savePreset(preset.parameters, qsTr('Top Right'))

            filter.set(rectProperty, Qt.rect(0.0, 0.76, 1.0, 0.14))
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'center')
            filter.savePreset(preset.parameters, qsTr('Lower Third'))

//            filter.set(rectProperty,   '0=-1 0 1 1; :1.0=0 0 1 1')
//            filter.savePreset(preset.parameters, qsTr('Slide In From Left'))

//            filter.set(rectProperty,   '0=1 0 1 1; :1.0=0 0 1 1')
//            filter.savePreset(preset.parameters, qsTr('Slide In From Right'))

//            filter.set(rectProperty,   '0=0 -1 1 1; :1.0=0 0 1 1')
//            filter.savePreset(preset.parameters, qsTr('Slide In From Top'))

//            filter.set(rectProperty,   '0=0 1 1 1; :1.0=0 0 1 1')
//            filter.savePreset(preset.parameters, qsTr('Slide In From Bottom'))

//            filter.set(rectProperty,   ':-1.0=0 0 1 1; -1=-1 0 1 1')
//            filter.savePreset(preset.parameters, qsTr('Slide Out Left'))

//            filter.set(rectProperty,   ':-1.0=0 0 1 1; -1=1 0 1 1')
//            filter.savePreset(preset.parameters, qsTr('Slide Out Right'))

//            filter.set(rectProperty,   ':-1.0=0 0 1 1; -1=0 -1 1 1')
//            filter.savePreset(preset.parameters, qsTr('Slide Out Top'))

//            filter.set(rectProperty,   ':-1.0=0 0 1 1; -1=0 1 1 1')
//            filter.savePreset(preset.parameters, qsTr('Slide Out Bottom'))

//            filter.set(rectProperty,   '0=0 0 1 1; -1=-0.05 -0.05 1.1 1.1')
//            filter.savePreset(preset.parameters, qsTr('Slow Zoom In'))

//            filter.set(rectProperty,   '0=-0.05 -0.05 1.1 1.1; -1=0 0 1 1')
//            filter.savePreset(preset.parameters, qsTr('Slow Zoom Out'))

//            filter.set(rectProperty,   '0=-0.05 -0.05 1.1 1.1; -1=-0.1 -0.05 1.1 1.1')
//            filter.savePreset(preset.parameters, qsTr('Slow Pan Left'))

//            filter.set(rectProperty,   '0=-0.05 -0.05 1.1 1.1; -1=-0 -0.05 1.1 1.1')
//            filter.savePreset(preset.parameters, qsTr('Slow Pan Right'))

//            filter.set(rectProperty,   '0=-0.05 -0.05 1.1 1.1; -1=-0.05 -0.1 1.1 1.1')
//            filter.savePreset(preset.parameters, qsTr('Slow Pan Up'))

//            filter.set(rectProperty,   '0=-0.05 -0.05 1.1 1.1; -1=-0.05 0 1.1 1.1')
//            filter.savePreset(preset.parameters, qsTr('Slow Pan Down'))

//            filter.set(rectProperty,   '0=0 0 1 1; -1=-0.1 -0.1 1.1 1.1')
//            filter.savePreset(preset.parameters, qsTr('Slow Zoom In, Pan Up Left'))

//            filter.set(rectProperty,   '0=0 0 1 1; -1=0 0 1.1 1.1')
//            filter.savePreset(preset.parameters, qsTr('Slow Zoom In, Pan Down Right'))

//            filter.set(rectProperty,   '0=-0.1 0 1.1 1.1; -1=0 0 1 1')
//            filter.savePreset(preset.parameters, qsTr('Slow Zoom Out, Pan Up Right'))

//            filter.set(rectProperty,   '0=0 -0.1 1.1 1.1; -1=0 0 1 1')
//            filter.savePreset(preset.parameters, qsTr('Slow Zoom Out, Pan Down Left'))

            filter.set(rectProperty, Qt.rect(0.0, 0.0, 1.0, 1.0))
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'center')
            filter.savePreset(preset.parameters)
        }

        setControls()
        setKeyframedControls()

        if (filter.isNew) {
            filter.set('size', filterRect.height)
        }
    }

    function setControls() {
        filterRect = getAbsoluteRect(-1)
        textArea.text = filter.get('argument')
        fgColor.value = getHexStrColor(-1)
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
                filter.setKeyFrameParaRectValue(nFrame, rectProperty, getRelativeRect(filterRect), 1.0)
                filter.combineAllKeyFramePara();
            }
            else
            {
                var keyFrameCount = filter.getKeyFrameCountOnProject(rectProperty);
                if (keyFrameCount <= 0) {
                    filter.set(rectProperty, getRelativeRect(filterRect))
                    filter.set('size', filterRect.height)
                }
            }
        }
    }

    function setKeyframedControls() {
        var keyFrameCount = filter.getKeyFrameCountOnProject("fgcolour");
        if (keyFrameCount > 0) {
            for (var index = 0; index < keyFrameCount; index++) {
                var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "fgcolour")

                var rectColor = filter.getAnimRectValue(nFrame, "fgcolour")
                filter.setKeyFrameParaRectValue(nFrame, "fgcolour", rectColor, 1.0)

                var rect = filter.getAnimRectValue(nFrame, rectProperty)
                filter.setKeyFrameParaRectValue(nFrame, rectProperty, rect, 1.0)
            }
            filter.combineAllKeyFramePara();

            filterRect = getAbsoluteRect(0)

            fgColor.value = getHexStrColor(0)
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
                //如果没有关键帧，先创建头尾两个关键帧
                if (filter.getKeyFrameNumber() <= 0) {
                    var paramCount = metadata.keyframes.parameterCount
                    for(var i = 0; i < paramCount; i++) {
                        var property = metadata.keyframes.parameters[i].property
                        var paraType = metadata.keyframes.parameters[i].paraType
                        var positionStart = 0
                        var positionEnd = filter.producerOut - filter.producerIn + 1 - 5
                        if (paraType === "rect") {
                            var rectValue = filter.getRectOfTextFilter(property)
                            filter.setKeyFrameParaRectValue(positionStart, property, rectValue, 1.0)
                            filter.setKeyFrameParaRectValue(positionEnd, property, rectValue, 1.0)
                        } else {
                            var valueStr = filter.get(property)
                            filter.setKeyFrameParaValue(positionStart, property, valueStr);
                            filter.setKeyFrameParaValue(positionEnd, property, valueStr);
                        }
                    }
                    filter.combineAllKeyFramePara();
                }

                //插入新的关键帧
                var paramCount = metadata.keyframes.parameterCount
                for(var i = 0; i < paramCount; i++) {
                    var nFrame = keyFrame.getCurrentFrame()
                    var property = metadata.keyframes.parameters[i].property
                    var paraType = metadata.keyframes.parameters[i].paraType
                    if (paraType === "rect") {
                        var rectValue = filter.getAnimRectValue(nFrame, property)
                        filter.setKeyFrameParaRectValue(nFrame, property, rectValue, 1.0)
                    } else {
                        var valueStr = filter.get(property)
                        filter.setKeyFrameParaValue(nFrame, property, valueStr);
                    }
                }
                filter.combineAllKeyFramePara();

                setKeyframedControls()
            }
            onLoadKeyFrame:
            {
                var hexStrColor = getHexStrColor(keyFrameNum)
                if (hexStrColor !== "") {
                    fgColor.value = hexStrColor
                }

                filterRect = getAbsoluteRect(keyFrameNum)
                filter.set('size', filterRect.height)
                filterRect = getAbsoluteRect(keyFrameNum)
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
            onBeforePresetLoaded: {
                filter.removeAllKeyFrame("fgcolour")
                filter.removeAllKeyFrame(rectProperty)
            }
            onPresetSelected: {
                setControls()
                setKeyframedControls()

                if (filter.isNew) {
                    filter.set('size', filterRect.height)
                }
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
                Layout.minimumHeight: preset.height
                Layout.maximumHeight: preset.height
                Layout.minimumWidth: (preset.width - 8) / 2
                Layout.maximumWidth: (preset.width - 8) / 2
                text: qsTr('Timecode')
                onClicked: textArea.insert(textArea.cursorPosition, '#timecode#')
            }
            Button {
                Layout.minimumHeight: preset.height
                Layout.maximumHeight: preset.height
                Layout.minimumWidth: (preset.width - 8) / 2
                Layout.maximumWidth: (preset.width - 8) / 2
                text: qsTr('Frame #', 'Frame number')
                onClicked: textArea.insert(textArea.cursorPosition, '#frame#')
            }
        }
        
        Label {
               text: qsTr('')
               Layout.alignment: Qt.AlignRight
               color: '#ffffff'
            }
        RowLayout{
            Layout.columnSpan: 4
            Button {
                Layout.minimumHeight: preset.height
                Layout.maximumHeight: preset.height
                Layout.minimumWidth: (preset.width - 8) / 2
                Layout.maximumWidth: (preset.width - 8) / 2
                text: qsTr('File date')
                onClicked: textArea.insert(textArea.cursorPosition, '#localfiledate#')
            }
            Button {
                Layout.minimumHeight: preset.height
                Layout.maximumHeight: preset.height
                Layout.minimumWidth: (preset.width - 8) / 2
                Layout.maximumWidth: (preset.width - 8) / 2
                text: qsTr('File name')
                onClicked: textArea.insert(textArea.cursorPosition, '#resource#')
            }
        }

        SeparatorLine {
            Layout.columnSpan: 5
            Layout.minimumWidth: parent.width
            Layout.maximumWidth: parent.width
            width: parent.width
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
                        filter.setKeyFrameParaRectValue(nFrame, "fgcolour", getRectColor(value), 1.0)
                        filter.combineAllKeyFramePara()
                    } else {
                        var keyFrameCount = filter.getKeyFrameCountOnProject("fgcolour");
                        if (keyFrameCount <= 0) {
                            filter.set('fgcolour', getRectColor(value))
                        }
                    }
                }
            }

            Button {
                id: fontButton
                Layout.minimumHeight: preset.height
                Layout.maximumHeight: preset.height
                Layout.minimumWidth: (preset.width - 8) / 2 - 8 - fgColor.width
                Layout.maximumWidth: (preset.width - 8) / 2 - 8 - fgColor.width
                onClicked: {
                    fontDialog.font = Qt.font({ family: filter.get('family'), pointSize: 24, weight: Font.Normal })
                    fontDialog.open()
                }
                FontDialog {
                    id: fontDialog
                    title: "Please choose a font"
                    onFontChanged: {
                         filter.set('family', font.family)
                    }
                    onAccepted: fontButton.text = font.family
                    onRejected: {
                         filter.set('family', fontButton.text)
                    }
                }
            }
            ComboBox {
                id: weightCombo
                Layout.minimumHeight: preset.height
                Layout.maximumHeight: preset.height
                Layout.minimumWidth: (preset.width - 8) / 2
                Layout.maximumWidth: (preset.width - 8) / 2
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
                    filter.set('weight', 10 * values[index])
                }
           }
        }

        Label {
            text: qsTr('Outline')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        ColorPicker {
            id: outlineColor
            eyedropper: false
            alpha: true
            onValueChanged: {
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
            Layout.minimumWidth: 60
            Layout.maximumWidth: 60
            Layout.columnSpan: 2
            minimumValue: 0
            maximumValue: 30
            decimals: 0
            onValueChanged: {
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
            Layout.minimumWidth: 60
            Layout.maximumWidth: 60
            Layout.columnSpan: 2
            minimumValue: 0
            maximumValue: 100
            decimals: 0
            onValueChanged:
            {
                filter.set('pad', value)
            }
        }

        SeparatorLine {
            Layout.columnSpan: 5
            Layout.minimumWidth: parent.width
            Layout.maximumWidth: parent.width
            width: parent.width
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
                text: filterRect.x.toFixed()
                Layout.minimumWidth: (preset.width - 8) / 2 - 10
                Layout.maximumWidth: (preset.width - 8) / 2 - 10
                horizontalAlignment: Qt.AlignRight
                onEditingFinished: setFilter()
            }
            Label {
                text: ','
                color: '#ffffff'
            }
            TextField {
                id: rectY
                text: filterRect.y.toFixed()
                Layout.minimumWidth: (preset.width - 8) / 2 - 10
                Layout.maximumWidth: (preset.width - 8) / 2 - 10
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
                text: filterRect.width.toFixed()
                Layout.minimumWidth: (preset.width - 8) / 2 - 10
                Layout.maximumWidth: (preset.width - 8) / 2 - 10
                horizontalAlignment: Qt.AlignRight
                onEditingFinished: setFilter()
            }
            Label {
                text: 'x'
                color: '#ffffff'
            }
            TextField {
                id: rectH
                text: filterRect.height.toFixed()
                Layout.minimumWidth: (preset.width - 8) / 2 - 10
                Layout.maximumWidth: (preset.width - 8) / 2 - 10
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
                filter.set(halignProperty, 'left')
            }
        }
        RadioButton {
            id: centerRadioButton
            text: qsTr('Center')
            exclusiveGroup: halignGroup
            onClicked: {
                filter.set(halignProperty, 'center')
            }
        }
        RadioButton {
            id: rightRadioButton
            text: qsTr('Right')
            exclusiveGroup: halignGroup
            onClicked:{
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
                filter.set(valignProperty, 'top')
            }
        }
        RadioButton {
            id: middleRadioButton
            text: qsTr('Middle')
            exclusiveGroup: valignGroup
            onClicked:
            {
                filter.set(valignProperty, 'middle')
            }
        }
        RadioButton {
            id: bottomRadioButton
            text: qsTr('Bottom')
            exclusiveGroup: valignGroup
            onClicked:
            {
                filter.set(valignProperty, 'bottom')
            }
        }
        Item { Layout.fillWidth: true }

        Item { Layout.fillHeight: true }
    }

    Connections {
        target: filter
        onChanged: {
            var position        = timeline.getPositionInCurrentClip()
            var bKeyFrame       = filter.bKeyFrame(position)
            if (bKeyFrame) {
                var newRect = getAbsoluteRect(position)
                filterRect = newRect
                filter.setKeyFrameParaRectValue(position, rectProperty, getRelativeRect(filterRect), 1.0)
                filter.combineAllKeyFramePara()
            } else {
                var newRect = getAbsoluteRect(-1)
                if (filterRect !== newRect) {
                    filterRect = newRect
                    filter.set('size', filterRect.height)
                }
            }
        }
    }
}

