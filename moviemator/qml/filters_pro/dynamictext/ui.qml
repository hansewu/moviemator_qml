/*
 * Copyright (c) 2014-2015 Meltytech, LLC
 * Author: Dan Dennedy <dan@dennedy.org>
 *
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: wyl <wyl@pylwyl.local>
 * Author: Dragon-S <15919917852@163.com>
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
    property bool blockUpdate: false
    property bool bEnableKeyFrame: (filter.cache_getKeyFrameNumber() > 0)
    property bool bAutoSetAsKeyFrame: false
    property bool bTemporaryKeyFrame: false
    property var  m_lastFrameNum: -1 
    property bool m_bLastEnableKeyFrame: false
//    property var  m_parameterValue: new Array()
    property bool  m_refreshedUI:false

    width: 500
    height: 950

    function getColorStr(colorValue)
    {
        var int_color = parseInt(colorValue)

        if(int_color <=0)  
            int_color = 0
        
        if(int_color >= 255)  
            int_color = 255

        var colorStr = int_color.toString(16)

        if(colorStr.length <= 1)
            colorStr = "0" + colorStr

        return colorStr
    }

    function isRectPosValid(rect)
    {
        if(rect.x == 2.22507e-308 || rect.y == 2.22507e-308 || rect.width == 2.22507e-308 || rect.height == 2.22507e-308)
            return false
       
        if(rect.x*10000 < -100 || rect.x > 0.8)
            return false
        if(rect.y*10000 < -100 || rect.y > 0.8)
            return false

        if(rect.width < 0.0001 || rect.width > 2)
            return false
        if(rect.height < 0.0001 || rect.height > 2)
            return false
    
        return true
    }

    function isColorRectValid(rect)
    {
        if(rect.x == 2.22507e-308 || rect.y == 2.22507e-308 || rect.width == 2.22507e-308 || rect.height == 2.22507e-308)
            return false
        if(rect.toString() === "QRectF(0, 0, 0, 2.22507e-308)")
            return false
        if(rect.x > 0 && rect.x < 0.00001)
            return false
        if(rect.y > 0 && rect.y < 0.00001)
            return false
        if(rect.width > 0 && rect.width < 0.00001)
            return false
        if(rect.height > 0 && rect.height < 0.00001)
            return false
    
        return true
    }
    function getHexStrColor(position, propertyName) 
    {
        var colorRect = filter.getRectOfTextFilter(propertyName)

        console.log("propertyName = ", propertyName, " colorRect =", colorRect)

        if (position >= 0) 
        {
            colorRect = filter.getAnimRectValue(position, propertyName)
        }

        if(isColorRectValid(colorRect) === false)
            return "invalid"

        var aStr = getColorStr(colorRect.x)
        var rStr = getColorStr(colorRect.y)
        var gStr = getColorStr(colorRect.width)
        var bStr = getColorStr(colorRect.height)

        return "#" + aStr + rStr + gStr + bStr
    }

    function getRectColor(hexStrColor) 
    {
        if(hexStrColor.length != 7 && hexStrColor.length != 9) 
            return Qt.rect(255, 255, 255, 255)

        var aStr = "FF",  rStr = "FF", gStr = "FF", bStr = "FF";

        if (hexStrColor.length == 7) 
        {
            aStr = "FF"
            rStr = hexStrColor.substring(1, 3)
            gStr = hexStrColor.substring(3, 5)
            bStr = hexStrColor.substring(5)
        }
        else
        {
            aStr = hexStrColor.substring(1, 3)
            rStr = hexStrColor.substring(3, 5)
            gStr = hexStrColor.substring(5, 7)
            bStr = hexStrColor.substring(7)
        }

        return Qt.rect(parseInt(aStr, 16), parseInt(rStr, 16), parseInt(gStr, 16), parseInt(bStr, 16))
    }

    function getAbsoluteRect(position) 
    {
        var rect = filter.getRectOfTextFilter(rectProperty)
        if (position >= 0) 
        {
            rect = filter.getAnimRectValue(position, rectProperty)
        }
        return Qt.rect(rect.x * profile.width, rect.y * profile.height, rect.width * profile.width, rect.height * profile.height)
    }

    function getRelativeRect(absoluteRect) 
    {
        return Qt.rect(absoluteRect.x / profile.width, absoluteRect.y / profile.height, absoluteRect.width / profile.width, absoluteRect.height / profile.height)
    }



    function combineAllKeyFramePara()
    {
        var metaParamList = metadata.keyframes.parameters
        for(var paramIndex = 0; paramIndex < metaParamList.length; paramIndex++) 
        {
            var property = metadata.keyframes.parameters[paramIndex].property
	    
	  //      filter.resetProperty(property)
        }

        filter.syncCacheToProject()
    }

    function getResetValue(property)
    {
        if(property == fgcolourProperty) return  Qt.rect(255.0, 255.0, 255.0, 255.0)
        if(property == bgcolourProperty) return  Qt.rect(0.0, 0.0, 0.0, 0.0)
        if(property == olcolourProperty) return  Qt.rect(255.0, 0.0, 0.0, 0.0)
        if(property == rectProperty)      return Qt.rect(0.0148437, 0.441667, 0.948438, 0.195833)

        return 0
    }

    function getNormalVaue(propertyGet) 
    {
        var paramCount = metadata.keyframes.parameterCount

        var propertyValue = ""

        for(var i = 0; i < paramCount; i++) 
        {
            var property = metadata.keyframes.parameters[i].property
            var paraType = metadata.keyframes.parameters[i].paraType

            if(propertyGet === property)
            {
                if (paraType === "rect") 
                {
                    propertyValue = filter.getRectOfTextFilter(property)
                    if(property == rectProperty)
                    {
                        if(isRectPosValid(propertyValue) == false)
                            propertyValue = getResetValue(property)
                    }
                    else if(isColorRectValid(propertyValue) == false)
                    {
                        propertyValue = getResetValue(property)
                    }
                }
                else if (paraType === "double") 
                {
                    propertyValue = filter.getDouble(property)
                }
                else if (paraType === "int") 
                {
                    propertyValue = filter.getInt(property)
                }
                else
                {
                    propertyValue = filter.get(property)
                }
            }
        }    

        return propertyValue
    }

    function setKeyFrameOfFrame (nFrame) 
    {
        var paramCount = metadata.keyframes.parameterCount

        for(var i = 0; i < paramCount; i++) 
        {
            var property = metadata.keyframes.parameters[i].property
            var paraType = metadata.keyframes.parameters[i].paraType
            if (paraType === "rect") 
            {
                var rectValue = filter.getAnimRectValue(nFrame, property)
                filter.cache_setKeyFrameParaRectValue(nFrame, property, rectValue, 1.0)
            } 
            else if(paraType === "double")
            {
                var valueStr = filter.getAnimDoubleValue(nFrame, property)
                filter.cache_setKeyFrameParaValue(nFrame, property, valueStr.toString());
            }
            else 
            {
                var valueStr = filter.getAnimIntValue(nFrame, property)
                filter.cache_setKeyFrameParaValue(nFrame, property, valueStr.toString());
            }
        }
        combineAllKeyFramePara();
    }

    function setKeyFrameParaValue (nFrame, currentPropert, value) 
    {
        var paramCount = metadata.keyframes.parameterCount
        //console.log("setKeyFrameParaValue paramCount: ", paramCount)

        for(var i = 0; i < paramCount; i++) 
        {
            var property = metadata.keyframes.parameters[i].property
            var paraType = metadata.keyframes.parameters[i].paraType
            if (property === currentPropert) 
            {
                if (paraType === "rect") 
                {
                    filter.cache_setKeyFrameParaRectValue(nFrame, property, value, 1.0)
                } 
                else 
                {
                //    console.log("setKeyFrameParaValue currentPropert: ", currentPropert, "value: ", value)
                    filter.cache_setKeyFrameParaValue(nFrame, property, value.toString());
                }
            } 
            
        }
        combineAllKeyFramePara();
    }

    function setInAndOutKeyFrame () 
    {
        var positionStart = 0
        var positionEnd = (timeline.getCurrentClipLength() - 1)//filter.producerOut - filter.producerIn + 1

        var paramCount = metadata.keyframes.parameterCount
        for(var i = 0; i < paramCount; i++) 
        {
            var property = metadata.keyframes.parameters[i].property
            var paraType = metadata.keyframes.parameters[i].paraType

            
            if (paraType === "rect") {
                var rectValue = filter.getRectOfTextFilter(property)
              //  m_parameterValue[property] = rectValue
                
                filter.cache_setKeyFrameParaRectValue(positionStart, property, rectValue, 1.0)
                filter.cache_setKeyFrameParaRectValue(positionEnd, property, rectValue, 1.0)
                console.log("paraType = ", paraType, " property = ", property, " valueStr = ", rectValue )
            } 
            else if (paraType === "double") 
            {
                var valueStr = filter.getDouble(property)
             //   m_parameterValue[property] = valueStr
                filter.cache_setKeyFrameParaValue(positionStart, property, valueStr.toString());
                filter.cache_setKeyFrameParaValue(positionEnd, property, valueStr.toString());
                console.log("paraType = ", paraType, " property = ", property, " valueStr = ", valueStr )
            }
            else 
            {
                var valueStr = filter.getInt(property)
              //  m_parameterValue[property] = valueStr
                filter.cache_setKeyFrameParaValue(positionStart, property, valueStr.toString());
                filter.cache_setKeyFrameParaValue(positionEnd, property, valueStr.toString());
                console.log("paraType = ", paraType, " property = ", property, " valueStr = ", valueStr )
            }
           // filter.resetProperty(property)  //wzq
        }
        combineAllKeyFramePara();
    }

    function getMaxKeyFrameCountInfo() 
    {
        var metaParamList = metadata.keyframes.parameters
        var maxKeyFrameConut = 0
        var maxKeyFramePropert = metaParamList[0].property
        for(var paramIndex = 0; paramIndex < metaParamList.length; paramIndex++) 
        {
            var property = metaParamList[paramIndex].property
            var keyFrameCount = filter.getKeyFrameCountOnProject(property)
            if (keyFrameCount > maxKeyFrameConut) 
            {
                maxKeyFrameConut = keyFrameCount
                maxKeyFramePropert = property
            }
        }

        return [maxKeyFrameConut, maxKeyFramePropert]
    }

    function loadSavedKeyFrameNew () 
    {
        var metaParamList = metadata.keyframes.parameters
        var maxKeyFrameCountInfo = getMaxKeyFrameCountInfo()
        for(var keyIndex = 0; keyIndex < maxKeyFrameCountInfo[0]; keyIndex++)
        {
            var nFrame = filter.getKeyFrameOnProjectOnIndex(keyIndex, maxKeyFrameCountInfo[1])
            for(var paramIndex = 0; paramIndex < metaParamList.length; paramIndex++){
                var property = metadata.keyframes.parameters[paramIndex].property
                var paraType = metadata.keyframes.parameters[paramIndex].paraType
                if (nFrame > (timeline.getCurrentClipLength() - 1)) {
                    filter.removeAnimationKeyFrame(nFrame, property)
                    continue
                }

                if (paraType === "rect") 
                {
                    var strValue = filter.get(property)
                    var rectValue = filter.getAnimRectValue(nFrame, property)
                    if (strValue.indexOf("#") !== -1) {
                        rectValue = getRectColor(strValue)
                    }

                    filter.cache_setKeyFrameParaRectValue(nFrame, property, rectValue, 1.0)
                } 
               else if (paraType === "double")
                {
                    var valueStr = filter.getAnimDoubleValue(nFrame, property)
                    filter.cache_setKeyFrameParaValue(nFrame, property, valueStr.toString());
                }
                else 
                {
                    var valueStr = filter.getAnimIntValue(nFrame, property)
                    filter.cache_setKeyFrameParaValue(nFrame, property, valueStr.toString());
                }
            }
        }
        combineAllKeyFramePara();
    }


    
    function loadSavedKeyFrame () 
    {

        var metaParamList = metadata.keyframes.parameters
        for(var paramIndex = 0; paramIndex < metaParamList.length; paramIndex++) 
        {
            var property = metadata.keyframes.parameters[paramIndex].property
            var paraType = metadata.keyframes.parameters[paramIndex].paraType
            var keyFrameCount = filter.cache_getKeyFrameNumber()
            for(var keyIndex = 0; keyIndex < keyFrameCount; keyIndex++) 
            {
                var nFrame = filter.getKeyFrame(keyIndex)
                if (paraType === "rect") 
                {
                    var rectValue = filter.cache_getKeyFrameParaRectValue(nFrame, property)
                    filter.cache_setKeyFrameParaRectValue(nFrame, property, rectValue, 1.0)
                }
                else 
                {
                    //filter.resetProperty(property)
                    var valueStr = filter.cache_getKeyFrameParaDoubleValue(nFrame, property);//没有getKeyFrameParaIntValue
                    filter.cache_setKeyFrameParaValue(nFrame, property, valueStr.toString());
                    console.log("loadSavedKeyFrame nFrame = ", nFrame, " property = ", property, " value = ", valueStr);
                }
            }
	    
        }
        combineAllKeyFramePara()
    }

    function removeAllKeyFrame () 
    {
        if (filter.cache_getKeyFrameNumber() > 0) 
        {
            var metaParamList = metadata.keyframes.parameters
            for(var paramIndex = 0; paramIndex < metaParamList.length; paramIndex++)
            {
                var prop = metaParamList[paramIndex].property

                var valueNormal = getNormalVaue(prop)
                filter.removeAllKeyFrame(prop)
                filter.resetProperty(prop)
                filter.set(prop, valueNormal)
            }

            combineAllKeyFramePara();
        }
    }

    
  /*  function restoreFilterPara()
    {
        for(var key in m_parameterValue) 
        {
            console.log("m_parameterValue key = ", key, "value = ", m_parameterValue[key])
            
            var metaParamList = metadata.keyframes.parameters
            for(var paramIndex = 0; paramIndex < metaParamList.length; paramIndex++) 
            {
                
                var property = metadata.keyframes.parameters[paramIndex].property
                if(property === key)
                {
                    var paraType = metadata.keyframes.parameters[paramIndex].paraType
                    if (paraType === "rect") 
                    {
                     //   if(key === fgcolourProperty)
                     //       filter.set(fgcolourProperty, Qt.rect(255.0, 255.0, 255.0, 255.0))
                     //   else
                        {
                      //      filter.resetProperty(key)
                            filter.set(key, m_parameterValue[key])
                        }
                    }
                    else 
                    {
                    //    filter.resetProperty(key)
                        filter.set(key, m_parameterValue[key])
                    }
                }
            }
	    
        }
    
        
    }

    */
    function resetFilterPara () 
    {
        filter.set(fgcolourProperty, Qt.rect(255.0, 255.0, 255.0, 255.0))
        filter.set(bgcolourProperty, Qt.rect(0.0, 0.0, 0.0, 0.0))
        filter.set(olcolourProperty, Qt.rect(255.0, 0.0, 0.0, 0.0))
        filter.resetProperty(outlineProperty)
        filter.set(outlineProperty, 0)
        filter.resetProperty(letterSpaceingProperty)
        filter.set(letterSpaceingProperty, 0)
        filter.resetProperty(padProperty)
        filter.set(padProperty, 0)
        filter.set(rectProperty, Qt.rect(0.0148437, 0.441667, 0.948438, 0.195833))
        filter.set(valignProperty, 'bottom')
        filter.set(halignProperty, 'center')
        filter.set('argument', 'Welcome to MovieMator')
        filter.set('trans_fix_rotate_x', 0)
        filter.set('trans_scale_x', 1)
        filter.set('trans_ox', 0)
        filter.set('trans_oy', 0)
        filter.set('trans_fix_shear_x', 0)
        
    }

    function  testNormalKeyFrameState()
    {
        var fgcolourNormalOld = filter.getRectOfTextFilter(fgcolourProperty)

        filter.set(fgcolourProperty, Qt.rect(254.0, 254.0, 254.0, 254.0))

        filter.setEnableAnimation(true)

        filter.cache_setKeyFrameParaRectValue(0, fgcolourProperty, Qt.rect(250.0, 250.0, 250.0, 250.0), 1.0)
        filter.cache_setKeyFrameParaRectValue(2, fgcolourProperty, Qt.rect(25.0, 25.0, 250.0, 250.0), 1.0)

        var fgcolourNormalAfterKeyFrame = filter.getRectOfTextFilter(fgcolourProperty)

        removeAllKeyFrame()

        var fgcolourNormalAfterRemoveKeyFrame = filter.getRectOfTextFilter(fgcolourProperty)

        filter.set(fgcolourProperty, fgcolourNormalOld)

        var fgcolourNormalRestore = filter.getRectOfTextFilter(fgcolourProperty)

        console.log("testNormalKeyFrameState fgcolourProperty 1 ", fgcolourNormalOld, " 2 ", fgcolourNormalAfterKeyFrame, " 3 ", fgcolourNormalAfterRemoveKeyFrame, " 4 ", fgcolourNormalRestore )
    }

    function isKeyFramePropterty(property)
    {
        var metaParamList = metadata.keyframes.parameters
        for(var paramIndex = 0; paramIndex < metaParamList.length; paramIndex++)
         {
                var prop = metaParamList[paramIndex].property
                if(prop === property) 
                {
                    return true
                }
         }

         return false
    }

    function updateFilter(currentProperty, value) 
    {
        if (blockUpdate === true) {
            return
        }

        if (bEnableKeyFrame &&  isKeyFramePropterty(currentProperty) === true) 
        {

            var nFrame = timeline.getPositionInCurrentClip()
            if (bAutoSetAsKeyFrame) 
            {
                if (!filter.cache_bKeyFrame(nFrame)) 
                {
                    showAddFrameInfo(nFrame)
                }
                console.log("updateFilter currentPropert: ", currentProperty, "value: ", value)
                cache_setKeyFrameParaValue(nFrame, currentProperty, value);
                combineAllKeyFramePara()
            } 
            else 
            {
                if (filter.cache_bKeyFrame(nFrame)) 
                {
                    cache_setKeyFrameParaValue(nFrame, currentProperty, value);
                    
                    combineAllKeyFramePara()

                } 
                else 
                {
                    filter.set(currentProperty, value)
                }
            }
        } 
        else 
        {
            filter.set(currentProperty, value)
        }
    }

    function updateTemporaryKeyFrame (currentProperty, value) 
    {
        if (blockUpdate === true) {
            return
        }
        if (bEnableKeyFrame) 
        {
            var nFrame = timeline.getPositionInCurrentClip()
            if (bAutoSetAsKeyFrame) {
                if (!filter.cache_bKeyFrame(nFrame)) 
                {
                    bTemporaryKeyFrame = true
                }
                cache_setKeyFrameParaValue(nFrame, currentProperty, value)
            } 
            else 
            {
                if (filter.cache_bKeyFrame(nFrame)) 
                {
                    cache_setKeyFrameParaValue(nFrame, currentProperty, value)
                } 
                else 
                {
                    filter.set(currentProperty, value)
                }
            }
        } 
        else 
        {
            filter.set(currentProperty, value)
        }
    }

    function removeTemporaryKeyFrame () 
    {
        if (blockUpdate === true) 
        {
            return
        }
        if (bEnableKeyFrame) 
        {
            if (bAutoSetAsKeyFrame) 
            {
                var nFrame = timeline.getPositionInCurrentClip()
                if (filter.cache_bKeyFrame(nFrame) && bTemporaryKeyFrame) 
                {
                    filter.removeKeyFrameParaValue(nFrame);
                    combineAllKeyFramePara();

                    setKeyframedControls()

                    bTemporaryKeyFrame = false
                }
            }
        }
    }

    InfoDialog {
        id: addFrameInfoDialog
        text: qsTr('Auto set as key frame at postion')+ ": " + position + "."
        property int position: 0
    }

    function showAddFrameInfo(position)
    {
        if (filter.autoAddKeyFrame() === false) return

        addFrameInfoDialog.show     = false
        addFrameInfoDialog.show     = true
        addFrameInfoDialog.position = position
    }

    Component.onCompleted: {
        console.log("Component.onCompleted")
     //   testNormalKeyFrameState()

        filter.setEnableAnimation(bEnableKeyFrame)
        filter.setAutoAddKeyFrame(bAutoSetAsKeyFrame)

        filter.setInAndOut(0, timeline.getCurrentClipParentLength()-1)

        //导入上次工程保存的关键帧
        loadSavedKeyFrameNew()

        if (filter.isNew) {
            if (application.OS === 'Windows')
                filter.set('family', 'Verdana')

            //resetFilterPara()
            console.log("Component.onCompleted filter.isNew")
        }

        setControls()
        setKeyframedControls()

        if (filter.isNew) {
            filter.set('size', filterRect.height)
        }
    }

    function setControls() 
    {
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

        rotationSlider.value = filter.getDouble('trans_fix_rotate_x')
        scaleSlider.value =  100.0/filter.getDouble('trans_scale_x')
        xOffsetSlider.value = filter.getDouble('trans_ox') * -1
        yOffsetSlider.value = filter.getDouble('trans_oy') * -1
        xShareSlider.value =  filter.getDouble('trans_fix_shear_x')

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

    function setKeyframedControls() 
    {
        if (filter.cache_getKeyFrameNumber() > 0) 
        {

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
            

            rotationSlider.value = filter.getAnimDoubleValue(nFrame, 'trans_fix_rotate_x')
            scaleSlider.value =  100.0/filter.getAnimDoubleValue(nFrame, 'trans_scale_x')
            xOffsetSlider.value = filter.getAnimDoubleValue(nFrame, 'trans_ox') * -1
            yOffsetSlider.value = filter.getAnimDoubleValue(nFrame, 'trans_oy') * -1
            xShareSlider.value =  filter.getAnimDoubleValue(nFrame, 'trans_fix_shear_x')
            console.log("xOffsetSlider.value = ", xOffsetSlider.value, "yOffsetSlider.value", yOffsetSlider.value)

            blockUpdate = false
        }
    }

    function setFilter() 
    {
        if (blockUpdate === true) 
        {
            return
        }
        var x = parseFloat(rectX.text)
        var y = parseFloat(rectY.text)
        var w = parseFloat(rectW.text)
        var h = parseFloat(rectH.text)
        if (x !== filterRect.x ||
            y !== filterRect.y ||
            w !== filterRect.width ||
            h !== filterRect.height) 
            {
            filterRect.x = x
            filterRect.y = y
            filterRect.width = w
            filterRect.height = h

            updateFilter(rectProperty, getRelativeRect(filterRect))
//            var nFrame = keyFrame.getCurrentFrame();
//            if (filter.cache_getKeyFrameNumber() > 0) {
//                cache_setKeyFrameParaValue(nFrame, rectProperty, getRelativeRect(filterRect))
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
//                cache_setKeyFrameParaValue(nFrame, currentProperty, value)
//            } else {
//                if (filter.cache_bKeyFrame(nFrame)) {
//                    cache_setKeyFrameParaValue(nFrame, currentProperty, value)
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
//                if (filter.cache_getKeyFrameNumber() <= 0) {
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
//            onRefreshUI: {
////                console.log("sll-------onRefreshUI----")
////                console.log("sll------111111111111111111111111111111111111-------")
////                if (blockUpdate === true) {
////                    return
////                }
////                console.log("sll------222222222222222222222222222222222222-------")
//                if (bEnableKeyFrame) {
//                    console.log("sll------3333333333333333333333333333333333-------")
//                    var nFrame = keyFrame.getCurrentFrame()
//                    if (bAutoSetAsKeyFrame === false) {
//                        if (filter.cache_bKeyFrame(nFrame)) {
//                            console.log("sll------4444444444444444444444444444-------")
//                            loadSavedKeyFrame()
//                        }
////                        else {
////                            filter.set(letterSpaceingProperty, value)
////                        }
////                        setKeyFrameParaValue(nFrame, letterSpaceingProperty, value.toString())
//                    }
////                    else {
////                        if (filter.cache_bKeyFrame(nFrame)) {
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
            parameters: [rectProperty, halignProperty, valignProperty, 'size', //'argument', 
            fgcolourProperty, 'family', 'weight', olcolourProperty, outlineProperty, bgcolourProperty, padProperty, letterSpaceingProperty,
            'trans_fix_rotate_x', 'trans_scale_x', 'trans_ox', 'trans_oy', 'trans_fix_shear_x']
            m_strType: "tst"
            onBeforePresetLoaded: 
            {
                removeAllKeyFrame()
              
                //resetFilterPara()
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

//        Label {
//            text: qsTr('Insert field')
//            Layout.alignment: Qt.AlignLeft
//            color: '#ffffff'
//        }
//        ComboBox {
//            id: insertFieldCombo
//            Layout.columnSpan: 4
//            Layout.minimumHeight: 32
//            Layout.maximumHeight: 32
//            Layout.minimumWidth: preset.width
//            Layout.maximumWidth: preset.width
//            model: [qsTr('default'), qsTr('Timecode'), qsTr('Frame #', 'Frame number'), qsTr('File date'), qsTr('File name')]
//            property var values: ['welcome!', '#timecode#', '#frame#', '#localfiledate#', '#resource#']
//            function valueToIndex() {
//                var textStr = filter.get('argument')
//                for (var i = 0; i < values.length; ++i)
//                    if (values[i] === textStr) break;
//                if (i === values.length) i = 0;
//                return i;
//            }
//            onActivated: {
//                textArea.insert(textArea.cursorPosition, values[index])
//            }
//        }

        Label {
            text: qsTr('Insert field')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        MyComboBox {
            id: insertFieldCombo
            Layout.columnSpan: 4
            width: 100
            height: 32
            Layout.minimumHeight: 32
            Layout.maximumHeight: 32
            Layout.minimumWidth: preset.width
            Layout.maximumWidth: preset.width
            listModel: ListModel {
                ListElement {name: qsTr('default')}
                ListElement {name: qsTr('Timecode')}
                ListElement {name: qsTr('Frame #', 'Frame number')}
                ListElement {name: qsTr('File date')}
                ListElement {name: qsTr('File name')}
            }
            property var values: ['welcome!', '#timecode#', '#frame#', '#localfiledate#', '#resource#']
            function valueToIndex() {
                var textStr = filter.get('argument')
                for (var i = 0; i < values.length; ++i)
                    if (values[i] === textStr) break;
                if (i === values.length) i = 0;
                return i;
            }
            onCurrentIndexChanged: {
                textArea.insert(textArea.cursorPosition, values[currentIndex])
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
                onCancel: {
                    removeTemporaryKeyFrame()
                }
                onTemporaryColorChanged: {
                //    updateTemporaryKeyFrame(fgcolourProperty, getRectColor(temporaryColor))
                }
                onValueChanged:
                {
                    console.log("fgcolourProperty = ", value, "rectcolor=", getRectColor(value))
                    updateFilter(fgcolourProperty, getRectColor(value))
                    bTemporaryKeyFrame = false
                    

//                    if (blockUpdate === true) {
//                        return
//                    }
//                    var nFrame = keyFrame.getCurrentFrame();
//                    if (filter.cache_getKeyFrameNumber() > 0) {
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
//            ComboBox {
//                id: weightCombo
//                Layout.minimumHeight: 32
//                Layout.maximumHeight: 32
//                Layout.minimumWidth: (preset.width - 8) / 2
//                Layout.maximumWidth: (preset.width - 8) / 2
//                model: [qsTr('Normal'), qsTr('Bold'), qsTr('Light', 'thin font stroke')]
//                property var values: [Font.Normal, Font.Bold, Font.Light]
//                function valueToIndex() {
//                    var w = filter.getDouble('weight')
//                    for (var i = 0; i < values.length; ++i)
//                        if (values[i] === w) break;
//                    if (i === values.length) i = 0;
//                    return i;
//                }
//                onActivated: {
//                    filter.set('weight', 10 * values[index])
//                }
//           }
            MyComboBox {
                id: weightCombo
                Layout.minimumHeight: 32
                Layout.maximumHeight: 32
                Layout.minimumWidth: (preset.width - 8) / 2
                Layout.maximumWidth: (preset.width - 8) / 2
                listModel: ListModel {
                    ListElement {name: qsTr('Normal')}
                    ListElement {name: qsTr('Bold')}
                    ListElement {name: qsTr('Light', 'thin font stroke')}
                }
                property var values: [Font.Normal, Font.Bold, Font.Light]
                function valueToIndex() {
                    var w = filter.getDouble('weight')
                    for (var i = 0; i < values.length; ++i)
                        if (values[i] === w) break;
                    if (i === values.length) i = 0;
                    return i;
                }
                onCurrentIndexChanged: {
                     filter.set('weight', 10 * values[currentIndex])
                }
           }
        }

        Label {
            text: qsTr('Letter Spaceing')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        SpinBox {
            id: letterSpaceing
            Layout.minimumWidth: preset.width
            Layout.maximumWidth: preset.width
            Layout.columnSpan: 4
            minimumValue: 0
            maximumValue: 500
            horizontalAlignment:Qt.AlignLeft
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
//                        if (filter.cache_bKeyFrame(nFrame)) {
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
//                if (filter.cache_getKeyFrameNumber() > 0) {
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
            onCancel: {
                removeTemporaryKeyFrame()
            }
            onTemporaryColorChanged: {
            //    updateTemporaryKeyFrame(olcolourProperty, getRectColor(temporaryColor))
            }
            onValueChanged: {
                updateFilter(olcolourProperty, getRectColor(value))
                bTemporaryKeyFrame = false
//                if (blockUpdate === true) {
//                    return
//                }
//                var nFrame = keyFrame.getCurrentFrame();
//                if (filter.cache_getKeyFrameNumber() > 0) {
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
            Layout.minimumWidth: 150
            Layout.maximumWidth: 150
            Layout.columnSpan: 2
            minimumValue: 0
            maximumValue: 30
            horizontalAlignment:Qt.AlignLeft
            decimals: 0
            onValueChanged: {
                updateFilter(outlineProperty, value.toString())
//                if (blockUpdate === true) {
//                    return
//                }
//                var nFrame = keyFrame.getCurrentFrame();
//                if (filter.cache_getKeyFrameNumber() > 0) {
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
            onCancel: {
                removeTemporaryKeyFrame()
            }
            onTemporaryColorChanged: {
            //    updateTemporaryKeyFrame(bgcolourProperty, getRectColor(temporaryColor))
            }
            onValueChanged: {
                updateFilter(bgcolourProperty, getRectColor(value))
                bTemporaryKeyFrame = false
//                if (blockUpdate === true) {
//                    return
//                }
//                var nFrame = keyFrame.getCurrentFrame();
//                if (filter.cache_getKeyFrameNumber() > 0) {
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
            Layout.minimumWidth: 150
            Layout.maximumWidth: 150
            Layout.columnSpan: 2
            minimumValue: 0
            maximumValue: 100
            horizontalAlignment:Qt.AlignLeft
            decimals: 0
            onValueChanged: {
                updateFilter(padProperty, value.toString())
//                if (blockUpdate === true) {
//                    return
//                }
//                var nFrame = keyFrame.getCurrentFrame();
//                if (filter.cache_getKeyFrameNumber() > 0) {
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

        SeparatorLine {
            Layout.columnSpan: 5
            Layout.minimumWidth: parent.width
            Layout.maximumWidth: parent.width
            width: parent.width
        }


        Label {
            text: qsTr('Position Animation')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        Preset {
            id: presetPositionAnimation
            Layout.columnSpan: 4
            parameters: ['trans_fix_rotate_x', 'trans_scale_x', 'trans_ox', 'trans_oy', 'trans_fix_shear_x']
            m_strType: "pan"
            onBeforePresetLoaded: 
            {
                removeAllKeyFrame()
                //resetFilterPara()
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
            Layout.columnSpan: 1
            Layout.alignment: Qt.AlignLeft
            text: qsTr('Rotation')
            color: '#ffffff'
        }
        SliderSpinner {
            Layout.columnSpan: 3
            objectName: 'rotationSlider'
            id: rotationSlider
            minimumValue: -360
            maximumValue: 360
          //  decimals: 1
            spinnerWidth: 80
            suffix: qsTr(' °')//qsTr(' degree')
            onValueChanged:{
                updateFilter("trans_fix_rotate_x", value.toString())
            }
        }
        UndoButton {
            //Layout.columnSpan: 1
            onClicked: rotationSlider.value = 0  // 360 <-> 7200
        }

        Label {
            Layout.columnSpan: 1
            Layout.alignment: Qt.AlignLeft
            text: qsTr('Scale')
            color: '#ffffff'
        }
        SliderSpinner {
            Layout.columnSpan: 3
            objectName: 'scaleSlider'
            id: scaleSlider
            minimumValue: 0.1
            maximumValue: 500
            decimals: 1
            spinnerWidth: 80
            suffix: ' %'
            onValueChanged: {
                    var valued = value
                    if(valued > 0)
                    {
                        valued = 100.0/valued
                        updateFilter("trans_scale_x", valued.toString())
                    }
            }
        }
        UndoButton {
            Layout.columnSpan: 1
            onClicked: scaleSlider.value = 100 // 
        }


        Label {
            Layout.columnSpan: 1
            Layout.alignment: Qt.AlignLeft
            text: qsTr('X offset')
            color: '#ffffff'
        }
        
        SliderSpinner {
            Layout.columnSpan: 3
            objectName: 'xOffsetSlider'
            id: xOffsetSlider
            minimumValue: -1000
            maximumValue: 1000
            spinnerWidth: 80
            onValueChanged:{
                var valuestr = -value;
                updateFilter("trans_ox", valuestr.toString())
             //   keyFrame.controlValueChanged(xOffsetSlider) 
            }
        }
        UndoButton {
            Layout.columnSpan: 1
            onClicked: xOffsetSlider.value = 0
        }

        Label {
            Layout.columnSpan: 1
            Layout.alignment: Qt.AlignLeft
            text: qsTr('Y offset')
            color: '#ffffff'
        }
        SliderSpinner {
            Layout.columnSpan: 3
            objectName: 'yOffsetSlider'
            id: yOffsetSlider
            minimumValue: -1000
            maximumValue: 1000
            spinnerWidth: 80
            onValueChanged:{
                var valuestr = -value;
                updateFilter("trans_oy", valuestr.toString())

            }
        }
        UndoButton {
            Layout.columnSpan: 1
            onClicked: yOffsetSlider.value = 0
        }


       Label {
            Layout.columnSpan: 1
            Layout.alignment: Qt.AlignLeft
            text: qsTr('X shear')
            color: '#ffffff'
        }
        SliderSpinner {
            Layout.columnSpan: 3
            objectName: 'xShareSlider'
            id: xShareSlider
            minimumValue: -360
            maximumValue: 360
          //  decimals: 1
            spinnerWidth: 80
            suffix: qsTr(' °')//qsTr(' degree')
            onValueChanged:{
                updateFilter("trans_fix_shear_x", value.toString())
            }
        }
        UndoButton {
            //Layout.columnSpan: 1
            onClicked: xShareSlider.value = 0  // 360 <-> 7200
        }
    

        Item { Layout.fillWidth: true }

        Item { Layout.fillHeight: true }

    }

    Connections 
    {
        target: filter
        onFilterPropertyValueChanged: 
        {
            console.log("---filter onChanged---")

            var position        = timeline.getPositionInCurrentClip()
            var newRect         = getAbsoluteRect(-1)
            var keyFrameCount   = filter.getKeyFrameCountOnProject(rectProperty);
            //判断是否有关键帧
            if(keyFrameCount > 0) 
            {
                newRect = getAbsoluteRect(position)
            }

            if (isRectPosValid(newRect) && filterRect !== newRect) 
            {
                filterRect = newRect
                filter.set('size', filterRect.height)
            }
            
        }
    }

    // 开启关键帧
    Connections {
        target: keyFrameControl
        onEnableKeyFrameChanged: 
        {
            console.log("---onEnableKeyFrameChanged---", bEnable)
            if(bEnableKeyFrame != bEnable) //未知原因  否则关键帧的值设置不进去
            {    
               // removeAllKeyFrame();
               // loadSavedKeyFrame()
            }

            bEnableKeyFrame = bEnable
            filter.setEnableAnimation(bEnableKeyFrame)

            
           // m_bLastEnableKeyFrame = bEnableKeyFrame
            
        }
    }

    // 自动添加关键帧信号，当参数改变时
    Connections 
    {
        target: keyFrameControl
        onAutoAddKeyFrameChanged: 
        {
            console.log("---onAutoAddKeyFrameChanged---", bEnable)
            bAutoSetAsKeyFrame = bEnable
            filter.setAutoAddKeyFrame(bAutoSetAsKeyFrame)
        }
    }

    //添加关键帧信号
    Connections 
    {
        target: keyFrameControl
        onAddFrameChanged: {
            console.log("---onAddFrameChanged---")
             //如果没有关键帧，先创建头尾两个关键帧

             if (filter.cache_getKeyFrameNumber() <= 0) 
             {
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

            console.log("---keyFrameNum---", keyFrameNum)
            if(m_lastFrameNum != keyFrameNum)

            {
                setControls()
                setKeyframedControls()
                filter.set('size', filterRect.height)
                m_lastFrameNum = keyFrameNum
            }
            
        }
    }

 //           if (bEnableKeyFrame) {
 //               var nFrame = keyFrameNum
 //               console.log("sll------3333333333333333333333333333333333----nFrame---", nFrame)
  //              if (bAutoSetAsKeyFrame === false) {
  //                  if (filter.bKeyFrame(nFrame)) {
  //                      console.log("sll------4444444444444444444444444444-------")
  //                      loadSavedKeyFrame()  //此处作用，需要再考虑
  //                  }
  //              }
  //          }
    // 移除关键帧信号
    Connections {
        target: keyFrameControl
        onRemoveKeyFrame: {
            var nFrame = timeline.getPositionInCurrentClip()
            filter.removeKeyFrameParaValue(nFrame);
            combineAllKeyFramePara();

            setKeyframedControls()
        }
    }

    // 移除所有关键帧信号
    Connections {
        target: keyFrameControl
        onRemoveAllKeyFrame: {
            removeAllKeyFrame()
        //    restoreFilterPara()
        //    resetFilterPara()

            setControls()
            setKeyframedControls()
        }
    }
}

