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
    property string fgcolourProperty: "fgcolour"
    property string olcolourProperty: "olcolour"
    property string outlineProperty: "outline"
    property string bgcolourProperty: "bgcolour"
    property string padProperty: "pad"
    property string letterSpaceingProperty: "letter_spaceing"
    property rect filterRect
    property var _locale: Qt.locale(application.numericLocale)
    property bool blockUpdate: true
    property bool bEnableKeyFrame: (filter.getKeyFrameNumber() > 0)
    property bool bAutoSetAsKeyFrame: false
    width: 500
    height: 1000

    function getHexStrColor(position, propertyName) {
        var colorRect = filter.getRectOfTextFilter(propertyName)
        if (position >= 0) {
            colorRect = filter.getAnimRectValue(position, propertyName)
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

    function setKeyFrameOfFrame (nFrame) {
        var paramCount = metadata.keyframes.parameterCount
        for(var i = 0; i < paramCount; i++) {
            var property = metadata.keyframes.parameters[i].property
            var paraType = metadata.keyframes.parameters[i].paraType
            if (paraType === "rect") {
                var rectValue = filter.getAnimRectValue(nFrame, property)
                filter.setKeyFrameParaRectValue(nFrame, property, rectValue, 1.0)
            } else {
                var valueStr = filter.getAnimIntValue(nFrame, property)
                filter.setKeyFrameParaValue(nFrame, property, valueStr.toString());
            }
        }
        filter.combineAllKeyFramePara();
    }

    function setKeyFrameParaValue (nFrame, currentPropert, value) {
        var paramCount = metadata.keyframes.parameterCount
        for(var i = 0; i < paramCount; i++) {
            var property = metadata.keyframes.parameters[i].property
            var paraType = metadata.keyframes.parameters[i].paraType
            if (property === currentPropert) {
                if (paraType === "rect") {
                    filter.setKeyFrameParaRectValue(nFrame, property, value, 1.0)
                } else {
                    filter.setKeyFrameParaValue(nFrame, property, value);
                }
            } else {
                if (paraType === "rect") {
                    var rectValue = filter.getAnimRectValue(nFrame, property)
                    filter.setKeyFrameParaRectValue(nFrame, property, rectValue, 1.0)
                } else {
                    var valueStr = filter.getAnimIntValue(nFrame, property)
                    filter.setKeyFrameParaValue(nFrame, property, valueStr);
                }
            }
        }
        filter.combineAllKeyFramePara();
    }

    function setInAndOutKeyFrame () {
        var positionStart = 0
        var positionEnd = filter.producerOut - filter.producerIn + 1 - 5

        var paramCount = metadata.keyframes.parameterCount
        for(var i = 0; i < paramCount; i++) {
            var property = metadata.keyframes.parameters[i].property
            var paraType = metadata.keyframes.parameters[i].paraType
            if (paraType === "rect") {
                var rectValue = filter.getRectOfTextFilter(property)
                filter.setKeyFrameParaRectValue(positionStart, property, rectValue, 1.0)
                filter.setKeyFrameParaRectValue(positionEnd, property, rectValue, 1.0)
            } else {
                var valueStr = filter.getInt(property)
                filter.setKeyFrameParaValue(positionStart, property, valueStr);
                filter.setKeyFrameParaValue(positionEnd, property, valueStr);
            }
        }
        filter.combineAllKeyFramePara();
    }


    function loadSavedKeyFrameNew () {
        var metaParamList = metadata.keyframes.parameters
        var keyFrameCount = filter.getKeyFrameCountOnProject(metaParamList[0].property);
        for(var keyIndex = 0; keyIndex < keyFrameCount;keyIndex++)
        {
            var nFrame = filter.getKeyFrameOnProjectOnIndex(keyIndex, metaParamList[0].property)
            for(var paramIndex = 0; paramIndex < metaParamList.length; paramIndex++){
                var property = metadata.keyframes.parameters[paramIndex].property
                var paraType = metadata.keyframes.parameters[paramIndex].paraType
                if (paraType === "rect") {
                    var rectValue = filter.getAnimRectValue(nFrame, property)
                    filter.setKeyFrameParaRectValue(nFrame, property, rectValue, 1.0)
                } else {
                    var valueStr = filter.getAnimIntValue(nFrame, property)
                    filter.setKeyFrameParaValue(nFrame, property, valueStr);
                }
            }
        }
        filter.combineAllKeyFramePara();
    }

    function loadSavedKeyFrame () {
        var metaParamList = metadata.keyframes.parameters
        var keyFrameCount = filter.getKeyFrameNumber()
        for(var keyIndex = 0; keyIndex < keyFrameCount;keyIndex++)
        {
            for(var paramIndex = 0; paramIndex < metaParamList.length; paramIndex++){
                var nFrame = filter.getKeyFrameOnProjectOnIndex(keyIndex, metaParamList[paramIndex].property)
                var property = metadata.keyframes.parameters[paramIndex].property
                var paraType = metadata.keyframes.parameters[paramIndex].paraType
                if (paraType === "rect") {
                    var rectValue = filter.getKeyFrameParaRectValue(nFrame, property)
                    filter.setKeyFrameParaRectValue(nFrame, property, rectValue, 1.0)
                } else {
                    var valueStr = filter.getKeyFrameParaDoubleValue(nFrame, property);
                    filter.setKeyFrameParaValue(nFrame, property, valueStr);
                }
            }
        }
        filter.combineAllKeyFramePara();
    }

    function removeAllKeyFrame () {
        if (filter.getKeyFrameNumber() > 0) {
            var metaParamList = metadata.keyframes.parameters
            for(var paramIndex = 0; paramIndex < metaParamList.length; paramIndex++){
                var prop = metaParamList[paramIndex].property
                filter.removeAllKeyFrame(prop)
                filter.combineAllKeyFramePara();
                filter.resetProperty(prop)
            }
        }
    }

    function resetFilterPara () {
        filter.set(fgcolourProperty, Qt.rect(255.0, 255.0, 255.0, 255.0))
        filter.set(bgcolourProperty, Qt.rect(0.0, 0.0, 0.0, 0.0))
        filter.set(olcolourProperty, Qt.rect(255.0, 0.0, 0.0, 0.0))
        filter.set(outlineProperty, 0)
        filter.set(letterSpaceingProperty, 0)
        filter.set(padProperty, 0)
        filter.set(rectProperty, Qt.rect(0.0148437, 0.441667, 0.948438, 0.195833))
        filter.set(valignProperty, 'bottom')
        filter.set(halignProperty, 'center')
        filter.set('argument', 'Welcome to MovieMator')
    }

    function updateFilter(currentProperty, value) {
        if (blockUpdate === true) {
            return
        }
        if (bEnableKeyFrame) {
            var nFrame = timeline.getPositionInCurrentClip()
            if (bAutoSetAsKeyFrame) {
                setKeyFrameParaValue(nFrame, currentProperty, value)
            } else {
                if (filter.bKeyFrame(nFrame)) {
                    setKeyFrameParaValue(nFrame, currentProperty, value)
                } else {
                    filter.set(currentProperty, value)
                }
            }
        } else {
            filter.set(currentProperty, value)
        }
    }

    Component.onCompleted: {
        //导入上次工程保存的关键帧
        loadSavedKeyFrameNew()

//        if (filter.isNew) {
//            if (application.OS === 'Windows')
//                filter.set('family', 'Verdana')
//            filter.set(fgcolourProperty, Qt.rect(255.0, 255.0, 255.0, 255.0))
//            filter.set(bgcolourProperty, Qt.rect(0.0, 0.0, 0.0, 0.0))
//            filter.set(olcolourProperty, Qt.rect(255.0, 0.0, 0.0, 0.0))
//            filter.set('weight', 500)
//            filter.set('argument', 'welcome!')

//            //静态预设
//            filter.set(rectProperty, Qt.rect(0.0, 0.5, 0.5, 0.5))
//            filter.set(valignProperty, 'bottom')
//            filter.set(halignProperty, 'left')
//            filter.savePreset(preset.parameters, qsTr('Bottom Left'))

//            filter.set(rectProperty, Qt.rect(0.5, 0.5, 0.5, 0.5))
//            filter.set(valignProperty, 'bottom')
//            filter.set(halignProperty, 'right')
//            filter.savePreset(preset.parameters, qsTr('Bottom Right'))

//            filter.set(rectProperty, Qt.rect(0.0, 0.0, 0.5, 0.5))
//            filter.set(valignProperty, 'top')
//            filter.set(halignProperty, 'left')
//            filter.savePreset(preset.parameters, qsTr('Top Left'))

//            filter.set(rectProperty, Qt.rect(0.5, 0.0, 0.5, 0.5))
//            filter.set(valignProperty, 'top')
//            filter.set(halignProperty, 'right')
//            filter.savePreset(preset.parameters, qsTr('Top Right'))

//            filter.set(rectProperty, Qt.rect(0.0, 0.76, 1.0, 0.14))
//            filter.set(valignProperty, 'bottom')
//            filter.set(halignProperty, 'center')
//            filter.savePreset(preset.parameters, qsTr('Lower Third'))


//            //动画预设
//            var totalFrame = filter.producerOut - filter.producerIn + 1 - 5
//            var oneSeconds2Frame = parseInt(profile.fps)
//            var startFrame = 0.0
//            var middleFrame = oneSeconds2Frame
//            var endFrame = totalFrame
//            var startValue = "-1.0 0.0 1.0 1.0 1.0"
//            var middleValue = "0.0 0.0 1.0 1.0 1.0"
//            var endValue = "0.0 0.0 1.0 1.0 1.0"

//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + middleFrame + "|=" + middleValue  + ";" + endFrame + "|=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slide In From Left'))

//            startValue = "1.0 0.0 1.0 1.0 1.0"
//            middleValue = "0.0 0.0 1.0 1.0 1.0"
//            endValue = "0.0 0.0 1.0 1.0 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + middleFrame + "|=" + middleValue  + ";" + endFrame + "|=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slide In From Right'))

//            startValue = "0.0 -1.0 1.0 1.0 1.0"
//            middleValue = "0.0 0.0 1.0 1.0 1.0"
//            endValue = "0.0 0.0 1.0 1.0 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + middleFrame + "|=" + middleValue  + ";" + endFrame + "|=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slide In From Top'))

//            startValue = "0.0 1.0 1.0 1.0 1.0"
//            middleValue = "0.0 0.0 1.0 1.0 1.0"
//            endValue = "0.0 0.0 1.0 1.0 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + middleFrame + "|=" + middleValue  + ";" + endFrame + "|=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slide In From Bottom'))

//            middleFrame = totalFrame - oneSeconds2Frame
//            if (middleFrame <= 24) {
//                middleFrame = totalFrame / 2
//            }
//            startValue = "0.0 0.0 1.0 1.0 1.0"
//            middleValue = "0.0 0.0 1.0 1.0 1.0"
//            endValue = "-1.0 0.0 1.0 1.0 1.0"
//            filter.set(rectProperty, startFrame + "|=" + startValue + ";" + middleFrame + "~=" + middleValue  + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slide Out Left'))

//            startValue = "0.0 0.0 1.0 1.0 1.0"
//            middleValue = "0.0 0.0 1.0 1.0 1.0"
//            endValue = "1.0 0.0 1.0 1.0 1.0"
//            filter.set(rectProperty, startFrame + "|=" + startValue + ";" + middleFrame + "~=" + middleValue  + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slide Out Right'))

//            startValue = "0.0 0.0 1.0 1.0 1.0"
//            middleValue = "0.0 0.0 1.0 1.0 1.0"
//            endValue = "0.0 -1.0 1.0 1.0 1.0"
//            filter.set(rectProperty, startFrame + "|=" + startValue + ";" + middleFrame + "~=" + middleValue  + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slide Out Top'))

//            startValue = "0.0 0.0 1.0 1.0 1.0"
//            middleValue = "0.0 0.0 1.0 1.0 1.0"
//            endValue = "0.0 1.0 1.0 1.0 1.0"
//            filter.set(rectProperty, startFrame + "|=" + startValue + ";" + middleFrame + "~=" + middleValue  + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slide Out Bottom'))

//            startValue = "0.0 0.0 1.0 1.0 1.0"
//            endValue = "-0.05 -0.05 1.1 1.1 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slow Zoom In'))

//            startValue = "-0.05 -0.05 1.1 1.1 1.0"
//            endValue = "0.0 0.0 1.0 1.0 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slow Zoom Out'))

//            startValue = "-0.05 -0.05 1.1 1.1 1.0"
//            endValue = "-0.1 -0.05 1.1 1.1 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slow Pan Left'))

//            startValue = "-0.05 -0.05 1.1 1.1 1.0"
//            endValue = "0.0 -0.05 1.1 1.1 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slow Pan Right'))

//            startValue = "-0.05 -0.05 1.1 1.1 1.0"
//            endValue = "-0.05 -0.1 1.1 1.1 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slow Pan Up'))

//            startValue = "-0.05 -0.05 1.1 1.1 1.0"
//            endValue = "-0.05 0.0 1.1 1.1 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slow Pan Down'))

//            startValue = "0.0 0.0 1.0 1.0 1.0"
//            endValue = "-0.1 -0.1 1.1 1.1 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slow Zoom In, Pan Up Left'))

//            startValue = "0.0 0.0 1.0 1.0 1.0"
//            endValue = "0.0 0.0 1.1 1.1 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slow Zoom In, Pan Down Right'))

//            startValue = "-0.1 0.0 1.1 1.1 1.0"
//            endValue = "0.0 0.0 1.0 1.0 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slow Zoom Out, Pan Up Right'))

//            startValue = "0.0 -0.1 1.1 1.1 1.0"
//            endValue = "0.0 0.0 1.0 1.0 1.0"
//            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
//            filter.savePreset(preset.parameters, qsTr('Slow Zoom Out, Pan Down Left'))

//            filter.removeAllKeyFrame(rectProperty)

//            filter.set(rectProperty, Qt.rect(0.0, 0.0, 1.0, 1.0))
//            filter.set(valignProperty, 'bottom')
//            filter.set(halignProperty, 'center')
//            filter.savePreset(preset.parameters)
//        }

        if (filter.isNew) {
            if (application.OS === 'Windows')
                filter.set('family', 'Verdana')

            resetFilterPara()
        }

        setControls()
        setKeyframedControls()

        if (filter.isNew) {
            filter.set('size', filterRect.height)
        }
    }

    function setControls() {
        textArea.text = filter.get('argument')
        fontButton.text = filter.get('family')
        weightCombo.currentIndex = weightCombo.valueToIndex()
        insertFieldCombo.currentIndex = insertFieldCombo.valueToIndex()
        blockUpdate = true
        filterRect = getAbsoluteRect(-1)
        fgColor.value = getHexStrColor(-1, fgcolourProperty)
        outlineColor.value = getHexStrColor(-1, olcolourProperty)
        outlineSpinner.value = filter.getDouble(outlineProperty)
        letterSpaceing.value = filter.getDouble(letterSpaceingProperty)
        bgColor.value = getHexStrColor(-1, bgcolourProperty)
        padSpinner.value = filter.getDouble(padProperty)
        blockUpdate = false
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

    function setKeyframedControls() {
        if (filter.getKeyFrameNumber() > 0) {
//            var nFrame = keyFrame.getCurrentFrame()
            var nFrame = timeline.getPositionInCurrentClip()

            blockUpdate = true
            filterRect = getAbsoluteRect(nFrame)
            fgColor.value = getHexStrColor(nFrame, fgcolourProperty)
            outlineColor.value = getHexStrColor(nFrame, olcolourProperty)
            outlineSpinner.value = filter.getAnimDoubleValue(nFrame, outlineProperty)
            letterSpaceing.value = filter.getAnimDoubleValue(nFrame, letterSpaceingProperty)
            bgColor.value = getHexStrColor(nFrame, bgcolourProperty)
            padSpinner.value = filter.getAnimDoubleValue(nFrame, padProperty)
            blockUpdate = false
        }
    }

    function setFilter() {
        if (blockUpdate === true) {
            return
        }
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

            updateFilter(rectProperty, getRelativeRect(filterRect))
//            var nFrame = keyFrame.getCurrentFrame();
//            if (filter.getKeyFrameNumber() > 0) {
//                setKeyFrameParaValue(nFrame, rectProperty, getRelativeRect(filterRect))
//            } else {
//                filter.set(rectProperty, getRelativeRect(filterRect))
//            }
        }

//        if (blockUpdate === true) {
//            return
//        }
//        if (bEnableKeyFrame) {
//            var nFrame = keyFrame.getCurrentFrame()
//            if (bAutoSetAsKeyFrame) {
//                setKeyFrameParaValue(nFrame, currentProperty, value)
//            } else {
//                if (filter.bKeyFrame(nFrame)) {
//                    setKeyFrameParaValue(nFrame, currentProperty, value)
//                } else {
//                    filter.set(currentProperty, value)
//                }
//            }
//        } else {
//            filter.set(currentProperty, value)
//        }
    }

    ExclusiveGroup { id: sizeGroup }
    ExclusiveGroup { id: halignGroup }
    ExclusiveGroup { id: valignGroup }

    GridLayout {
        columns: 5
        anchors.fill: parent
        anchors.margins: 8
        rowSpacing : 25

//        KeyFrame {
//            id: keyFrame
//            Layout.columnSpan:5
//            onSetAsKeyFrame: {
//                console.log("sll---------onSetAsKeyFrame---------")
//                //如果没有关键帧，先创建头尾两个关键帧
//                if (filter.getKeyFrameNumber() <= 0) {
//                    setInAndOutKeyFrame()
//                }

//                //插入新的关键帧
//                var nFrame = keyFrame.getCurrentFrame()
//                setKeyFrameOfFrame(nFrame)

//                //更新关键帧相关控件
//                setKeyframedControls()
//            }
//            onRemovedAllKeyFrame: {
//                var keyFrameCount   = filter.getKeyFrameCountOnProject(rectProperty)
//                if (keyFrameCount > 0) {
//                    filter.removeAllKeyFrame(rectProperty)
//                    keyFrameCount = -1
//                }
//                keyFrameCount   = filter.getKeyFrameCountOnProject(fgcolourProperty)
//                if (keyFrameCount > 0) {
//                    filter.removeAllKeyFrame(fgcolourProperty)
//                    keyFrameCount = -1
//                }
//                filter.resetProperty(fgcolourProperty)
//                filter.resetProperty(rectProperty)

//                //重置带有动画的属性的属性值
//                filter.set(fgcolourProperty, Qt.rect(255.0, 255.0, 255.0, 255.0))
//                filter.set(rectProperty, Qt.rect(0.0, 0.0, 1.0, 1.0))
//            }
//            onLoadKeyFrame: {
////                console.log("sll-------onLoadKeyFrame----")
////                console.log("sll------111111111111111111111111111111111111-------")
////                if (blockUpdate === true) {
////                    return
////                }
////                console.log("sll------222222222222222222222222222222222222-------")
//                if (bEnableKeyFrame) {
//                    console.log("sll------3333333333333333333333333333333333-------")
//                    var nFrame = keyFrame.getCurrentFrame()
//                    if (bAutoSetAsKeyFrame === false) {
//                        if (filter.bKeyFrame(nFrame)) {
//                            console.log("sll------4444444444444444444444444444-------")
//                            loadSavedKeyFrame()
//                        }
////                        else {
////                            filter.set(letterSpaceingProperty, value)
////                        }
////                        setKeyFrameParaValue(nFrame, letterSpaceingProperty, value.toString())
//                    }
////                    else {
////                        if (filter.bKeyFrame(nFrame)) {
////                            console.log("sll------4444444444444444444444444444-------")
////                            loadSavedKeyFrame()
////                        } else {
////                            filter.set(letterSpaceingProperty, value)
////                        }
////                    }
//                }
////                else {
////                    filter.set(letterSpaceingProperty, value)
////                }


//                setKeyframedControls()
//            }
//        }

        Label {
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        Preset {
            id: preset
            Layout.columnSpan: 4
            parameters: [rectProperty, halignProperty, valignProperty, 'argument', 'size',
            fgcolourProperty, 'family', 'weight', olcolourProperty, outlineProperty, bgcolourProperty, padProperty, letterSpaceingProperty]
            onBeforePresetLoaded: {
                removeAllKeyFrame()

                resetFilterPara()
            }
            onPresetSelected: {
                //加載關鍵幀
                loadSavedKeyFrameNew()

                //更新界面
                setControls()
                setKeyframedControls()

                if (filter.isNew) {
                    filter.set('size', filterRect.height)
                }
            }
        }

        Label {
            text: qsTr('Text')
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            color: '#ffffff'
        }
        TextArea {
            id: textArea
            Layout.columnSpan: 4
            textFormat: TextEdit.PlainText
            wrapMode: TextEdit.NoWrap
            Layout.minimumHeight: 40
            Layout.maximumHeight: 100
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
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        ComboBox {
            id: insertFieldCombo
            Layout.columnSpan: 4
            Layout.minimumHeight: 32
            Layout.maximumHeight: 32
            Layout.minimumWidth: preset.width
            Layout.maximumWidth: preset.width
            model: [qsTr('default'), qsTr('Timecode'), qsTr('Frame #', 'Frame number'), qsTr('File date'), qsTr('File name')]
            property var values: ['welcome!', '#timecode#', '#frame#', '#localfiledate#', '#resource#']
            function valueToIndex() {
                var textStr = filter.get('argument')
                for (var i = 0; i < values.length; ++i)
                    if (values[i] === textStr) break;
                if (i === values.length) i = 0;
                return i;
            }
            onActivated: {
                textArea.insert(textArea.cursorPosition, values[index])
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
            Layout.alignment: Qt.AlignLeft
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
                    updateFilter(fgcolourProperty, getRectColor(value))
//                    if (blockUpdate === true) {
//                        return
//                    }
//                    var nFrame = keyFrame.getCurrentFrame();
//                    if (filter.getKeyFrameNumber() > 0) {
//                        setKeyFrameParaValue(nFrame, fgcolourProperty, getRectColor(value))
//                    } else {
//                       filter.set(fgcolourProperty, getRectColor(value))
//                    }
                }
            }

            Button {
                id: fontButton
                Layout.minimumHeight: 32
                Layout.maximumHeight: 32
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
                Layout.minimumHeight: 32
                Layout.maximumHeight: 32
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
            text: qsTr('Letter Spaceing')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SpinBox {
            id: letterSpaceing
            Layout.minimumWidth: preset.width
            Layout.maximumWidth: preset.width
            Layout.columnSpan: 4
            minimumValue: 0
            maximumValue: 500
            decimals: 0
            onValueChanged: {
                updateFilter(letterSpaceingProperty, value.toString())
//                if (blockUpdate === true) {
//                    return
//                }
//                if (bEnableKeyFrame) {
//                    var nFrame = keyFrame.getCurrentFrame()
//                    if (bAutoSetAsKeyFrame) {
//                        setKeyFrameParaValue(nFrame, letterSpaceingProperty, value.toString())
//                    } else {
//                        if (filter.bKeyFrame(nFrame)) {
//                            setKeyFrameParaValue(nFrame, letterSpaceingProperty, value.toString())
//                        } else {
//                            filter.set(letterSpaceingProperty, value)
//                        }
//                    }
//                } else {
//                    filter.set(letterSpaceingProperty, value)
//                }


//                if (blockUpdate === true) {
//                    return
//                }
//                var nFrame = keyFrame.getCurrentFrame();
//                if (filter.getKeyFrameNumber() > 0) {
//                    setKeyFrameParaValue(nFrame, letterSpaceingProperty, value.toString())
//                } else {
//                    filter.set(letterSpaceingProperty, value)
//                }
            }
        }

        Label {
            text: qsTr('Outline')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        ColorPicker {
            id: outlineColor
            eyedropper: false
            alpha: true
//            onTemporaryColorChanged: {
//                filter.set('olcolour', temporaryColor)
//            }
            onValueChanged: {
                updateFilter(olcolourProperty, getRectColor(value))
//                if (blockUpdate === true) {
//                    return
//                }
//                var nFrame = keyFrame.getCurrentFrame();
//                if (filter.getKeyFrameNumber() > 0) {
//                    setKeyFrameParaValue(nFrame, olcolourProperty, getRectColor(value))
//                } else {
//                   filter.set(olcolourProperty, getRectColor(value))
//                }
            }
        }
        Label {
            text: qsTr('Thickness')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SpinBox {
            id: outlineSpinner
            Layout.minimumWidth: 120
            Layout.maximumWidth: 120
            Layout.columnSpan: 2
            minimumValue: 0
            maximumValue: 30
            decimals: 0
            onValueChanged: {
                updateFilter(outlineProperty, value.toString())
//                if (blockUpdate === true) {
//                    return
//                }
//                var nFrame = keyFrame.getCurrentFrame();
//                if (filter.getKeyFrameNumber() > 0) {
//                    setKeyFrameParaValue(nFrame, outlineProperty, value.toString())
//                } else {
//                    filter.set(outlineProperty, value)
//                }
            }
        }

        Label {
            text: qsTr('Background')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        ColorPicker {
            id: bgColor
            eyedropper: false
            alpha: true
//            onTemporaryColorChanged: {
//                filter.set(bgcolourProperty, temporaryColor)
//            }
            onValueChanged: {
                updateFilter(bgcolourProperty, getRectColor(value))
//                if (blockUpdate === true) {
//                    return
//                }
//                var nFrame = keyFrame.getCurrentFrame();
//                if (filter.getKeyFrameNumber() > 0) {
//                    setKeyFrameParaValue(nFrame, bgcolourProperty, getRectColor(value))
//                } else {
//                   filter.set(bgcolourProperty, getRectColor(value))
//                }
            }
        }
        Label {
            text: qsTr('Padding')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SpinBox {
            id: padSpinner
            Layout.minimumWidth: 120
            Layout.maximumWidth: 120
            Layout.columnSpan: 2
            minimumValue: 0
            maximumValue: 100
            decimals: 0
            onValueChanged: {
                updateFilter(padProperty, value.toString())
//                if (blockUpdate === true) {
//                    return
//                }
//                var nFrame = keyFrame.getCurrentFrame();
//                if (filter.getKeyFrameNumber() > 0) {
//                    setKeyFrameParaValue(nFrame, padProperty, value.toString())
//                } else {
//                    filter.set(padProperty, value)
//                }
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
            Layout.alignment: Qt.AlignLeft
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
            Layout.alignment: Qt.AlignLeft
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
            Layout.alignment: Qt.AlignLeft
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
            Layout.leftMargin: 30
            onClicked: {
                filter.set(halignProperty, 'center')
            }
        }
        RadioButton {
            id: rightRadioButton
            text: qsTr('Right')
            exclusiveGroup: halignGroup
            Layout.leftMargin: 60
            onClicked:{
                filter.set(halignProperty, 'right')
            }
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
            onClicked:
            {
                filter.set(valignProperty, 'top')
            }
        }
        RadioButton {
            id: middleRadioButton
            text: qsTr('Middle')
            exclusiveGroup: valignGroup
            Layout.leftMargin: 30
            onClicked:
            {
                filter.set(valignProperty, 'middle')
            }
        }
        RadioButton {
            id: bottomRadioButton
            text: qsTr('Bottom')
            exclusiveGroup: valignGroup
            Layout.leftMargin: 60
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
            var newRect         = getAbsoluteRect(-1)
            var keyFrameCount   = filter.getKeyFrameCountOnProject(rectProperty);
            //判断是否有关键帧
            if(keyFrameCount > 0) {
                newRect = getAbsoluteRect(position)
            }

            if (filterRect !== newRect) {
                filterRect = newRect
                filter.set('size', filterRect.height)
            }
        }
    }

    // 开启关键帧
    Connections {
        target: keyFrameControl
        onEnableKeyFrameChanged: {
            bEnableKeyFrame = bEnable
        }
    }

    // 自动添加关键帧信号，当参数改变时
    Connections {
        target: keyFrameControl
        onAutoAddKeyFrameChanged: {
            bAutoSetAsKeyFrame = bEnable
        }
    }

    //添加关键帧信号
    Connections {
        target: keyFrameControl
        onAddFrameChanged: {
             //如果没有关键帧，先创建头尾两个关键帧
             if (filter.getKeyFrameNumber() <= 0) {
                 setInAndOutKeyFrame()
             }

             //插入新的关键帧
             var nFrame = timeline.getPositionInCurrentClip()
             setKeyFrameOfFrame(nFrame)

             //更新关键帧相关控件
             setKeyframedControls()
        }
    }

    //帧位置改变信号
    Connections {
        target: keyFrameControl
        onFrameChanged: {
            if (bEnableKeyFrame) {
                var nFrame = keyFrameNum
                console.log("sll------3333333333333333333333333333333333----nFrame---", nFrame)
                if (bAutoSetAsKeyFrame === false) {
                    if (filter.bKeyFrame(nFrame)) {
                        console.log("sll------4444444444444444444444444444-------")
                        loadSavedKeyFrame()
                    }
                }
            }
            setKeyframedControls()
        }
    }

    // 移除关键帧信号
    Connections {
        target: keyFrameControl
        onRemoveKeyFrame: {
            var nFrame = timeline.getPositionInCurrentClip()
            filter.removeKeyFrameParaValue(nFrame);
            filter.combineAllKeyFramePara();

            setKeyframedControls()
        }
    }

    // 移除所有关键帧信号
    Connections {
        target: keyFrameControl
        onRemoveAllKeyFrame: {
            removeAllKeyFrame()
            resetFilterPara()

            setControls()
            setKeyframedControls()
        }
    }
}

