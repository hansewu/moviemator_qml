import QtQuick 2.0

Rectangle{
    property int frameNumber
    //width: 12
    //height: 12
    color:'red'

    MouseArea {
        id:keyFrameMouseArea
        anchors.fill: parent
        enabled: true
        hoverEnabled: true
        cursorShape: Qt.ArrowCursor
        acceptedButtons: Qt.LeftButton
        onClicked: timeline.seekToKeyFrame(frameNumber)
    }

    SequentialAnimation on scale {
        loops: 1//Animation.Infinite
        running: keyFrameMouseArea.containsMouse
        NumberAnimation {
            from: 1.0
            to: 1.2
            duration: 250
            easing.type: Easing.InOutQuad
        }
//        NumberAnimation {
//            from: 1.5
//            to: 1.0
//            duration: 250
//            easing.type: Easing.InOutQuad
//        }
    }

    SequentialAnimation on scale {
        loops: 1//Animation.Infinite
        running: !keyFrameMouseArea.containsMouse
        NumberAnimation {
            from: 1.2
            to: 1.0
            duration: 250
            easing.type: Easing.InOutQuad
        }
    }
}
