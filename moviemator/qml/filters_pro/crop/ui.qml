
import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0
import QtQuick.Controls.Styles 1.4

Item {
    property var defaultParameters: ['left', 'right', 'top', 'bottom', 'center', 'center_bias']
    width: 300
    height: 250

    function setEnabled() {
        if (centerCheckBox.checked == true) {
            biasslider.enabled = true
            biasundo.enabled = true
            topslider.enabled = false
            topundo.enabled = false
            bottomslider.enabled = false
            bottomundo.enabled = false
            leftslider.enabled = false
            leftundo.enabled = false
            rightslider.enabled = false
            rightundo.enabled = false
        } else {
            biasslider.enabled = false
            biasundo.enabled = false
            topslider.enabled = true
            topundo.enabled = true
            bottomslider.enabled = true
            bottomundo.enabled = true
            leftslider.enabled = true
            leftundo.enabled = true
            rightslider.enabled = true
            rightundo.enabled = true
        }
    }
    
    Component.onCompleted: {
        keyFrame.initFilter(layoutRoot)
        setEnabled()
    }

    GridLayout {
        id: layoutRoot
        columns: 3
        anchors.fill: parent
        anchors.margins: 8

        YFKeyFrame{
            id: keyFrame
            Layout.columnSpan:3
            onSynchroData:{
                keyFrame.setDatas(layoutRoot)
            }
            onLoadKeyFrame:{
                keyFrame.loadFrameValue(layoutRoot)
                setEnabled()
            }
        }

        Label {
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        Preset {
            Layout.columnSpan: 2
            parameters: defaultParameters
            onPresetSelected: {
                centerCheckBox.checked = filter.get('center') == '1'
                biasslider.value = +filter.get('center_bias')
                topslider.value = +filter.get('top')
                bottomslider.value = +filter.get('bottom')
                leftslider.value = +filter.get('left')
                rightslider.value = +filter.get('right')
                setEnabled()
            }
        }

        CheckBox {
            objectName: 'centerCheckBox'
            id: centerCheckBox
            checked: filter.get('center') == '1'
            property bool isReady: false
            Component.onCompleted: isReady = true
            onClicked: {
                if (isReady) {
                    keyFrame.controlValueChanged(centerCheckBox)
                    setEnabled()
                }
            }
            style: CheckBoxStyle {
                        label: Text {
                            color: "white"
                            text: qsTr('Center')
                        }
                }
            
        }
        Item {
            Layout.fillWidth: true;
        }
        UndoButton {
            onClicked: {
                centerCheckBox.checked = false
                filter.set('center', false)
            }
        }

        Label {
            text: qsTr('Center bias')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            objectName: 'biasslider'
            id: biasslider
            minimumValue: -Math.max(profile.width, profile.height) / 2
            maximumValue: Math.max(profile.width, profile.height) / 2
            suffix: ' px'
            value: +filter.get('center_bias')
            onValueChanged: {
                keyFrame.controlValueChanged(biasslider)
            }
        }
        UndoButton {
            id: biasundo
            onClicked: biasslider.value = 0
        }

        Label {
            text: qsTr('Top')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            objectName: 'topslider'
            id: topslider
            minimumValue: 0
            maximumValue: profile.height
            suffix: ' px'
            value: +filter.get('top')
            onValueChanged: {
                keyFrame.controlValueChanged(topslider)
            }
        }
        UndoButton {
            id: topundo
            onClicked: topslider.value = 0
        }

        Label {
            text: qsTr('Bottom')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            objectName: 'bottomslider'
            id: bottomslider
            minimumValue: 0
            maximumValue: profile.height
            suffix: ' px'
            value: +filter.get('bottom')
            onValueChanged: {
                keyFrame.controlValueChanged(bottomslider)
            }
        }
        UndoButton {
            id: bottomundo
            onClicked: bottomslider.value = 0
        }

        Label {
            text: qsTr('Left')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            objectName: 'leftslider'
            id: leftslider
            minimumValue: 0
            maximumValue: profile.width
            suffix: ' px'
            value: +filter.get('left')
            onValueChanged: {
                keyFrame.controlValueChanged(leftslider)
            }
        }
        UndoButton {
            id: leftundo
            onClicked: leftslider.value = 0
        }

        Label {
            text: qsTr('Right')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            objectName: 'rightslider'
            id: rightslider
            minimumValue: 0
            maximumValue: profile.width
            suffix: ' px'
            value: +filter.get('right')
            onValueChanged: {
                keyFrame.controlValueChanged(rightslider)
            }
        }
        UndoButton {
            id: rightundo
            onClicked: rightslider.value = 0
        }
        
        Item {
            Layout.fillHeight: true;
        }
    }
}
