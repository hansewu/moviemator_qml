/*
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: wyl1987527 <wyl1987527@163.com>
 * Author: Author: fuyunhuaxin <2446010587@qq.com>
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
import QtQuick.Window 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import MovieMator.Controls 1.0
import QtQml 2.2
import 'translateTool.js' as Trans

Rectangle {
    id: root
    color: "transparent"
    property int repeaterItemWidth: 130
    property int repeaterItemHeight: 96
    property var currentChoosed : 0
    property bool translate2CH: ("简体中文" == Qt.locale().nativeLanguageName)
    
    function findFilterModel(name){
        for(var i=0;i<filtersInfoList.count;i++){
            if(name == filtersInfoList.get(i).name){
                return filtersInfoList.get(i)
            }
        }
        return null
    }

    function findFilterType(type){
        for(var i=0;i<catListAll.count;i++){
            if(type == catListAll.get(i).typename){
                return catListAll.get(i)
            }
        }
        return null
    }

    function addFilter(index){
        filtersResDock.addFilterItem(index)
    }

    function updateData()
    {
        var num = filtersInfo.rowCount();
       for(var i=0;i< filtersInfo.rowCount();i++){
            var filterInfo = {
                id: filtersInfo.get(i).name + '' + i,
                index : i,
                visible:filtersInfo.get(i).visible,
                name : filtersInfo.get(i).name,
                filterType : filtersInfo.get(i).filterType,
                imageSourcePath : filtersInfo.get(i).imageSourcePath,
            }
            filtersInfoList.append(filterInfo)
        }

        catList.clear()
        catListAll.clear()
        catListAll.append({"typename":qsTr('All')})
        for(var i=0;i<filtersInfoList.count;i++){
            if('' == filtersInfoList.get(i).filterType) continue;
            if(null == findFilterType(filtersInfoList.get(i).filterType)){
                catList.append({"typename":filtersInfoList.get(i).filterType})
                catListAll.append({"typename":filtersInfoList.get(i).filterType})
            }
        }
    }

    Component.onCompleted: {
        updateData()
    }

    ListModel{
        id:catList
        ListElement{
            typename:'A'
        }
    }
    ListModel{
        id:catListAll
        ListElement{
            typename:qsTr('All')
        }
    }

     ListModel{
        id:filtersInfoList
    }

    Component{
        id:delegate
        Rectangle{
            id:delegateRoot
            width: scrollView.width-20
            height: Math.ceil(filters.count / parseInt(width / repeaterItemWidth)) * repeaterItemHeight + filterhead.height + 10
            anchors{
                left:parent.left
                leftMargin:20
            }
            color: 'transparent'
            function refreshFilters(){
                filters.clear()
                for(var i=0;i<filtersInfoList.count;i++){
                    if(typename === filtersInfoList.get(i).filterType){
                        if(filtersInfoList.get(i).visible == false){
                            continue;
                        }
                        filters.append(filtersInfoList.get(i))
                    }
                }
            }
            Component.onCompleted: {
                refreshFilters()
                currentChoosed = filters.get(0).index
            }
            Rectangle{
                id:filterhead
                width: parent.width
                height: 28
                color: 'transparent'
                Text {
                    width: contentWidth
                    height: parent.height
                    id: catName
                    text: typename
                    color: '#ffffff'
                    font.pixelSize: 13
                    z:2
                    anchors{
                        left: parent.left
                        leftMargin: -10
                    }
                }
                Image {
                    id: line
                    source: 'qrc:///icons/light/32x32/line.png'
                    height:3
                    z:1
                    anchors{
                        left: catName.right
                        leftMargin:5
                        bottom: catName.bottom
                        bottomMargin:18
                    }
                }

            }
            Flow {
                id:itemFlow
                width: parent.width
                anchors{
                    top:filterhead.bottom
                }
                Repeater{
                    id:rep
                    model: ListModel{
                        id:filters
                    }

                    Rectangle{
                        width: repeaterItemWidth
                        height: repeaterItemHeight
                        color: 'transparent'

                        Button { 
                            width:20
                            height:20
                            z:2
                            anchors{
                                top:parent.top
                                topMargin:2
                                right:parent.right
                                rightMargin:22
                            }
                            // visible:id.checked ? true : false
                            visible:id.hoverStat ? true : (id.checked ? true : false)
                            checkable : true
                            onClicked:{
                                addFilter(index)
                            }
                            style: ButtonStyle { 
                                background:Rectangle{ 
                                    implicitHeight: parent.height 
                                    implicitWidth: parent.width 
                                    color: "transparent" 
                                    Image{ 
                                        anchors.fill: parent 
                                        source: control.hovered ? (control.pressed ? 'qrc:///icons/light/32x32/filter_add-a.png' : 'qrc:///icons/light/32x32/filter_add.png' ) : 'qrc:///icons/light/32x32/filter_add.png' ; 
                                    } 
                                } 
                            } 
                        }

                        Rectangle{
                            id:id
                            objectName:index
                            width: 110
                            height: 80
                            z:1
                            radius: 3 
                            color: checked ? '#C0482C':'#787878'
                            property bool checked: (objectName == currentChoosed)?true:false
                            property bool hoverStat:false
                            Image {
                                id: myIcon
                                anchors.horizontalCenter : parent.horizontalCenter
                                width: 106
                                height: 60
                                source: imageSourcePath
                                anchors {
                                    top: parent.top
                                    topMargin: 2
                                }
                            }
                            Text {
                                height: 20
                                anchors {
                                    top: myIcon.bottom
                                    topMargin: 3
                                    left: myIcon.left
                                    leftMargin: 5
                                    horizontalCenter: parent.horizontalLeft
                                }
                                text: translate2CH?Trans.transEn2Ch(name):name
                                color: '#ffffff'
                                font.pixelSize: 9
                            }
                            
                        }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            preventStealing:true
                            onClicked: {
                                currentChoosed = id.objectName
                            }
                            onDoubleClicked:{
                                currentChoosed = id.objectName
                                addFilter(index)
                            }
                            onEntered:{
                                id.hoverStat = true
                            }
                            onExited:{
                                if(!containsMouse){
                                    id.hoverStat = false
                                }

                            }
                        }
                    }

                }
            }
        }
    }

    Rectangle{ //头部
        id: filterHead
        width: parent.width
        height: 30
        z:3
        color: '#000000'
        Label{
            id: tabName
            width: 50
            height: parent.height
            anchors{
                horizontalCenter : parent.horizontalCenter
                verticalCenter : parent.verticalCenter
                top:parent.top
                topMargin: 7
            }
            text: qsTr('Filters')
            font.pixelSize: 12
            color: '#ffffff'
        }

        FilterComboBox {
            id:catCombox
            anchors{
                bottom: parent.bottom
                bottomMargin: 6
                right: parent.right
                rightMargin: 13
            }
            Component.onCompleted: {
                catCombox.setModel(catListAll)
            }
            onCatChanged:{
                if(index <= 0){
                    catList.clear()
                    for(var i=1;i<catListAll.count;i++){
                        catList.append(catListAll.get(i))
                    }
                }else{
                    var chosed = catListAll.get(index)
                    catList.clear()
                    catList.append(chosed)
                }
            }
        }
    }

    ScrollView{
        id: scrollView
        width: parent.width
        height: parent.height - filterHead.height
        anchors{
            top : filterHead.bottom
            topMargin: 10
        }
        style: ScrollViewStyle {
            transientScrollBars: false
            handle: Item {
                implicitWidth: 14
                implicitHeight: 14
                Rectangle {
                    color: "#787878"
                    anchors.fill: parent
                    anchors.margins: 3
                    radius: 4
                }
            }
            frame: Item {
                implicitWidth: 14
                implicitHeight: 14
                Rectangle {
                    color: "transparent"
                    anchors.fill: parent
                }
            }
            scrollBarBackground: Item {
                Rectangle {
                    color: "#323232"
                    anchors.fill: parent
                }
                implicitWidth: 14
                implicitHeight: 14
            }
            decrementControl: Rectangle {
                implicitWidth: 0
                implicitHeight: 0
            }
            incrementControl: Rectangle {
                implicitWidth: 0
                implicitHeight: 0
            }

        }
        ListView{ 
            width:parent.width;
            height:parent.height
            model:catList 
            delegate:delegate 
            focus:true 
        }
    }
}
