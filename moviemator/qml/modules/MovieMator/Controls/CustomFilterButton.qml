import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

ToolButton
{
    property url customIconSource
    property string customText
    property double buttonWidth:40

    width : buttonWidth

    Image {
        source: parent.customIconSource
        fillMode: Image.PreserveAspectFit // For not stretching image (optional)
        anchors.fill: parent
        anchors.margins: 0 // Leaving space between image and borders (optional)
     //   anchors.bottomMargin:10 // Leaving space for text in bottom
    }
    Text {
        text: parent.customText
        color: parent.enabled?'white':'grey'
        font.pixelSize: 15
        anchors.bottom: parent.bottom // Placing text in bottom
        anchors.margins: 4 // Leaving space between text and borders  (optional)
        anchors.horizontalCenter: parent.horizontalCenter // Centering text
        renderType: Text.NativeRendering // Rendering type (optional)
    }

}
