
import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    //property int stepSize: 34
    property real startX: 0
    property real timeScale: 1.0

    property real frames: profile.fps

    property real minimalStepSize: 50 // 太小了刷新比较卡
    property real stepSize: frames * timeScale
    property real ratio: stepSize / minimalStepSize
    //刻度分割和合并因子：缩放时刻度宽度会变化，刻度太窄合并，刻度太宽分割刻度。。。1/8、1/4、1/2、1、2、4、8。。。
    property real stepRatio: 1 / Math.pow(2, Math.floor(Math.log(ratio) / Math.LN2)) //负数的向下取整可能有问题
    //开始画刻度的位置
    property real markStartX: Math.ceil(startX / (stepSize*stepRatio)) * (stepSize*stepRatio) - startX


    //显示长刻度的间隔
    property int interval: 4
    //显示时间的间隔
    property real timecodeInterval: 1/stepRatio > 4 ? Math.round(1/stepRatio) : 4

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
                // x: markStartX + index * stepSize * stepRatio//index * frames * timeScale * factor/interval // index * stepSize
                x: markStartX + index * stepSize * stepRatio + convertTimeValue() - Math.round((startX + markStartX + index * stepSize * stepRatio) / timeScale)
            }

            Label {
                color: activePalette.windowText
                x: markStartX + index * stepSize * stepRatio + 2
                // text: timeline.timecode(Math.round((startX + markStartX + index * stepSize * stepRatio) / timeScale))    // timeline.timecode(index * stepSize * 4 / timeScale)
                text: timeline.timecode(convertTimeValue())
                font.pointSize: 7.5
                visible: (Math.round(( startX + markStartX + index * stepSize * stepRatio) / (stepSize * stepRatio)) % timecodeInterval) == 0
            }

            // 特殊处理下帧数显示不为 0的情况：
            // 差几帧的补上，多几帧的去掉；
            function convertTimeValue(){
                if(Math.floor(frames)==frames){
                    return Math.round((startX + markStartX + index * stepSize * stepRatio) / timeScale);
                }
                var timeValue = Math.round((startX + markStartX + index * stepSize * stepRatio) / timeScale);
                var str = timeline.timecode(timeValue);
                var ends = str.substring(str.length-2);
                if(Number(ends)>frames/2){
                    return timeValue + Math.ceil(frames) - Number(ends);
                }
                return timeValue - Number(ends);
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
