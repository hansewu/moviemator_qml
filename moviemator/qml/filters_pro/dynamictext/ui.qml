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
    property ListModel presetsModle: ListModel {}
    width: 500
    height: 1000

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
            filter.set('argument', 'welcome!')

            //静态预设
            filter.set(rectProperty, Qt.rect(0.0, 0.5, 0.5, 0.5))
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'left')
            filter.savePreset(preset.parameters, qsTr('Bottom Left'))
            presetsModle.append({"name": qsTr('Bottom Left'), "portrait": "qrc:///icons/filters/text/bottom-left.gif"})

            filter.set(rectProperty, Qt.rect(0.5, 0.5, 0.5, 0.5))
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'right')
            filter.savePreset(preset.parameters, qsTr('Bottom Right'))
            presetsModle.append({"name": qsTr('Bottom Right'), "portrait": "qrc:///icons/filters/text/bottom-right.gif"})

            filter.set(rectProperty, Qt.rect(0.0, 0.0, 0.5, 0.5))
            filter.set(valignProperty, 'top')
            filter.set(halignProperty, 'left')
            filter.savePreset(preset.parameters, qsTr('Top Left'))
            presetsModle.append({"name": qsTr('Top Left'), "portrait": "qrc:///icons/filters/text/top-left.gif"})

            filter.set(rectProperty, Qt.rect(0.5, 0.0, 0.5, 0.5))
            filter.set(valignProperty, 'top')
            filter.set(halignProperty, 'right')
            filter.savePreset(preset.parameters, qsTr('Top Right'))
            presetsModle.append({"name": qsTr('Top Right'), "portrait": "qrc:///icons/filters/text/top-right.gif"})

            filter.set(rectProperty, Qt.rect(0.0, 0.76, 1.0, 0.14))
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'center')
            filter.savePreset(preset.parameters, qsTr('Lower Third'))
            presetsModle.append({"name": qsTr('Lower Third'), "portrait": "qrc:///icons/filters/text/lower-third.gif"})


            //动画预设
            var totalFrame = filter.producerOut - filter.producerIn + 1 - 5
            var oneSeconds2Frame = parseInt(profile.fps)
            var startFrame = 0.0
            var middleFrame = oneSeconds2Frame
            var endFrame = totalFrame
            var startValue = "-1.0 0.0 1.0 1.0 1.0"
            var middleValue = "0.0 0.0 1.0 1.0 1.0"
            var endValue = "0.0 0.0 1.0 1.0 1.0"

            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + middleFrame + "|=" + middleValue  + ";" + endFrame + "|=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slide In From Left'))
            presetsModle.append({"name": qsTr('Slide In From Left'), "portrait": "qrc:///icons/filters/text/slide-in-from-left.gif"})

            startValue = "1.0 0.0 1.0 1.0 1.0"
            middleValue = "0.0 0.0 1.0 1.0 1.0"
            endValue = "0.0 0.0 1.0 1.0 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + middleFrame + "|=" + middleValue  + ";" + endFrame + "|=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slide In From Right'))
            presetsModle.append({"name": qsTr('Slide In From Right'), "portrait": "qrc:///icons/filters/text/slide-in-from-right.gif"})

            startValue = "0.0 -1.0 1.0 1.0 1.0"
            middleValue = "0.0 0.0 1.0 1.0 1.0"
            endValue = "0.0 0.0 1.0 1.0 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + middleFrame + "|=" + middleValue  + ";" + endFrame + "|=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slide In From Top'))
            presetsModle.append({"name": qsTr('Slide In From Top'), "portrait": "qrc:///icons/filters/text/slide-in-from-top.gif"})

            startValue = "0.0 1.0 1.0 1.0 1.0"
            middleValue = "0.0 0.0 1.0 1.0 1.0"
            endValue = "0.0 0.0 1.0 1.0 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + middleFrame + "|=" + middleValue  + ";" + endFrame + "|=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slide In From Bottom'))
            presetsModle.append({"name": qsTr('Slide In From Bottom'), "portrait": "qrc:///icons/filters/text/slide-in-from-bottom.gif"})

            middleFrame = totalFrame - oneSeconds2Frame
            if (middleFrame <= 24) {
                middleFrame = totalFrame / 2
            }
            startValue = "0.0 0.0 1.0 1.0 1.0"
            middleValue = "0.0 0.0 1.0 1.0 1.0"
            endValue = "-1.0 0.0 1.0 1.0 1.0"
            filter.set(rectProperty, startFrame + "|=" + startValue + ";" + middleFrame + "~=" + middleValue  + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slide Out Left'))
            presetsModle.append({"name": qsTr('Slide Out Left'), "portrait": "qrc:///icons/filters/text/slide-out-left.gif"})

            startValue = "0.0 0.0 1.0 1.0 1.0"
            middleValue = "0.0 0.0 1.0 1.0 1.0"
            endValue = "1.0 0.0 1.0 1.0 1.0"
            filter.set(rectProperty, startFrame + "|=" + startValue + ";" + middleFrame + "~=" + middleValue  + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slide Out Right'))
            presetsModle.append({"name": qsTr('Slide Out Right'), "portrait": "qrc:///icons/filters/text/slide-out-right.gif"})

            startValue = "0.0 0.0 1.0 1.0 1.0"
            middleValue = "0.0 0.0 1.0 1.0 1.0"
            endValue = "0.0 -1.0 1.0 1.0 1.0"
            filter.set(rectProperty, startFrame + "|=" + startValue + ";" + middleFrame + "~=" + middleValue  + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slide Out Top'))
            presetsModle.append({"name": qsTr('Slide Out Top'), "portrait": "qrc:///icons/filters/text/slide-out-top.gif"})

            startValue = "0.0 0.0 1.0 1.0 1.0"
            middleValue = "0.0 0.0 1.0 1.0 1.0"
            endValue = "0.0 1.0 1.0 1.0 1.0"
            filter.set(rectProperty, startFrame + "|=" + startValue + ";" + middleFrame + "~=" + middleValue  + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slide Out Bottom'))
            presetsModle.append({"name": qsTr('Slide Out Bottom'), "portrait": "qrc:///icons/filters/text/slide-out-bottom.gif"})

            startValue = "0.0 0.0 1.0 1.0 1.0"
            endValue = "-0.05 -0.05 1.1 1.1 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slow Zoom In'))
            presetsModle.append({"name": qsTr('Slow Zoom In'), "portrait": "qrc:///icons/filters/text/shapes.gif"})

            startValue = "-0.05 -0.05 1.1 1.1 1.0"
            endValue = "0.0 0.0 1.0 1.0 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slow Zoom Out'))
            presetsModle.append({"name":  qsTr('Slow Zoom Out'), "portrait": "qrc:///icons/filters/text/shapes.gif"})

            startValue = "-0.05 -0.05 1.1 1.1 1.0"
            endValue = "-0.1 -0.05 1.1 1.1 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slow Pan Left'))
            presetsModle.append({"name":  qsTr('Slow Pan Left'), "portrait": "qrc:///icons/filters/text/shapes.gif"})

            startValue = "-0.05 -0.05 1.1 1.1 1.0"
            endValue = "0.0 -0.05 1.1 1.1 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slow Pan Right'))
            presetsModle.append({"name":  qsTr('Slow Pan Right'), "portrait": "qrc:///icons/filters/text/shapes.gif"})

            startValue = "-0.05 -0.05 1.1 1.1 1.0"
            endValue = "-0.05 -0.1 1.1 1.1 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slow Pan Up'))
            presetsModle.append({"name":  qsTr('Slow Pan Up'), "portrait": "qrc:///icons/filters/text/shapes.gif"})

            startValue = "-0.05 -0.05 1.1 1.1 1.0"
            endValue = "-0.05 0.0 1.1 1.1 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slow Pan Down'))
            presetsModle.append({"name":  qsTr('Slow Pan Down'), "portrait": "qrc:///icons/filters/text/shapes.gif"})

            startValue = "0.0 0.0 1.0 1.0 1.0"
            endValue = "-0.1 -0.1 1.1 1.1 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slow Zoom In, Pan Up Left'))
            presetsModle.append({"name": qsTr('Slow Zoom In, Pan Up Left'), "portrait": "qrc:///icons/filters/text/shapes.gif"})

            startValue = "0.0 0.0 1.0 1.0 1.0"
            endValue = "0.0 0.0 1.1 1.1 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slow Zoom In, Pan Down Right'))
            presetsModle.append({"name": qsTr('Slow Zoom In, Pan Down Right'), "portrait": "qrc:///icons/filters/text/shapes.gif"})

            startValue = "-0.1 0.0 1.1 1.1 1.0"
            endValue = "0.0 0.0 1.0 1.0 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slow Zoom Out, Pan Up Right'))
            presetsModle.append({"name": qsTr('Slow Zoom Out, Pan Up Right'), "portrait": "qrc:///icons/filters/text/shapes.gif"})

            startValue = "0.0 -0.1 1.1 1.1 1.0"
            endValue = "0.0 0.0 1.0 1.0 1.0"
            filter.set(rectProperty, startFrame + "~=" + startValue + ";" + endFrame + "~=" + endValue)
            filter.savePreset(preset.parameters, qsTr('Slow Zoom Out, Pan Down Left'))
            presetsModle.append({"name": qsTr('Slow Zoom Out, Pan Down Left'), "portrait": "qrc:///icons/filters/text/shapes.gif"})

            filter.removeAllKeyFrame(rectProperty)

            filter.set(rectProperty, Qt.rect(0.0, 0.0, 1.0, 1.0))
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'center')
            filter.savePreset(preset.parameters)
            presetsModle.insert(0, {"name": filter.presets[1], "portrait": "qrc:///icons/filters/text/default.gif"})//默认
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
        insertFieldCombo.currentIndex = insertFieldCombo.valueToIndex()
        outlineColor.value = filter.get('olcolour')
        outlineColor.temporaryColor = filter.get('olcolour')
        outlineSpinner.value = filter.getDouble('outline')
        letterSpaceing.value = filter.getDouble("letter_spaceing")
        bgColor.value = filter.get('bgcolour')
        bgColor.temporaryColor = filter.get('bgcolour')
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
        rowSpacing : 25


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
            onRemovedAllKeyFrame: {
                var keyFrameCount   = filter.getKeyFrameCountOnProject(rectProperty)
                if (keyFrameCount > 0) {
                    filter.removeAllKeyFrame(rectProperty)
                    keyFrameCount = -1
                }
                keyFrameCount   = filter.getKeyFrameCountOnProject("fgcolour")
                if (keyFrameCount > 0) {
                    filter.removeAllKeyFrame("fgcolour")
                    keyFrameCount = -1
                }
                filter.resetProperty("fgcolour")
                filter.resetProperty(rectProperty)

                //重置带有动画的属性的属性值
                filter.set("fgcolour", Qt.rect(255.0, 255.0, 255.0, 255.0))
                filter.set(rectProperty, Qt.rect(0.0, 0.0, 1.0, 1.0))
            }
            onLoadKeyFrame:
            {
                if (filter.getKeyFrameNumber() > 0) {
                    var hexStrColor = getHexStrColor(keyFrameNum)
                    if (hexStrColor !== "") {
                        fgColor.value = hexStrColor
                    }

                    filterRect = getAbsoluteRect(keyFrameNum)
                    filter.set('size', filterRect.height)
                    filterRect = getAbsoluteRect(keyFrameNum)
                } else {
                    var hexStrColor = getHexStrColor(-1)
                    if (hexStrColor !== "") {
                        fgColor.value = hexStrColor
                    }

                    filterRect = getAbsoluteRect(-1)
                    filter.set('size', filterRect.height)
                    filterRect = getAbsoluteRect(-1)
                }
            }
        }


//        Label {
//            text: qsTr('Preset')
//            Layout.alignment: Qt.AlignRight
//            color: '#ffffff'
//        }
//        Preset {
//            id: preset

//            parameters: [rectProperty, halignProperty, valignProperty, 'argument', 'size',
//            'fgcolour', 'family', 'weight', 'olcolour', 'outline', 'bgcolour', 'pad']
//            Layout.columnSpan: 4
//            onBeforePresetLoaded: {
//                var keyFrameCount   = filter.getKeyFrameCountOnProject(rectProperty)
//                if (keyFrameCount > 0) {
//                    filter.removeAllKeyFrame(rectProperty)
//                    keyFrameCount = -1
//                }
//                keyFrameCount   = filter.getKeyFrameCountOnProject("fgcolour")
//                if (keyFrameCount > 0) {
//                    filter.removeAllKeyFrame("fgcolour")
//                    keyFrameCount = -1
//                }

//                filter.resetProperty("fgcolour")
//                filter.resetProperty(rectProperty)
//            }
//            onPresetSelected: {
//                //加載關鍵幀
//                var metaParamList = metadata.keyframes.parameters
//                var keyFrameCount = filter.getKeyFrameCountOnProject(metaParamList[0].property);
//                for(var keyIndex=0; keyIndex<keyFrameCount;keyIndex++)
//                {
//                    var nFrame = filter.getKeyFrameOnProjectOnIndex(keyIndex, metaParamList[0].property)
//                    for(var paramIndex=0;paramIndex<metaParamList.length;paramIndex++){
//                        var prop = metaParamList[paramIndex].property
//                        var keyValue = filter.getAnimRectValue(nFrame, prop)
//                        filter.setKeyFrameParaRectValue(nFrame, prop, keyValue)
//                    }
//                }
//                filter.combineAllKeyFramePara();

//                setControls()
//                setKeyframedControls()

//                if (filter.isNew) {
//                    filter.set('size', filterRect.height)
//                }
//            }
//        }

        Label {
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        NewPreset {
            id: preset
            presets: presetsModle
            Layout.columnSpan: 4
            parameters: [rectProperty, halignProperty, valignProperty, 'argument', 'size',
            'fgcolour', 'family', 'weight', 'olcolour', 'outline', 'bgcolour', 'pad']
            onBeforePresetLoaded: {
                var keyFrameCount   = filter.getKeyFrameCountOnProject(rectProperty)
                if (keyFrameCount > 0) {
                    filter.removeAllKeyFrame(rectProperty)
                    keyFrameCount = -1
                }
                keyFrameCount   = filter.getKeyFrameCountOnProject("fgcolour")
                if (keyFrameCount > 0) {
                    filter.removeAllKeyFrame("fgcolour")
                    keyFrameCount = -1
                }

                filter.resetProperty("fgcolour")
                filter.resetProperty(rectProperty)
            }
            onPresetSelected: {
                //加載關鍵幀
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
                filter.set('letter_spaceing', value)
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
            onTemporaryColorChanged: {
                filter.set('olcolour', temporaryColor)
            }
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
            Layout.minimumWidth: 120
            Layout.maximumWidth: 120
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
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        ColorPicker {
            id: bgColor
            eyedropper: false
            alpha: true
            onTemporaryColorChanged: {
                filter.set('bgcolour', temporaryColor)
            }
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
            Layout.minimumWidth: 120
            Layout.maximumWidth: 120
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
}

