
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.1
import MovieMator.Controls 1.0

RowLayout {
    property string value: "white"
    property bool alpha: false
    property alias eyedropper: pickerButton.visible
    property string temporaryColor: "black"

    signal pickStarted

    SystemPalette { id: activePalette; colorGroup: SystemPalette.Active }

    function updateColor(oldColor, newColor) {
        // Make a copy of the current value.
        var myColor = Qt.darker(oldColor, 1.0)
        // Ignore alpha when comparing.
        myColor.a = newColor.a
        // If the user changed color but left alpha at 0,
        // they probably want to reset alpha to opaque.
        if (newColor.a === 0 && !Qt.colorEqual(newColor, myColor)) {
            newColor.a = 1.0
        }
        // Assign the new color value. Unlike docs say, using currentColor
        // is actually more cross-platform compatible.

        return newColor
    }

    ColorPickerItem {
        id: pickerItem
        onColorPicked: {
            value = color
            pickerButton.checked = false
        }
    }

    Button {
        id: colorButton
        implicitWidth: 20
        implicitHeight: 20
        style: ButtonStyle {
            background: Rectangle {
                border.width: 1
                border.color: 'gray'
                radius: 3
                color: temporaryColor
            }
        }
        onClicked: colorDialog.visible = true
        tooltip: qsTr('Click to open color dialog')
    }

    ColorDialog {
        id: colorDialog
        title: qsTr("Please choose a color")
        showAlphaChannel: alpha
        color: value
        onCurrentColorChanged: {
            var newColor = updateColor(temporaryColor, currentColor)
            temporaryColor = newColor
        }
        onRejected: {
            temporaryColor = color
        }
        onAccepted: {
//            updateColor(value, currentColor)
//            // Make a copy of the current value.
//            var myColor = Qt.darker(value, 1.0)
//            // Ignore alpha when comparing.
//            myColor.a = currentColor.a
//            // If the user changed color but left alpha at 0,
//            // they probably want to reset alpha to opaque.
//            if (currentColor.a === 0 && !Qt.colorEqual(currentColor, myColor))
//                currentColor.a = 255
//            // Assign the new color value. Unlike docs say, using currentColor
//            // is actually more cross-platform compatible.
//            value = currentColor
            var newColor = updateColor(value, currentColor)
            currentColor.a = newColor.a
            value = newColor
            temporaryColor = newColor
        }
        modality: Qt.ApplicationModal
    }

    Button {
        id: pickerButton
        iconName: 'color-picker'
        iconSource: 'qrc:///icons/oxygen/32x32/actions/color-picker.png'
        tooltip: '<p>' + qsTr("Pick a color on the screen. By pressing the mouse button and then moving your mouse you can select a section of the screen from which to get an average color.") + '</p>'
        implicitWidth: 20
        implicitHeight: 20
        checkable: true
        onClicked: {
            pickStarted()
            pickerItem.pickColor()
        }
    }
}
