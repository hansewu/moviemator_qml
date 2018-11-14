
import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    //property int stepSize: 34
    property real wholeWidth: 0
    property real startX: 0
    property real timeScale: 1.0

    
    // Add 每秒有24帧。
    property real frames: profile.fps




//    property real stepSize: wholeWidth /(frames * timeScale)
    property real minimalStepSize: 34
    property real stepSize: frames * timeScale
    property real ratio: stepSize / minimalStepSize
    property real stepRatio: 1 / Math.pow(2, Math.floor(Math.log(ratio) / Math.LN2))

//    property real stepSizeFactor:  Math.floor(ratio) >= 2 ? Math.floor(ratio) - Math.floor(ratio) % 2

    property real markStartX: Math.ceil(startX / (stepSize*stepRatio)) * (stepSize*stepRatio) - startX

    /*
     * Add 用来调整时间刻度每隔几个显示一个值；
     * 需要保证每4个刻度显示一个值；
     * 如果刻度很大，那么每1或2个刻度可以显示一个值；
     * 每3个刻度不显示值。
     */

    // Add 每个刻度值之间分成4份
    property int interval: 4
    property real timecodeInterval: 1/stepRatio > 4 ? Math.round(1/stepRatio) : 4


    property int factor: (Math.ceil(interval / timeScale) % interval == 0 ||
                          Math.ceil(interval / timeScale) <= 2) ?
                             Math.ceil(interval / timeScale) :
                             (Math.ceil(interval / timeScale) + interval -
                              Math.ceil(interval / timeScale) % interval)




    SystemPalette { id: activePalette }

    id: rulerTop
    enabled: false
    height: 24
    color: normalColor//activePalette.base

//    Rectangle {
//        width: timeline.timeToFrames("00:05:00:00")*timeScale * parent.width / parent.width > parent.width ? parent.width : timeline.timeToFrames("00:05:00:00")*timeScale * parent.width / parent.width
//        height: parent.height
//        anchors.left: parent.left
//        color:'seagreen'
//    }

    // model数量太多的话，Repeater会很卡，改用ListView
    /*
    Repeater {
        model: parent.width / stepSize
        Rectangle {
            anchors.bottom: rulerTop.bottom
            height: (index % 4)? ((index % 2) ? 3 : 7) : 14
            width: 1
            color: activePalette.windowText//'#707070'//activePalette.windowText
            x: index * stepSize
        }
    }
    Repeater {
        model: parent.width / stepSize / 4
        Label {
            anchors.bottom: rulerTop.bottom
            anchors.bottomMargin: 2
            color: activePalette.windowText
            x: index * stepSize * 4 + 2
            text: timeline.timecode(index * stepSize * 4 / timeScale)
            font.pointSize: 7.5
        }
    }
    */
    // 把 Repeater改成ListView
    ListView {
        anchors.fill: parent
        anchors.bottom: parent.bottom
        orientation: ListView.Horizontal
        clip: true

        model: parent.width / (stepSize * stepRatio) + 1    // parent.width / stepSize
        delegate: Item {
            height: parent.height
            //anchors.bottom: parent.bottom
            Rectangle {
                anchors.bottom: parent.bottom
                height: (Math.round(( startX + markStartX + index * stepSize * stepRatio) / (stepSize * stepRatio)) % interval)? ((Math.round(( startX + markStartX + index * stepSize * stepRatio) / (stepSize * stepRatio)) % 2) ? 3 : 7) : 14
                width: 1
                color: activePalette.windowText//'#707070'//activePalette.windowText
                x: markStartX + index * stepSize * stepRatio//index * frames * timeScale * factor/interval // index * stepSize
            }

            Label {
                color: activePalette.windowText
                x: markStartX + index * stepSize * stepRatio + 2
                text: timeline.timecode((startX + markStartX + index * stepSize * stepRatio) / timeScale)    // timeline.timecode(index * stepSize * 4 / timeScale)
                font.pointSize: 7.5
                visible: (Math.round(( startX + markStartX + index * stepSize * stepRatio) / (stepSize * stepRatio)) % timecodeInterval) == 0
            }
        }
    }

//    ListView {
//        anchors.fill: parent
//        anchors.topMargin: 2
//        orientation: ListView.Horizontal
//        clip: true

//        model: parent.width / (stepSize * stepRatio) / interval + 1//parent.width / frames / interval // parent.width / stepSize / 4
//        delegate: Item {
//            Label {
//                color: activePalette.windowText
//                x: markStartX + index * stepSize * stepRatio * 4 + 2
//                text: 'xxxxxx'//timeline.timecode(index * frames * factor)    // timeline.timecode(index * stepSize * 4 / timeScale)
//                font.pointSize: 7.5
//            }
//        }
//    }

    Rectangle {
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: activePalette.windowText//'#707070'//activePalette.windowText
    }
}
