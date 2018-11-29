
import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    //property int stepSize: 34
    property real startX: 0
    property real timeScale: 1.0

    property real frames: profile.fps

    property real minimalStepSize: 25   //50 // 太小了刷新比较卡
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
                height: (Math.round(( startX + markStartX + index * stepSize * stepRatio) / (stepSize * stepRatio)) % timecodeInterval)? ((Math.round(( startX + markStartX + index * stepSize * stepRatio) / (stepSize * stepRatio)) % 2) ? 3 : 7) : 14
                width: 1
                color: "#515151"    // activePalette.windowText//'#707070'//activePalette.windowText
                x: markStartX + index * stepSize * stepRatio//index * frames * timeScale * factor/interval // index * stepSize
            }

            Label {
                anchors.top: parent.top
                anchors.topMargin: 5
                color: "#d1d1d1"    // activePalette.windowText
                x: markStartX + index * stepSize * stepRatio + 2
                // text: timeline.timecode(Math.round((startX + markStartX + index * stepSize * stepRatio) / timeScale))    // timeline.timecode(index * stepSize * 4 / timeScale)
                // 只有显示出来的才转换
                text: {
                    if(visible==true){
                        convertTimeValue(timeline.timecode(Math.round((startX + markStartX + index * stepSize * stepRatio) / timeScale)))
                    }
                }
                font.pointSize: 7.5
                visible: (Math.round(( startX + markStartX + index * stepSize * stepRatio) / (stepSize * stepRatio)) % timecodeInterval) == 0
            }

            // 把帧数不为 0的强制显示成 0
            function convertTimeValue(str){
                if(Math.floor(frames)==frames){
                    return str;
                }
                var len = str.length;
                var sub_frames = str.substr(len-2);
                if(sub_frames == "00"){
                    return str;
                }
                var num_sub_frames = Number(sub_frames);
                if(num_sub_frames>0 && num_sub_frames<frames/2){
                    return str.substring(0, len-2) + "00";
                }
                if(/*num_sub_frames<=Math.floor(frames) && */num_sub_frames>=frames/2 && sub_frames!=="00"){
                    sub_frames = "00";
                    var sub_second = str.substr(len-5, 2);
                    sub_second = Number(sub_second) + 1;
                    sub_second = Number(sub_second<10) ? "0"+sub_second : sub_second;
                    if(sub_second == "60"){
                        sub_second = "00";
                        var sub_minute = str.substr(len-8, 2);
                        sub_minute = Number(sub_minute) + 1;
                        sub_minute = Number(sub_minute)<10 ? "0"+sub_minute : sub_minute;
                        if(sub_minute == "60"){
                            sub_minute = "00";
                            var sub_hour = str.substring(0, str.indexOf(":"));
                            sub_hour = Number(sub_hour) + 1;
                            sub_hour = Number(sub_hour)<10 ? "0"+sub_hour : sub_hour;
                            return str.indexOf(";")>0 ? (sub_hour+":"+sub_minute+":"+sub_second+";"+sub_frames) : (sub_hour+":"+sub_minute+":"+sub_second+":"+sub_frames);
                        }
                        return str.indexOf(";")>0 ? (str.substring(0, len-8)+sub_minute+":"+sub_second+";"+sub_frames) : (str.substring(0, len-8)+":"+sub_minute+":"+sub_second+":"+sub_frames);
                    }
                    return str.indexOf(";")>0 ? (str.substring(0, len-5)+sub_second+";"+sub_frames) : (str.substring(0, len-5)+sub_second+":"+sub_frames);
                }
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
        color: "#515151"    // activePalette.windowText//'#707070'//activePalette.windowText
    }
}
