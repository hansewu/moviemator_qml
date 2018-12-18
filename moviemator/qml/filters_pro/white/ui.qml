
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import MovieMator.Controls 1.0
import QtQuick.Controls.Styles 1.1

Item {
    property var defaultParameters: []
    property var neutralParam
    property var tempParam
    property var defaultNeutral: "#7f7f7f"
    property var defaultTemp: 6500.0
    property var tempScale: 15000.0
    width: 300
    height: 250

    Component.onCompleted: {
        if (filter.get("mlt_service").indexOf("movit.") == 0 ) {
            // Movit filter
            neutralParam = "neutral_color"
            tempParam = "color_temperature"
            tempScale = 1;
        } else {
            // Frei0r filter
            neutralParam = "0"
            tempParam = "1"
            tempScale = 15000.0
        }
        defaultParameters = [neutralParam, tempParam]
        presetItem.parameters = defaultParameters

        if (filter.isNew) {
            // Set default parameter values
            filter.set(neutralParam, defaultNeutral)
            filter.set(tempParam, defaultTemp / tempScale)
            filter.savePreset(defaultParameters)
        }

        var keyFrameCount = filter.getKeyFrameCountOnProject(tempParam);
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
                console.log("1.....")
                var nFrame = filter.getKeyFrameOnProjectOnIndex(index, tempParam);
                var keyValue = filter.getKeyValueOnProjectOnIndex(index, tempParam);


                console.log(nFrame)
                console.log(tempParam)
                console.log(keyValue)
                filter.setKeyFrameParaValue(nFrame, tempParam, keyValue)

                keyValue = filter.getStringKeyValueOnProjectOnIndex(index, neutralParam);
                console.log(nFrame)
                console.log(tempParam)
                console.log(keyValue)
                filter.setKeyFrameParaValue(nFrame,neutralParam, keyValue)

            }
            filter.combineAllKeyFramePara();

            var frame = filter.getKeyFrameOnProjectOnIndex(0, tempParam);

            tempslider.value = parseFloat(filter.getKeyFrameOnProjectOnIndex(0, tempParam) * tempScale)
            tempspinner.value = parseFloat(filter.getKeyValueOnProjectOnIndex(0, neutralParam) * tempScale)
            colorPicker.value = filter.getKeyFrameParaValue(frame, neutralParam)//filter.getKeyValueOnProjectOnIndex(0, ""+neutralParam)
        }
        else
        {
            tempslider.value = filter.getDouble(tempParam) * tempScale
            tempspinner.value = filter.getDouble(tempParam) * tempScale


            colorPicker.value = filter.get(neutralParam)
        }
    }

    GridLayout {
        columns: 3
        anchors.fill: parent
        anchors.margins: 20
        rowSpacing: 15
        
        KeyFrame{
             id: keyFrame
             Layout.columnSpan:3
             onLoadKeyFrame:
             {
                 
                 console.log("onLoadKeyFrameonLoadKeyFrame: " + keyFrameNum)
                 var whiteValue = filter.getKeyFrameParaValue(keyFrameNum, neutralParam);
                 if(whiteValue != -1.0)
                 {
                     colorPicker.value = whiteValue
                 }
                 console.log("whiteValue1: " + whiteValue)

                 whiteValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, tempParam);
                 if(whiteValue != -1.0)
                 {
                     tempslider.value = whiteValue * tempScale
                 }
                 console.log("whiteValue2: " + whiteValue)

             }
        }

        Label {
            text: qsTr('Preset') + "      "
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        Preset {
            id: presetItem
            Layout.columnSpan: 2
            onPresetSelected: {
                tempslider.value = filter.getDouble(tempParam) * tempScale
                colorPicker.value = filter.get(neutralParam)
            }
        }
        
        SeparatorLine {
            Layout.fillWidth: true 
            Layout.columnSpan: 3
        }

        // Row 1
        Label {
            text: qsTr('Neutral color')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        ColorPicker {
            id: colorPicker
            property bool isReady: false
            Component.onCompleted: isReady = true
            onValueChanged: {
                if (isReady) {
                    if(keyFrame.bKeyFrame)
                    {
                        var nFrame = keyFrame.getCurrentFrame();
                        filter.setKeyFrameParaValue(nFrame,neutralParam, value)
                        filter.combineAllKeyFramePara()
                    }
                    else
                    {
                        filter.set(neutralParam, ""+value)
                    }
                    filter.set("disable", 0);
                }
            }
            onPickStarted: {
                filter.set("disable", 1);
            }
        }
        UndoButton {
            onClicked: colorPicker.value = defaultNeutral
        }

        // Row 2
        Label {
            text: qsTr('Color temperature')
            Layout.alignment: Qt.AlignLeft
            color: '#ffffff'
        }
        RowLayout {
            Slider {
                id: tempslider
                Layout.fillWidth: true
                Layout.maximumHeight: tempspinner.height
                style: SliderStyle {
                    groove: Rectangle {
                        rotation: -90
                        height: parent.width
                        x: (parent.width - width) / 2
                        gradient: Gradient {
                            GradientStop { position: 0.000; color: "#FFC500" }
                            GradientStop { position: 0.392; color: "#FFFFFF" }
                            GradientStop { position: 1.000; color: "#DDFFFE" }
                        }
                        radius: 4
                        onWidthChanged: {
                            // Force width (which is really height due to rotation).
                            width = tempslider.height / 2
                        }
                    }
                    handle: Rectangle {
                        color: "lightgray"
                        border.color: "gray"
                        border.width: 2
                        width: height / 2
                        height: tempslider.height
                        radius: 4
                    }
                }
                minimumValue: 1000.0
                maximumValue: 15000.0
                property bool isReady: false
                Component.onCompleted: isReady = true
                onValueChanged: {
                    if (isReady) {
                        if(keyFrame.bKeyFrame)
                        {
                            var nFrame = keyFrame.getCurrentFrame();
                            filter.setKeyFrameParaValue(nFrame,tempParam, (value/tempScale))
                            filter.combineAllKeyFramePara()
                            tempspinner.value = value
                        }
                        else
                        {
                            tempspinner.value = value
                            filter.set(tempParam, value / tempScale)
                        }
                    }
                }
            }
            SpinBox {
                id: tempspinner
                Layout.minimumWidth: 100
                minimumValue: 1000.0
                maximumValue: 15000.0
                decimals: 0
                stepSize: 10
                suffix: ' deg'
                onValueChanged: tempslider.value = value
            }
        }
        UndoButton {
            onClicked: tempslider.value = defaultTemp
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
