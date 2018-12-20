import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import MovieMator.Controls 1.0

Rectangle {
    id:keyFrame

    color: '#353535'//activePalette.window
    width: parent.width
    height: 100

    signal addFrameChanged()
    signal frameChanged(double keyFrameNum)
    signal removeKeyFrame()
    signal removeAllKeyFrame()

    function refreshFrameButtonsEnable()
    {
        var position = timeline.getPositionInCurrentClip()

        addKeyFrameButton.enabled   = enableKeyFrameCheckBox.checked && !autoAddKeyFrameCheckBox.checked && metadata && (metadata.keyframes.parameterCount > 0)
        preKeyFrameButton.enabled   = enableKeyFrameCheckBox.checked && metadata && (metadata.keyframes.parameterCount > 0) && filter.bHasPreKeyFrame(position)
        nextKeyFrameButton.enabled  = enableKeyFrameCheckBox.checked && metadata && (metadata.keyframes.parameterCount > 0) && filter.bHasNextKeyFrame(position)
        removeKeyFrameButton.enabled= enableKeyFrameCheckBox.checked && metadata && (metadata.keyframes.parameterCount > 0) && filter.bKeyFrame(position)
    }

    Connections {
        target: filterDock
        onPositionChanged: {
             preKeyFrameButton.enabled      = enableKeyFrameCheckBox.checked && filter.bHasPreKeyFrame(timeline.getPositionInCurrentClip())
             nextKeyFrameButton.enabled     = enableKeyFrameCheckBox.checked && filter.bHasNextKeyFrame(timeline.getPositionInCurrentClip())
             removeKeyFrameButton.enabled   = enableKeyFrameCheckBox.checked && filter.bKeyFrame(timeline.getPositionInCurrentClip())
            
             var position = timeline.getPositionInCurrentClip()
             frameChanged(position)
        }
    }

    GroupBox{
            width: parent.width
            height: parent.height
            title: " " + qsTr('Key Frame') + " "
            //font.pixelSize: 15
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                topMargin: 0
                leftMargin: 10
                rightMargin: 10
                bottomMargin: 8
            }
            
            GridLayout {
                columns: 4
        

                CheckBox {
                    id: enableKeyFrameCheckBox
                    Layout.columnSpan: 4
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    checked: false
                    property bool isReady: false
                    Component.onCompleted: isReady = true
                    onClicked: {
                        if (isReady) {
                            
                        }
                    }

                    style: CheckBoxStyle {
                        label: Text {
                            color: "white"
                            text: qsTr('Enable Key Frames')
                        }
                    }

                    onCheckedChanged: refreshFrameButtonsEnable()
                }

                CheckBox {
                    id: autoAddKeyFrameCheckBox
                    Layout.columnSpan: 4
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    checked: false
                    property bool isReady: false
                    Component.onCompleted: isReady = true
                    onClicked: {
                        if (isReady) {
                            
                        }
                    }

                    style: CheckBoxStyle {
                        label: Text {
                            color: "white"
                            text: qsTr('Auto Add Key Frames')
                        }
                    }
                    onCheckedChanged: refreshFrameButtonsEnable()
                    
                }

                CustomFilterButton {
                    id:addKeyFrameButton
                    anchors {
                        top: parent.bottom
                        left: parent.left
                        leftMargin: 10
                        topMargin: -37
                    }
                    implicitWidth: 32
                    implicitHeight: 32

                    //enabled: (enableKeyFrameCheckBox.checked && !autoAddKeyFrameCheckBox.checked && metadata && (metadata.keyframes.parameterCount > 0)) ? true : false   
                    opacity: enabled ? 1.0 : 0.5
                    tooltip: qsTr('Add key frame')
                    customIconSource: 'qrc:///icons/light/32x32/list-add.png'
                    //customText: qsTr('Add')
                    buttonWidth : 85
                    onClicked: {
                        addFrameChanged()
                    }
                    onEnabledChanged: {
                        var position = timeline.getPositionInCurrentClip()
                        preKeyFrameButton.enabled      = enableKeyFrameCheckBox.checked && metadata && (metadata.keyframes.parameterCount > 0)
                        nextKeyFrameButton.enabled     = enableKeyFrameCheckBox.checked && metadata && (metadata.keyframes.parameterCount > 0)
                        removeKeyFrameButton.enabled   = enableKeyFrameCheckBox.checked && metadata && (metadata.keyframes.parameterCount > 0)
                    }
                }

                CustomFilterButton {
                    id:removeKeyFrameButton
                    anchors {
                        top: addKeyFrameButton.top
                        left: addKeyFrameButton.right
                        leftMargin: 20
                        topMargin: 0
                    }
                    implicitWidth: 32
                    implicitHeight: 32

                    // enabled: filter.bKeyFrame(timeline.getPositionInCurrentClip())
                    //enabled: (enableKeyFrameCheckBox.checked)? true : false 
                    opacity: enabled ? 1.0 : 0.5
                    tooltip: qsTr('Remove key frame')
                    customIconSource: 'qrc:///icons/light/32x32/list-remove.png'
                    //customText: qsTr('Remove')
                    buttonWidth : 85
                    onClicked: {
                        var position        = timeline.getPositionInCurrentClip()
                        var bKeyFrame       = filter.bKeyFrame(position)
                        if (bKeyFrame)
                            filter.removeKeyFrameParaValue(position)
                            removeKeyFrame()
                    }
                }

                CustomFilterButton {
                    id:preKeyFrameButton
                    anchors {
                        top: addKeyFrameButton.top
                        left: removeKeyFrameButton.right
                        leftMargin: 20
                        topMargin: 0
                    }
                    implicitWidth: 32
                    implicitHeight: 32

                    //enabled: enableKeyFrameCheckBox.checked && filter.bHasPreKeyFrame(timeline.getPositionInCurrentClip())
                    opacity: enabled ? 1.0 : 0.5
                    tooltip: qsTr('Prev key frame')
                    customIconSource: enabled?'qrc:///icons/light/32x32/previous_keyframe.png' :'qrc:///icons/light/32x32/previous_keyframe_disable.png'
                    //customText: qsTr('<<')
                    buttonWidth : 85
                    onClicked: {
                        var nFrame = filter.getPreKeyFrameNum(timeline.getPositionInCurrentClip())
                        if(nFrame != -1)
                        {
                            filterDock.position = nFrame
                        }
                    }
                }

                CustomFilterButton {
                    id:nextKeyFrameButton
                    anchors {
                        top: addKeyFrameButton.top
                        left: preKeyFrameButton.right
                        leftMargin: 20
                        topMargin: 0
                    }
                    implicitWidth: 32
                    implicitHeight: 32

                    //enabled: enableKeyFrameCheckBox.checked && filter.bHasNextKeyFrame(timeline.getPositionInCurrentClip())
                    opacity: enabled ? 1.0 : 0.5
                    tooltip: qsTr('Next key frame')
                    //customIconSource: 'qrc:///icons/light/32x32/bg.png'
                    customIconSource: enabled?'qrc:///icons/light/32x32/next_keyframe.png':'qrc:///icons/light/32x32/next_keyframe_disable.png'
                    //customText: qsTr('>>')
                    buttonWidth : 85
                    onClicked: {
                        var nFrame = filter.getNextKeyFrameNum(timeline.getPositionInCurrentClip())
                        if(nFrame != -1)
                        {
                            filterDock.position = nFrame
                            //frameChanged(nFrame)
                        }
                    }
                }
            }

        }
/*
    Label {
        text: qsTr('Key Frame :')
        Layout.alignment: Qt.AlignRight
        color: '#ffffff'
        anchors {
            left: parent.left
            leftMargin: 5
            bottom :addKeyFrameButton.bottom
            bottomMargin: 9
        }
    }

   

    CustomFilterButton {
        id:removeAllKeyFrameButton
        anchors {
            top: addKeyFrameButton.top
            left: nextKeyFrameButton.right
            leftMargin: 30
            topMargin: 0
        }
        implicitWidth: 32
        implicitHeight: 32

        visible: false
        enabled: filter.bHasNextKeyFrame(timeline.getPositionInCurrentClip()) || filter.bHasNextKeyFrame(timeline.getPositionInCurrentClip())
        opacity: enabled ? 1.0 : 0.5
        tooltip: qsTr('Remove all key frame')
        customIconSource: 'qrc:///icons/light/32x32/bg.png'
        //customIconSource: enabled?'qrc:///icons/light/32x32/next_keyframe.png':'qrc:///icons/light/32x32/next_keyframe_disable.png'
        customText: qsTr('Remove all')
        buttonWidth : 100
        onClicked: {
            removeAllKeyFrame()
        }
    }
    
*/
}
