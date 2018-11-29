
import QtQuick 2.1
import MovieMator.Controls 1.0

Flickable {
    property string fillProperty: 'fill'
    property string rectProperty: 'geometry'
    property string halignProperty: 'valign'
    property string valignProperty: 'halign'
    property var _locale: Qt.locale(application.numericLocale)

    width: 300
    height: 250
    interactive: false
    clip: true
    property real zoom: (video.zoom > 0)? video.zoom : 1.0
    property rect filterRect
    contentWidth: video.rect.width * zoom
    contentHeight: video.rect.height * zoom
    contentX: video.offset.x
    contentY: video.offset.y

    function getAspectRatio() {
        return (filter.get(fillProperty) === '1')? filter.producerAspect : 0.0
    }

    function getAbsoluteRect(position) {
        var rect = filter.getRectOfTextFilter(rectProperty)
        if (position >= 0) {
            rect = filter.getAnimRectValue(position, rectProperty)
        }
        return Qt.rect(rect.x * profile.width, rect.y * profile.height, rect.width * profile.width, rect.height * profile.height)
    }

    function getRelativeRect(absoluteRect) {
        return Qt.rect(absoluteRect.x / profile.width, absoluteRect.y / profile.height, absoluteRect.width / profile.width, absoluteRect.height / profile.height)
    }

    Component.onCompleted: {

        //如果有关键帧就获取动画的位置
        var keyFrameCount = filter.getKeyFrameCountOnProject(rectProperty);
        if(keyFrameCount > 0)
        {

            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
                var nFrame = filter.getKeyFrameOnProjectOnIndex(index, rectProperty);
                var rect = filter.getAnimRectValue(index, rectProperty)
                filter.setKeyFrameParaRectValue(nFrame, rectProperty, rect, 1.0)

            }

            filterRect = getAbsoluteRect(0)

            filter.combineAllKeyFramePara();
       } else {

            filterRect = getAbsoluteRect(-1)
       }

        if (filter.isNew) {
            filter.set('size', filterRect.height)
        }
        rectangle.setHandles(filterRect)
    }

    MouseArea {
        anchors.fill: parent
        onClicked: textEdit.focus = false
    }
    DropArea { anchors.fill: parent }

    Item {
        id: videoItem
        x: video.rect.x
        y: video.rect.y
        width: video.rect.width
        height: video.rect.height
        scale: zoom

        Rectangle {
            visible: false // DISABLED FOR NOW
            anchors.fill: textEdit
            color: 'white'
            opacity: textEdit.opacity * 0.5
        }
        TextEdit {
            visible: false // DISABLED FOR NOW
            id: textEdit
            x: Math.round(filterRect.x * rectangle.widthScale) + rectangle.handleSize
            y: Math.round(filterRect.y * rectangle.heightScale) + rectangle.handleSize
            width: Math.round(filterRect.width * rectangle.widthScale) - 2 * rectangle.handleSize
            height: Math.round(filterRect.height * rectangle.heightScale) - 2 * rectangle.handleSize
            horizontalAlignment: (filter.get('halign') === 'left')? TextEdit.AlignLeft
                               : (filter.get('halign') === 'right')? TextEdit.AlignRight
                               : TextEdit.AlignHCenter
            verticalAlignment: (filter.get('valign') === 'top')? TextEdit.AlignTop
                             : (filter.get('valign') === 'bottom')? TextEdit.AlignBottom
                             : TextEdit.AlignVCenter
            text: filter.get('argument')
            font.family: filter.get('family')
            font.pixelSize: 24 //0.85 * height / text.split("\n").length
            textMargin: filter.get('pad')
            opacity: activeFocus
            onActiveFocusChanged: filter.set('disable', activeFocus)
            onTextChanged: filter.set('argument', text)
        }

        RectangleControl {
            id: rectangle
            widthScale: video.rect.width / profile.width
            heightScale: video.rect.height / profile.height
            aspectRatio: getAspectRatio()
            handleSize: Math.max(Math.round(8 / zoom), 4)
            borderSize: Math.max(Math.round(1.33 / zoom), 1)
            onWidthScaleChanged: {
                var position        = timeline.getPositionInCurrentClip()
                var bKeyFrame       = filter.bKeyFrame(position)
                if (bKeyFrame) {
                    setHandles(getAbsoluteRect(position))
                } else {
                    setHandles(getAbsoluteRect(-1))
                }
            }
            onHeightScaleChanged: {
                var position        = timeline.getPositionInCurrentClip()
                var bKeyFrame       = filter.bKeyFrame(position)
                if (bKeyFrame) {
                    setHandles(getAbsoluteRect(position))
                } else {
                    setHandles(getAbsoluteRect(-1))
                }
            }
            onRectChanged:  {
                filterRect.x = Math.round(rect.x / rectangle.widthScale)
                filterRect.y = Math.round(rect.y / rectangle.heightScale)
                filterRect.width = Math.round(rect.width / rectangle.widthScale)
                filterRect.height = Math.round(rect.height / rectangle.heightScale)
                var position        = timeline.getPositionInCurrentClip()
                var bKeyFrame       = filter.bKeyFrame(position)
                if (bKeyFrame)
                {
                    filter.setKeyFrameParaRectValue(position, rectProperty, getRelativeRect(filterRect), 1.0)
                    filter.combineAllKeyFramePara();
                } else {
                    var keyFrameCount = filter.getKeyFrameCountOnProject(rectProperty);
                    if (keyFrameCount <= 0) {
                        filter.set(rectProperty, getRelativeRect(filterRect))
                    }
                }
                filter.set('size', filterRect.height)
            }
        }
    }

    Connections {
        target: filter
        onChanged: {
            var position        = timeline.getPositionInCurrentClip()
            var newRect         = getAbsoluteRect(-1)
            var keyFrameCount   = filter.getKeyFrameCountOnProject(rectProperty);
            //判断是否有关键帧
            if(keyFrameCount > 0) {
                newRect = getAbsoluteRect(position)
            }

            if (filterRect !== newRect) {
                filterRect = newRect
                rectangle.setHandles(filterRect)
                filter.set('size', filterRect.height)
            }
            if (rectangle.aspectRatio !== getAspectRatio()) {
                rectangle.aspectRatio = getAspectRatio()
                rectangle.setHandles(filterRect)
                var rect = rectangle.rectangle

                var position        = timeline.getPositionInCurrentClip()
                var bKeyFrame       = filter.bKeyFrame(position)
                if (bKeyFrame)
                {
                    filter.setKeyFrameParaRectValue(position, rectProperty, getRelativeRect(rect), 1.0)
                    filter.combineAllKeyFramePara();
                } else {
                    filter.set(rectProperty, getRelativeRect(rect))
                }
            }
        }
    }
}
