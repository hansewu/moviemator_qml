import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import MovieMator.Controls 1.0

Rectangle {
    id:keyFrame

    color: '#353535'//activePalette.window
    width: 400
    height: 32

    signal addFrameChanged()
    signal frameChanged(double keyFrameNum)
    signal removeKeyFrame()
    signal removeAllKeyFrame()

    // function setKeyFrameValue()
    // {
    //     var position = timeline.getPositionInCurrentClip()
    //     if (position < 0) return

    //     var paramCount = metadata.keyframes.parameterCount
    //     for(var i = 0; i < paramCount; i++)
    //     {
    //         var key = metadata.keyframes.parameters[i].property
    //         var value = filter.get(key)
            
    //         console.log("key: ")
    //         console.log(key)
    //         console.log("value: ")
    //         console.log(value)
            
            

    //         if (filter.getKeyFrameNumber() <= 0)
    //         {
    //             var position2 = filter.producerOut - filter.producerIn + 1 - 5
    //             filter.setKeyFrameParaValue(position2, key, value.toString() );

    //             filter.setKeyFrameParaValue(0, key, value.toString() );
    //         }

    //         filter.setKeyFrameParaValue(position, key, value.toString() );

    //         filter.combineAllKeyFramePara();
    //     }

    //  }

    Connections {
        target: filterDock
        onPositionChanged: {
             preKeyFrameButton.enabled      = filter.bHasPreKeyFrame(timeline.getPositionInCurrentClip())
             nextKeyFrameButton.enabled     = filter.bHasNextKeyFrame(timeline.getPositionInCurrentClip())
            //  removeKeyFrameButton.enabled   = filter.bKeyFrame(timeline.getPositionInCurrentClip())
            removeAllKeyFrameButton.enabled = filter.bHasPreKeyFrame(timeline.getPositionInCurrentClip()) || filter.bHasNextKeyFrame(timeline.getPositionInCurrentClip())
             var position = timeline.getPositionInCurrentClip()
             frameChanged(position)
        }
    }

    CustomFilterButton {
        id:addKeyFrameButton
        anchors {
            top: parent.bottom - addKeyFrameButton.height
            left: parent.left
            leftMargin: 30
            topMargin: 0
        }
        implicitWidth: 32
        implicitHeight: 32

        enabled: (metadata && (metadata.keyframes.parameterCount > 0)) ? true : false   //filter
        opacity: enabled ? 1.0 : 0.5
        tooltip: qsTr('Set as key frame')
        customIconSource: 'qrc:///icons/light/32x32/bg.png'
        customText: qsTr('Add keyframe')
        buttonWidth : 100
        onClicked: {
            addFrameChanged()
        }
        property bool change1;
        onEnabledChanged: {
            var position = timeline.getPositionInCurrentClip()
            preKeyFrameButton.enabled      = metadata && (metadata.keyframes.parameterCount > 0)
            nextKeyFrameButton.enabled     = metadata && (metadata.keyframes.parameterCount > 0)
            removeKeyFrameButton.enabled   = metadata && (metadata.keyframes.parameterCount > 0)
            removeAllKeyFrameButton.enabled= metadata && (metadata.keyframes.parameterCount > 0)
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
        enabled: true
        opacity: enabled ? 1.0 : 0.5
        tooltip: qsTr('Remove current frame')
        customIconSource: 'qrc:///icons/light/32x32/bg.png'
        //customIconSource: enabled?'qrc:///icons/light/32x32/next_keyframe.png':'qrc:///icons/light/32x32/next_keyframe_disable.png'
        customText: qsTr('Remove keyframe')
        buttonWidth : 120
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

        enabled: filter.bHasPreKeyFrame(timeline.getPositionInCurrentClip())
        opacity: enabled ? 1.0 : 0.5
        tooltip: qsTr('Prev key frame')
        customIconSource: 'qrc:///icons/light/32x32/bg.png'
        //customIconSource: enabled?'qrc:///icons/light/32x32/previous_keyframe.png' :'qrc:///icons/light/32x32/previous_keyframe_disable.png'
        customText: qsTr('Pre keyframe')
        buttonWidth : 100
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
            leftMargin: 0
            topMargin: 0
        }
        implicitWidth: 32
        implicitHeight: 32

        enabled: filter.bHasNextKeyFrame(timeline.getPositionInCurrentClip())
        opacity: enabled ? 1.0 : 0.5
        tooltip: qsTr('Next key frame')
        customIconSource: 'qrc:///icons/light/32x32/bg.png'
        //customIconSource: enabled?'qrc:///icons/light/32x32/next_keyframe.png':'qrc:///icons/light/32x32/next_keyframe_disable.png'
        customText: qsTr('Next keyframe')
        buttonWidth : 100
        onClicked: {
            var nFrame = filter.getNextKeyFrameNum(timeline.getPositionInCurrentClip())
            if(nFrame != -1)
            {
                filterDock.position = nFrame
                //frameChanged(nFrame)
            }
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
    



//    CustomFilterButton {
//        id:viewKeyFrameInfosButton
//        anchors {
//            top: addKeyFrameButton.top
//            left: addKeyFrameButton.right
//            leftMargin: 10
//            topMargin: 0
//        }
//        implicitWidth: 32
//        implicitHeight: 32

//        enabled: (metadata) ? true : false
//        opacity: enabled ? 1.0 : 0.5
//        tooltip: qsTr('View key frame infos')
//        customIconSource: 'qrc:///icons/light/32x32/list-add.png'
//        onClicked: {
//            keyFramesInfo.popup(viewKeyFrameInfosButton)
//        }
//    }
}
