/*
 * Copyright (c) 2013-2016 Meltytech, LLC
 * Author: Dan Dennedy <dan@dennedy.org>
 *
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: vgawen <gdb_1986@163.com>
 * Author: wyl <wyl@pylwyl.local>
 * Author: WanYuanCN <ebthon@hotmail.com>
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

import QtQuick 2.2
import QtQuick.Controls 1.0
import MovieMator.Controls 1.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.2
import QtQuick.Window 2.2
import 'Track.js' as Logic

Rectangle {
    id: clipRoot
    property string clipName: ''
    property string clipResource: ''
    property string mltService: ''
    property int inPoint: 0
    property int outPoint: 0
    property int clipDuration: 0
    property bool isBlank: false
    property bool isAudio: false
    property bool isTransition: false
    property bool isText: false
    property string textThumbnail: ''
    property var audioLevels
    property int fadeIn: 0
    property int fadeOut: 0
    property int trackIndex
    property int originalTrackIndex: trackIndex
    property int originalClipIndex: index
    property int originalX: x
    property bool selected: false
    property string hash: ''
    property double speed: 1.0
    property bool hasFilter: false
    property bool isAnimSticker: false


    signal clicked(var clip)
    signal moved(var clip)
    signal dragged(var clip, var mouse)
    signal clipdropped(var clip)
    signal draggedToTrack(var clip, int direction)
    signal trimmingIn(var clip, real delta, var mouse)
    signal trimmedIn(var clip)
    signal trimmingOut(var clip, real delta, var mouse)
    signal trimmedOut(var clip)

    SystemPalette { id: activePalette }
    gradient: Gradient {
        GradientStop {
            id: gradientStop
            position: 0.00
//            color: Qt.lighter(getColor())
            color: getColor()
        }
        GradientStop {
            id: gradientStop2
            position: 1.0
            color: getColor()
        }
    }


    border.color: selected? 'white' : backgroundColor // 'transparent'
    border.width: isBlank? 0 : selected ? 2 : 1
    clip: true
    Drag.active: mouseArea.drag.active
    Drag.proposedAction: Qt.MoveAction
    opacity: Drag.active? 0.5 : 1.0

    function getColor() {
//        return isBlank? 'transparent' : isTransition? 'mediumpurple' : isAudio? 'darkseagreen' : root.moviematorBlue
        // return isBlank? 'transparent' : isTransition? '#8c953f' : isAudio? '#2a5733' : '#2f798f'
        return isBlank? 'transparent' : isTransition? '#8c953f' : '#0F7267'
    }

    function getSelectedColor() {
        // return isBlank? 'transparent' : isTransition? '#8c953f': isAudio? '#419f51' : '#2eb9df'
        return isBlank? 'transparent' : isTransition? '#8c953f': '#C0482C'
    }

    function reparent(track) {
        Drag.active = false
        parent = track
        isAudio = track.isAudio
        height = track.height
     //   generateWaveform()
    }

    function cancelDrag() {
        Drag.active = false
    }

    function generateWaveform() {
        // This is needed to make the model have the correct count.
        // Model as a property expression is not working in all cases.
        waveformRepeater.model = Math.ceil(waveform.innerWidth / waveform.maxWidth)
//        for (var i = 0; i < waveformRepeater.count; i++)
            waveformRepeater.itemAt(0).update()
    }

    function imagePath(time) {
        if (isAudio || isBlank || isTransition) {
            return ''
        } else {
            return 'image://thumbnail/' + hash + '/' + mltService + '/' + clipResource + '#' + time
        }
    }

    onAudioLevelsChanged: generateWaveform()

    Image {
        id: outThumbnail
        visible: settings.timelineShowThumbnails
        anchors.right: parent.right
        anchors.top: parent.top
        //anchors.topMargin: parent.border.width
        //anchors.rightMargin: parent.border.width
        anchors.bottom: parent.bottom
        //anchors.bottomMargin: parent.border.width
        anchors.margins: 6
        width: height * 16.0/9.0
        fillMode: Image.PreserveAspectFit
        source: isText ? textThumbnail : imagePath(outPoint)
    }

    Image {
        id: inThumbnail
        visible: settings.timelineShowThumbnails
        anchors.left: parent.left
        anchors.top: parent.top
        //anchors.topMargin: parent.border.width
        //anchors.leftMargin: parent.border.width
        anchors.bottom: parent.bottom
        //anchors.bottomMargin: parent.border.width
        anchors.margins: 6
        width: height * 16.0/9.0
        fillMode: Image.PreserveAspectFit
        source: isText ? textThumbnail : imagePath(inPoint)
    }

    Image {
        id: centerThumbnail
        visible: settings.timelineShowThumbnails
        anchors.left: parent.left
        anchors.top: parent.top
        //anchors.topMargin: parent.border.width
        //anchors.leftMargin: parent.width/2 - width / 2

        anchors.bottom: parent.bottom
        //anchors.bottomMargin: parent.border.width
        anchors.margins: 6
        width: height * 16.0/9.0
        fillMode: Image.PreserveAspectFit
        source: isText ? textThumbnail : imagePath((outPoint+inPoint)/2)
    }

    TimelineTransition {
        visible: isTransition
        anchors.fill: parent
        property var color: '#c3c998'//isAudio? 'darkseagreen' : root.moviematorBlue
        colorA: color
        colorB: color//clipRoot.selected ? Qt.darker(color) : Qt.lighter(color)
    }

    Rectangle { // selected border
        z: 1
        visible: selected && !isBlank
        anchors.fill: parent
        color: 'transparent'
        border.width: 1     // 2
        border.color: '#DE9690'  // 'white'
    }

    Rectangle { // border
        z: 1
        visible: !selected && !isBlank
        anchors.fill: parent
        color: 'transparent'
        border.width: 1
        border.color: '#1A4540'     // backgroundColor
    }


    Row {
        id: waveform
        visible: !isBlank && settings.timelineShowWaveforms
        height: isAudio? parent.height : parent.height / 2
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: parent.border.width
        opacity: 0.7
        property int maxWidth: 10000
        property int innerWidth: clipRoot.width - clipRoot.border.width * 2

        Repeater {
            id: waveformRepeater
            TimelineWaveform {
                width: Math.min(waveform.innerWidth, waveform.maxWidth)
                height: waveform.height
                fillColor: getColor()
                property int channels: 2
                inPoint: Math.round((clipRoot.inPoint + index * waveform.maxWidth / timeScale) * speed) * channels
                outPoint: inPoint + Math.round(width / timeScale * speed) * channels
                levels: audioLevels
            }
        }
    }



//    Rectangle {
//        // audio peak line
//        width: parent.width - parent.border.width * 2
//        visible: !isBlank && !isTransition
//        height: 1
//        anchors.left: parent.left
//        anchors.bottom: parent.bottom
//        anchors.leftMargin: parent.border.width
//        anchors.bottomMargin: waveform.height * 0.9
//        color: Qt.darker(parent.color)
//        opacity: 0.7
//    }

//    Rectangle {
//        // text background
//        color: 'lightgray'
//        visible: !isBlank && !isTransition
//        opacity: 0.7
//        anchors.top: parent.top
//        anchors.left: parent.left
//        anchors.topMargin: parent.border.width
//        anchors.leftMargin: parent.border.width +
//            ((isAudio || !settings.timelineShowThumbnails) ? 0 : inThumbnail.width)
//        width: label.width + 2
//        height: label.height
//    }


//    Image {
//        id: fxIndicator
//        visible: hasFilter
//        anchors.left: parent.left
//        anchors.top: parent.top
//        anchors.topMargin: parent.border.width + 2
//        anchors.leftMargin: parent.border.width +
//                            ((isAudio || !settings.timelineShowThumbnails) ? 0 : inThumbnail.width) + 2

//        fillMode: Image.PreserveAspectFit
//        source: 'qrc:///icons/light/32x32/show-filters.png'
//    }

    Text {
        id: label
        text: clipName
        visible: !isBlank && !isTransition
        font.pointSize: 9       // 10
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.border.width + 2
            leftMargin: parent.border.width +
                ((isAudio || !settings.timelineShowThumbnails || isAnimSticker) ? 0 : inThumbnail.width) + 1
        }
        color: '#C7F3ED'    // 'black'
    }



    states: [
        State {
            name: 'normal'
            when: !clipRoot.selected
            PropertyChanges {
                target: clipRoot
                z: 0
            }
        },
        State {
            name: 'selectedBlank'
            when: clipRoot.selected && clipRoot.isBlank

        },
        State {
            name: 'selected'
            when: clipRoot.selected
            PropertyChanges {
                target: clipRoot
                z: 1
            }
            PropertyChanges {
                target: gradientStop
                color: getSelectedColor()
            }
            PropertyChanges {
                target: gradientStop2
                color: getSelectedColor()
            }
        }
    ]


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !isBlank
        acceptedButtons: Qt.LeftButton
        //propagateComposedEvents: true
        drag.target:isTransition ? NULL : parent
        drag.axis: Drag.XAxis
        property int startX
        onPressed: {
            //console.log("onPressed --- ")
            root.stopScrolling = true
            originalX = parent.x
            originalTrackIndex = trackIndex
            originalClipIndex = index
            startX = parent.x
            clipRoot.forceActiveFocus();
            clipRoot.clicked(clipRoot)

            //if (isTransition)
            //    menu.popup()
        }
        onPositionChanged: {
            if (!isTransition)
            {
                if (originalTrackIndex == trackIndex && originalClipIndex == index)
                    originalClipIndex = timeline.removeTransitionOnClipWithUndo(trackIndex, index)
                //console.log("clip onPositionChanged")
                if (mouse.y < 0 && trackIndex > 0)
                    parent.draggedToTrack(clipRoot, -1)
                else if (mouse.y > height && (trackIndex + 1) < root.trackCount)
                    parent.draggedToTrack(clipRoot, 1)
                parent.dragged(clipRoot, mouse)
            }
        }
        onReleased: {
            clipRoot.cancelDrag()
            root.stopScrolling = false
            if (!isTransition /*&& !isText*/)
            {
                parent.y = 0
                var delta = parent.x - startX
                if (Math.abs(delta) >= 1.0 || trackIndex !== originalTrackIndex) {
                    parent.moved(clipRoot)
                    originalX = parent.x
                    originalTrackIndex = trackIndex
                } else {
                    parent.clipdropped(clipRoot)
                }
            }

        }
        onDoubleClicked: timeline.position = clipRoot.x / multitrack.scaleFactor
        onClicked: mainwindow.setMultitrackAsCurrentProducer()
    }
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        propagateComposedEvents: true
        cursorShape: (trimInMouseArea.drag.active || trimOutMouseArea.drag.active)? Qt.SizeHorCursor :
//                (fadeInMouseArea.drag.active || fadeOutMouseArea.drag.active)? Qt.PointingHandCursor :
            drag.active? Qt.ClosedHandCursor :
            isBlank? Qt.ArrowCursor : Qt.OpenHandCursor
        onClicked: {
            if (!isBlank)
            {
                clipRoot.forceActiveFocus();
                clipRoot.clicked(clipRoot)
            }
            mainwindow.setMultitrackAsCurrentProducer()
            menu.popup()
        }
    }

    TimelineTriangle {
        id: fadeInTriangle
        visible: !isBlank && !isTransition
        width: parent.fadeIn * timeScale
        height: parent.height - parent.border.width * 2
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: parent.border.width
        opacity: 0.5
    }
//    Rectangle {
//        id: fadeInControl
//        enabled: !isBlank && !isTransition
//        anchors.left: fadeInTriangle.width > radius? undefined : fadeInTriangle.left
//        anchors.horizontalCenter: fadeInTriangle.width > radius? fadeInTriangle.right : undefined
//        anchors.top: fadeInTriangle.top
//        anchors.topMargin: -3
//        width: 15
//        height: 15
//        radius: 7.5
//        color: 'black'
//        border.width: 2
//        border.color: 'white'
//        opacity: 0
//        Drag.active: fadeInMouseArea.drag.active
//        MouseArea {
//            id: fadeInMouseArea
//            anchors.fill: parent
//            hoverEnabled: true
//            cursorShape: Qt.PointingHandCursor
//            drag.target: parent
//            drag.axis: Drag.XAxis
//            property int startX
//            property int startFadeIn
//            onEntered: parent.opacity = 0.7
//            onExited: parent.opacity = 0
//            onPressed: {
//                root.stopScrolling = true
//                startX = parent.x
//                startFadeIn = fadeIn
//                parent.anchors.left = undefined
//                parent.anchors.horizontalCenter = undefined
//                parent.opacity = 1
//                // trackRoot.clipSelected(clipRoot, trackRoot) TODO
//            }
//            onReleased: {
//                root.stopScrolling = false
//                if (fadeInTriangle.width > parent.radius)
//                    parent.anchors.horizontalCenter = fadeInTriangle.right
//                else
//                    parent.anchors.left = fadeInTriangle.left
//                bubbleHelp.hide()
//            }
//            onPositionChanged: {
//                if (mouse.buttons === Qt.LeftButton) {
//                    var delta = Math.round((parent.x - startX) / timeScale)
//                    var duration = startFadeIn + delta
//                    timeline.fadeIn(trackIndex, index, duration)

//                    // Show fade duration as time in a "bubble" help.
//                    var s = timeline.timecode(Math.max(duration, 0))
//                    bubbleHelp.show(clipRoot.x, trackRoot.y + clipRoot.height, s.substring(6))
//                }
//            }
//        }
//        SequentialAnimation on scale {
//            loops: Animation.Infinite
//            running: fadeInMouseArea.containsMouse
//            NumberAnimation {
//                from: 1.0
//                to: 0.5
//                duration: 250
//                easing.type: Easing.InOutQuad
//            }
//            NumberAnimation {
//                from: 0.5
//                to: 1.0
//                duration: 250
//                easing.type: Easing.InOutQuad
//            }
//        }
//    }

    TimelineTriangle {
        id: fadeOutCanvas
        visible: !isBlank && !isTransition
        width: parent.fadeOut * timeScale
        height: parent.height - parent.border.width * 2
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: parent.border.width
        opacity: 0.5
        transform: Scale { xScale: -1; origin.x: fadeOutCanvas.width / 2}
    }
//    Rectangle {
//        id: fadeOutControl
//        enabled: !isBlank && !isTransition
//        anchors.right: fadeOutCanvas.width > radius? undefined : fadeOutCanvas.right
//        anchors.horizontalCenter: fadeOutCanvas.width > radius? fadeOutCanvas.left : undefined
//        anchors.top: fadeOutCanvas.top
//        anchors.topMargin: -3
//        width: 15
//        height: 15
//        radius: 7.5
//        color: 'black'
//        border.width: 2
//        border.color: 'white'
//        opacity: 0
//        Drag.active: fadeOutMouseArea.drag.active
//        MouseArea {
//            id: fadeOutMouseArea
//            anchors.fill: parent
//            hoverEnabled: true
//            cursorShape: Qt.PointingHandCursor
//            drag.target: parent
//            drag.axis: Drag.XAxis
//            property int startX
//            property int startFadeOut
//            onEntered: parent.opacity = 0.7
//            onExited: parent.opacity = 0
//            onPressed: {
//                root.stopScrolling = true
//                startX = parent.x
//                startFadeOut = fadeOut
//                parent.anchors.right = undefined
//                parent.anchors.horizontalCenter = undefined
//                parent.opacity = 1
//            }
//            onReleased: {
//                root.stopScrolling = false
//                if (fadeOutCanvas.width > parent.radius)
//                    parent.anchors.horizontalCenter = fadeOutCanvas.left
//                else
//                    parent.anchors.right = fadeOutCanvas.right
//                bubbleHelp.hide()
//            }
//            onPositionChanged: {
//                if (mouse.buttons === Qt.LeftButton) {
//                    var delta = Math.round((startX - parent.x) / timeScale)
//                    var duration = startFadeOut + delta
//                    timeline.fadeOut(trackIndex, index, duration)

//                    // Show fade duration as time in a "bubble" help.
//                    var s = timeline.timecode(Math.max(duration, 0))
//                    bubbleHelp.show(clipRoot.x + clipRoot.width, trackRoot.y + clipRoot.height, s.substring(6))
//                }
//            }
//        }
//        SequentialAnimation on scale {
//            loops: Animation.Infinite
//            running: fadeOutMouseArea.containsMouse
//            NumberAnimation {
//                from: 1.0
//                to: 0.5
//                duration: 250
//                easing.type: Easing.InOutQuad
//            }
//            NumberAnimation {
//                from: 0.5
//                to: 1.0
//                duration: 250
//                easing.type: Easing.InOutQuad
//            }
//        }
//    }

    // Add -Start
    // 可以一直显示裁剪时候的红色边界
    // ①专门用来显示在左边裁剪的边界
    Rectangle {
        id: trimInBracket
        anchors.left: parent.left
        anchors.leftMargin: 0
        height: parent.height
        width: 5
        color: "red"
        visible: false
        
        Rectangle {
            id: trimInBracketTop
            anchors.top: parent.top
            anchors.left: parent.right
            height: parent.width
            width: parent.width
            color: parent.color
        }

        Rectangle {
            id: trimInBracketBottom
            anchors.bottom: parent.bottom
            anchors.left: parent.right
            height: parent.width
            width: parent.width
            color: parent.color
        }
    }

    function showTrimInBracket(){
        trimInBracket.visible = true
        trimInBracket.z = 1
        trimInBracketTop.z = 1
        trimInBracketBottom.z = 1
    }

    function hideTrimInBracket(){
        trimInBracket.visible = false
        trimInBracket.z = 0
        trimInBracketTop.z = 0
        trimInBracketBottom.z = 0
    }
    
    // ②专门用来显示在右边裁剪的边界
    Rectangle {
        id: trimOutBracket
        anchors.right: parent.right
        anchors.rightMargin: 0
        height: parent.height
        width: 5
        color: 'red'
        visible: false

        Rectangle {
            id: trimOutBracketTop
            anchors.top: parent.top
            anchors.right: parent.left
            height: parent.width
            width: parent.width
            color: parent.color
        }

        Rectangle {
            id: trimOutBracketBottom
            anchors.bottom: parent.bottom
            anchors.right: parent.left
            height: parent.width
            width: parent.width
            color: parent.color
        }
    }

    function showTrimOutBracket(){
        trimOutBracket.visible = true
        trimOutBracket.z = 1
        trimOutBracketTop.z = 1
        trimOutBracketBottom.z = 1
    }

    function hideTrimOutBracket(){
        trimOutBracket.visible = false
        trimOutBracket.z = 0
        trimOutBracketTop.z = 0
        trimOutBracketBottom.z = 0
    }
    // Add -End

    Rectangle {
        id: trimIn
        enabled: !isBlank && !isTransition
        anchors.left: parent.left
        anchors.leftMargin: 0
        height: parent.height
        width: 5
        // color: isAudio? 'green' : 'lawngreen'
        opacity: 0
        Drag.active: trimInMouseArea.drag.active
        Drag.proposedAction: Qt.MoveAction

        MouseArea {
            id: trimInMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.SizeHorCursor
            drag.target: parent
            drag.axis: Drag.XAxis
            property double startX

            onPressed: {
                root.stopScrolling = true
                startX = mapToItem(null, x, y).x
                originalX = 0 // reusing originalX to accumulate delta for bubble help
                parent.anchors.left = undefined
                
                // Add 显示边界框
                showTrimInBracket()
            }
            onReleased: {
                root.stopScrolling = false
                parent.anchors.left = clipRoot.left
                clipRoot.trimmedIn(clipRoot)
                parent.opacity = 0

                // Add 隐藏边界框
                hideTrimInBracket()
            }
            onPositionChanged: {
                if (mouse.buttons === Qt.LeftButton) {
                    // Add 显示边界框
                    showTrimInBracket()

                    var newX = mapToItem(null, x, y).x
                    var delta = Math.round((newX - startX) / timeScale)

                    if (Math.abs(delta) > 0) {
                        if (clipDuration + originalX + delta > 0)
                            originalX += delta
                        clipRoot.trimmingIn(clipRoot, delta, mouse)
                        if (Logic.snapTrimIn(clipRoot, delta) != 0)
                            startX = newX
                    }
                }
            }
            onEntered: showTrimInBracket()  // parent.opacity = 0.5
            onExited: hideTrimInBracket()   // parent.opacity = 0
        }
    }

    Rectangle {
        id: trimOut
        enabled: !isBlank && !isTransition
        anchors.right: parent.right
        anchors.rightMargin: 0
        height: parent.height
        width: 5
        // color: 'red'
        opacity: 0
        Drag.active: trimOutMouseArea.drag.active
        Drag.proposedAction: Qt.MoveAction

        MouseArea {
            id: trimOutMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.SizeHorCursor
            drag.target: parent
            drag.axis: Drag.XAxis
            property int duration

            onPressed: {
                root.stopScrolling = true
                duration = clipDuration
                originalX = 0 // reusing originalX to accumulate delta for bubble help
                parent.anchors.right = undefined

                // Add 显示边界框
                showTrimOutBracket()
            }
            onReleased: {
                root.stopScrolling = false
                parent.anchors.right = clipRoot.right
                clipRoot.trimmedOut(clipRoot)

                // Add 隐藏边界框
                hideTrimOutBracket()
            }
            onPositionChanged: {
                if (mouse.buttons === Qt.LeftButton) {
                    // Add 显示边界框
                    showTrimOutBracket()

                    var newDuration = Math.round((parent.x + parent.width) / timeScale)
                    var delta = duration - newDuration
                    if (Math.abs(delta) > 0) {
                        if (clipDuration - originalX - delta > 0)
                            originalX += delta
                        clipRoot.trimmingOut(clipRoot, delta, mouse)
                        duration = newDuration
                    }
                }
            }
            onEntered: showTrimOutBracket() // parent.opacity = 0.5
            onExited: hideTrimOutBracket()  // parent.opacity = 0
        }
    }

    Rectangle {
        id :showFilter
        visible: !isBlank && hasFilter
        height: 20
        width: 20
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: parent.border.width
        opacity: 0.6
        color: 'black'
        radius: 3

        Image {
            id: filterImage
            source: 'qrc:///icons/light/32x32/show-filters.png'
            height:1
            z:1
            anchors.fill: parent
        }

    }

    Rectangle {
        visible: !isBlank && selected && currentFilter && currentFilter.keyframeNumber > 0
        height: parent.height / 2
        width: parent.width
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: parent.border.width
        opacity: 0.7
        color: 'grey'


        //MouseArea {
        //    anchors.fill: parent
        //    acceptedButtons: Qt.LeftButton
        //}

        Repeater {
            id: keyFrameRepeater
            model: currentFilter ? currentFilter.keyframeNumber : 0
            anchors.verticalCenter: parent.verticalCenter


            KeyframeIndicator{
                height: parent.height / 2
                width: height
                anchors.verticalCenter: parent.verticalCenter
                visible: !isBlank && selected &&currentFilter && (currentFilter.getKeyFrame(index) != -1)
                x: (currentFilter?currentFilter.getKeyFrame(index):0) *multitrack.scaleFactor - width/2
                frameNumber: currentFilter ? currentFilter.getKeyFrame(index) : -1
                rotation: 45
            }
        }
    }

//    Connections{
//        target: currentFilter
//        onKeyFrameChanged:{
////            var  frameNumber = currentFilter.getKeyFrameNumber()
////            firstKeyFrameRect.visible = !isBlank && frameNumber
////            if(frameNumber)
////            {
////                console.log("Clip.qml onKeyFrameChanged is called, keyframe=")
////              //  firstKeyFrameRect.visible = !isBlank && frameNumber// This is available in all editors.
////                var frame = currentFilter.getFristKeyFrame()

////                firstKeyFrameRect.anchors.leftMargin = clipRoot.border.width+frame
////                console.log(firstKeyFrameRect.anchors.leftMargin);
////            }

//        }
//        onAddKeyFrame:{
//            var keyNumber = currentFilter.getKeyFrameNumber()
//            keyFrameRepeater.model = keyNumber
//        }

//        onRemoveKeyFrame:{
//            var keyNumber = currentFilter.getKeyFrameNumber()
//            keyFrameRepeater.model = keyNumber
//        }

//    }

    Menu {
        id: menu
//        MenuItem {
//            visible: !isTransition
//            text: qsTr('Remove')
//            onTriggered: timeline.remove(trackIndex, index)
//        }
        MenuItem {
            visible: !isBlank && !isTransition
            text: qsTr('Cut')
            onTriggered: {
                if (!trackRoot.isLocked) {
                    timeline.copyClip(trackIndex, index)
//                    timeline.remove(trackIndex, index)
                    timeline.lift(trackIndex, index)
                } else {
                    root.pulseLockButtonOnTrack(currentTrack)
                }
            }
        }
        MenuItem {
            visible: !isBlank && !isTransition
            text: qsTr('Copy')
            onTriggered: timeline.copyClip(trackIndex, index)
        }
        MenuSeparator {
            visible: !isBlank && !isTransition
        }
        MenuItem {
            visible: !isBlank && !isTransition
            text: qsTr('Remove')
            onTriggered: timeline.lift(trackIndex, index)
        }
        MenuItem {
            visible: !isTransition
            text: qsTr('Ripple Delete')
            onTriggered: timeline.remove(trackIndex, index)
        }

        MenuSeparator {
            visible: !isBlank && !isTransition
        }
        MenuItem {
            visible: !isBlank && !isTransition
            text: qsTr('Split At Playhead (S)')
            onTriggered: timeline.splitClip(trackIndex, index)
        }
        //MenuItem {
        //    visible: !isBlank && !isTransition
        //    text: qsTr('Rebuild Audio Waveform')
        //    onTriggered: timeline.remakeAudioLevels(trackIndex, index)
        //}
        //onPopupVisibleChanged: {
        //    if (visible && application.OS !== 'OS X' && __popupGeometry.height > 0) {
        //        // Try to fix menu running off screen. This only works intermittently.
        //        menu.__yOffset = Math.min(0, Screen.height - (__popupGeometry.y + __popupGeometry.height + 40))
        //        menu.__xOffset = Math.min(0, Screen.width - (__popupGeometry.x + __popupGeometry.width))
        //    }
        //}

        // 时间线工具转场属性改为转场设置
        MenuItem {
//            text: qsTr(!isTransition ? 'Properties' : 'Transition Settings')     // qsTr('Properties')
            text: !isTransition ? qsTr('Properties') : qsTr('Transition Settings')
            visible: !isText && !isBlank
            onTriggered:
                timeline.onShowProperties(trackIndex, index)

            }
        MenuItem {
            visible: isTransition
            text:qsTr('Remove')
            onTriggered: timeline.removeTransition(trackIndex, index)
        }


       MenuItem {
           visible: isText
            text:qsTr('Text Settings')
            onTriggered: timeline.onTextSettings(trackIndex, index)
       }

       MenuItem {
           visible: !isBlank && !isTransition
            text:qsTr('Export as template')
            onTriggered: timeline.exportAsTemplate(trackIndex, index)
       }

    }
}
