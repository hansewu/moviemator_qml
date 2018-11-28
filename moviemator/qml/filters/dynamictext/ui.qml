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
    width: 330
    height: 370

    Component.onCompleted: {
        if (filter.isNew) {
            if (application.OS === 'Windows')
                filter.set('family', 'Verdana')
//            filter.set('fgcolour', '#ffffffff')
            filter.set("fgcolour", Qt.rect(255, 255, 255, 255))
            filter.set('bgcolour', '#00000000')
            filter.set('olcolour', '#ff000000')
            filter.set('weight', 500)

//            filter.set(rectProperty,   '0/50%:50%x50%')
            filter.set(rectProperty, Qt.rect(0.0, 0.5, 0.5, 0.5))
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'left')
            filter.savePreset(preset.parameters, qsTr('Bottom Left'))

//            filter.set(rectProperty,   '50%/50%:50%x50%')
            filter.set(rectProperty, Qt.rect(0.5, 0.5, 0.5, 0.5))
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'right')
            filter.savePreset(preset.parameters, qsTr('Bottom Right'))

//            filter.set(rectProperty,   '0/0:50%x50%')
            filter.set(rectProperty, Qt.rect(0.0, 0.0, 0.5, 0.5))
            filter.set(valignProperty, 'top')
            filter.set(halignProperty, 'left')
            filter.savePreset(preset.parameters, qsTr('Top Left'))

//            filter.set(rectProperty,   '50%/0:50%x50%')
            filter.set(rectProperty, Qt.rect(0.5, 0.0, 0.5, 0.5))
            filter.set(valignProperty, 'top')
            filter.set(halignProperty, 'right')
            filter.savePreset(preset.parameters, qsTr('Top Right'))

//            filter.set(rectProperty,   '0/76%:100%x14%')
            filter.set(rectProperty, Qt.rect(0.0, 0.76, 1.0, 0.14))
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'center')
            filter.savePreset(preset.parameters, qsTr('Lower Third'))

//            filter.set(rectProperty, '0/0:100%x100%')
            filter.set(rectProperty, Qt.rect(0.0, 0.0, 1.0, 1.0))
            filter.set(valignProperty, 'bottom')
            filter.set(halignProperty, 'center')
            filter.savePreset(preset.parameters)

            //設置默認預設
            filter.set(rectProperty, Qt.rect(0.0, 0.0, 1.0, 1.0))
        }

        setControls()
        filterRect = getAbsoluteRect()
        filter.set('size', filterRect.height)
    }

    function getAbsoluteRect() {
        var rect = filter.getRectOfTextFilter(rectProperty)
        return Qt.rect(rect.x * profile.width, rect.y * profile.height, rect.width * profile.width, rect.height * profile.height)
    }

    function getRelativeRect(absoluteRect) {
        return Qt.rect(absoluteRect.x / profile.width, absoluteRect.y / profile.height, absoluteRect.width / profile.width, absoluteRect.height / profile.height)
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
            filter.set(rectProperty, getRelativeRect(filterRect))
        }
    }

    function setControls() {
        textArea.text = filter.get('argument')
//        fgColor.value = filter.get('fgcolour')

        var colorRect = filter.getRectOfTextFilter("fgcolour")
        var aStr = colorRect.x.toString(16)
        var rStr = colorRect.y.toString(16)
        var gStr = colorRect.width.toString(16)
        var bStr = colorRect.height.toString(16)
        var colorStr = "#" + aStr + rStr + gStr + bStr
        fgColor.value = colorStr

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

    ExclusiveGroup { id: sizeGroup }
    ExclusiveGroup { id: halignGroup }
    ExclusiveGroup { id: valignGroup }

    GridLayout {
        columns: 5
        anchors.fill: parent
        anchors.margins: 8

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
                var newRect = getAbsoluteRect()
                if (newRect !== filterRect) {
                    filterRect = getAbsoluteRect()
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
                text: qsTr('Timecode')
                Layout.minimumHeight: preset.height
                Layout.maximumHeight: preset.height
                Layout.minimumWidth: (preset.width - 8) / 2
                Layout.maximumWidth: (preset.width - 8) / 2                
                onClicked: textArea.insert(textArea.cursorPosition, '#timecode#')
            }
            Button {
                text: qsTr('Frame #', 'Frame number')
                Layout.minimumHeight: preset.height
                Layout.maximumHeight: preset.height
                Layout.minimumWidth: (preset.width - 8) / 2
                Layout.maximumWidth: (preset.width - 8) / 2                
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
                text: qsTr('File date')
                Layout.minimumHeight: preset.height
                Layout.maximumHeight: preset.height
                Layout.minimumWidth: (preset.width - 8) / 2
                Layout.maximumWidth: (preset.width - 8) / 2                
                onClicked: textArea.insert(textArea.cursorPosition, '#localfiledate#')
            }
            Button {
                text: qsTr('File name')
                Layout.minimumHeight: preset.height
                Layout.maximumHeight: preset.height
                Layout.minimumWidth: (preset.width - 8) / 2
                Layout.maximumWidth: (preset.width - 8) / 2                
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
                onValueChanged: {
                    var aStr = value.substring(1, 3)
                    var rStr = value.substring(3, 5)
                    var gStr = value.substring(5, 7)
                    var bStr = value.substring(7)
                    if (value.length <= 7) {
                        aStr = "FF"
                        rStr = value.substring(1, 3)
                        gStr = value.substring(3, 5)
                        bStr = value.substring(5)
                    }

                    var rInt = parseInt(rStr, 16)
                    var gInt = parseInt(gStr, 16)
                    var bInt = parseInt(bStr, 16)
                    var aInt = parseInt(aStr, 16)

                    filter.set('fgcolour', Qt.rect(aInt, rInt, gInt, bInt))
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
                    onFontChanged: filter.set('family', font.family)
                    onAccepted: fontButton.text = font.family
                    onRejected: filter.set('family', fontButton.text)
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
                onActivated: filter.set('weight', 10 * values[index])
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
            onValueChanged: filter.set('olcolour', value)
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
            onValueChanged: filter.set('outline', value)
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
            onValueChanged: filter.set('bgcolour', value)
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
            onValueChanged: filter.set('pad', value)
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
                Layout.minimumWidth: (preset.width - 8) / 2 - 10
                Layout.maximumWidth: (preset.width - 8) / 2 - 10                
                text: filterRect.x.toFixed()
                horizontalAlignment: Qt.AlignRight
                onEditingFinished: setFilter()
            }
            Label {
                text: ','
                color: '#ffffff'
            }
            TextField {
                id: rectY
                Layout.minimumWidth: (preset.width - 8) / 2 - 10
                Layout.maximumWidth: (preset.width - 8) / 2 - 10                
                text: filterRect.y.toFixed()
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
                Layout.minimumWidth: (preset.width - 8) / 2 - 10
                Layout.maximumWidth: (preset.width - 8) / 2 - 10                
                text: filterRect.width.toFixed()
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
            onClicked: filter.set(halignProperty, 'left')
        }
        RadioButton {
            id: centerRadioButton
            text: qsTr('Center')
            exclusiveGroup: halignGroup
            onClicked: filter.set(halignProperty, 'center')
        }
        RadioButton {
            id: rightRadioButton
            text: qsTr('Right')
            exclusiveGroup: halignGroup
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
            onClicked: filter.set(valignProperty, 'top')
        }
        RadioButton {
            id: middleRadioButton
            text: qsTr('Middle')
            exclusiveGroup: valignGroup
            onClicked: filter.set(valignProperty, 'middle')
        }
        RadioButton {
            id: bottomRadioButton
            text: qsTr('Bottom')
            exclusiveGroup: valignGroup
            onClicked: filter.set(valignProperty, 'bottom')
        }
        Item { Layout.fillWidth: true }

        Item { Layout.fillHeight: true }
    }

    Connections {
        target: filter
        onChanged: {
            var newRect = getAbsoluteRect()
            if (filterRect !== newRect) {
                filterRect = newRect
                filter.set('size', filterRect.height)
            }
        }
    }
}

