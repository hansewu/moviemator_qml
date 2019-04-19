/*
 * Copyright (c) 2014 Meltytech, LLC
 * Author: Brian Matherly <code@brianmatherly.com>
 *
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: vgawen <gdb_1986@163.com>
 *
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: wyl <wyl@pylwyl.local>
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

import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQml.Models 2.1
import QtQuick.Controls.Styles 1.4
import MovieMator.Controls 1.0
import QtQml 2.2
import QtQuick.Layouts 1.1
import com.moviemator.qml 1.0 as MovieMator
import 'translateTool.js' as Trans
Rectangle {
    id: attachedFilters
    color: '#353535'
    signal filterClicked(int index)
    property var oldVideoId:''
    property var oldAudioId:''
    property bool draged: false
    property bool translate2CH: ("zh_CN" == Qt.locale().name)
    // property bool translate2CH: false
   
    property var filterType: qsTr("Video")
    property var videoType: qsTr("Video")
    property var audioType: qsTr("Audio")
    SystemPalette { id: activePalette }

    Timer {
        id: indexDelay
        property int index: 0
        interval: 100
        onTriggered: {
            // Delay the index setting to allow model updates to complete
            attachedFiltersView.currentIndex = index
        }
    }
    function setCurrentFilter(index) {
        return
    }
    //只用于模板clip被选中时被调用
    Connections {
        target: timeline
        onSizeAndPositionFilterSelected: {
            attachedFiltersView.currentIndex = index
            filterClicked(index)
            // setCurrentFilter(index)
            indexDelay.index = index
            indexDelay.running = true
        }
    }
    Connections { 
        target: attachedfiltersmodel
        onIsProducerSelectedChanged: {
            if(updateModelData() == 0){
                chooseFilter(0)
            }
        }
    }

    function updateModelData(){
        if((typeof attachedfiltersmodel != 'undefined')&&(attachedfiltersmodel != null)&&(typeof attachedfiltersmodel.rowCount() != 'undefined')){
            var filtersNumber = visualModel0.items.count
            if(filtersNumber >= 0){
                videoFiltersList.clear()
                audioFiltersList.clear()
                var filtersMap = {}
                for(var i=0;i<filtersNumber;i++){
                    var item = visualModel0.items.get(i).model
                    var id = ''
                    var num = filtersMap[item.display]
                    if(num == undefined){
                        id = item.display + '1'
                        filtersMap[item.display] = 1
                    }else{
                        id = item.display + (num+1).toString()
                        filtersMap[item.display] = num+1
                    }
                    var item = {
                        id:id,
                        modelIndex: i,
                        display:item.display,
                        checkState:item.checkState,
                        thumbnail:item.thumbnail,
                        typeDisplay:item.typeDisplay
                    }
                    if(attachedfiltersmodel.isVisible(i)){
                        videoFiltersList.append(item)
                    }else{
                        audioFiltersList.append(item)
                    }
                }
                return 0
            }
        }
        return -1
    }
    function removeFilter(index){
        var modelIndex = getModelIndex(index)
        if(modelIndex < 0){
            return
        }
        attachedFiltersView.model.model.remove(index)
        dataView.model.model.remove(modelIndex)
    }
    function changeOrder(sourceIndex,destinationIndex){
        sourceIndex = getModelIndex(sourceIndex)
        destinationIndex = getModelIndex(destinationIndex)
        if((sourceIndex < 0)||(destinationIndex < 0)){
            return
        }
        attachedfiltersmodel.move(sourceIndex, destinationIndex)
    }
    function switchFilterType(filtertype){
        filterType = filtertype
        chooseFilter(getCurrentFilterIndex())
    }
    function findFilterIndex(id,list){
        var rt = 0
        for(var i=0;i<list.count;i++){
            if(id == list.get(i).id){
                rt = i
                break;
            }
        }
        return rt
    }
    function getCurrentFilterIndex(){
        var rt
        if(filterType == videoType){
            rt = findFilterIndex(oldVideoId,videoFiltersList)
        }else{
            rt = findFilterIndex(oldAudioId,audioFiltersList)
        }
        return rt
    }
    function getModelIndex(index){
        var modelIndex = -1
        if(filterType == videoType){
            if((videoFiltersList.count <= 0)||(index >= videoFiltersList.count)){
                throw new Error("chosed filter index error:"+ index + ' '+videoFiltersList.count) 
                return modelIndex
            }
            modelIndex = videoFiltersList.get(index).modelIndex
        }else{
            if((audioFiltersList.count <= 0)||(index >= audioFiltersList.count)){
                throw new Error("chosed filter index error:"+ index + ' '+audioFiltersList.count) 
                return modelIndex
            }
            modelIndex = audioFiltersList.get(index).modelIndex
        }
        return modelIndex
    }
    function switchFilterChecked(index){
        chooseFilter(index)
        dataView.currentIndex = getModelIndex(index)
        dataView.currentItem.mymodel.checkState = false
    }
    function chooseFilter(index){
        attachedFiltersView.currentIndex = index
        if(filterType == videoType){
            if((videoFiltersList.count <= 0)||(index >= videoFiltersList.count)){
                throw new Error("chosed filter index error:"+ index + ' '+videoFiltersList.count) 
            }
            var modelIndex = videoFiltersList.get(index).modelIndex
            filterClicked(modelIndex)
            oldVideoId = videoFiltersList.get(index).id
        }else{
            if((audioFiltersList.count <= 0)||(index >= audioFiltersList.count)){
                throw new Error("chosed filter index error:"+ index + ' '+audioFiltersList.count) 
            }
            var modelIndex = audioFiltersList.get(index).modelIndex
            filterClicked(modelIndex)
            oldAudioId = audioFiltersList.get(index).id
        }
    }
    
    GridView {
        id: dataView
        visible:false
        property var oldCount:0
        model: DelegateModel {
            id: visualModel0
            model:attachedfiltersmodel
            delegate: Rectangle{
                id:visualItem
                property variant mymodel: model
            }
        }
    }
    Connections { 
        target: visualModel0.items
        onChanged: {
            if(draged) return
            for(var i=0;i < inserted.length;i++){
                var index = inserted[i].index
                updateModelData()
                if(attachedfiltersmodel.isVisible(index)){
                    filterType = videoType
                }else{
                    filterType = audioType
                    index = index - videoFiltersList.count
                }
                chooseFilter(index)
            }
            for(var j=0;j<removed.length;j++){
                var index = removed[i].index
                if(filterType == audioType)
                    index = index - videoFiltersList.count
                updateModelData()
                if(index == attachedFiltersView.currentIndex){
                    if(visualModel.model.count > 0){
                        if(index >= visualModel.model.count)
                            chooseFilter(index-1)
                        else
                            chooseFilter(index)
                    }else{
                        switchFilterType((filterType==videoType)?audioType:videoType)
                    }
                }else{
                    chooseFilter(getCurrentFilterIndex())
                }
            }
        }
    }

    Rectangle{
        id:videoBtnBack
        color: 'transparent'
        z:4
        width:50
        height:28
        //radius: 4
        anchors{
            bottom:parent.top
            topMargin:0
            left:parent.left
            leftMargin:-2
        }
        Button{
            id: chooseVideoFilter
            width:parent.width
            height:parent.height - 1
            z:5
            anchors{
                left:parent.left
                leftMargin:0
                bottom:parent.bottom
                bottomMargin:-1
            }
            Text{
                text:qsTr("Video")
                color: chooseVideoFilter.checked ? activePalette.highlight : 'white'
                anchors.centerIn: parent
            }
            checked:filterType == videoType
            style: ButtonStyle {
                background: Rectangle {
                    color:'transparent'
                    Image{
                        anchors.centerIn: parent
                        width:parent.width
                        height:parent.height-4
                        source:chooseVideoFilter.checked ? 'qrc:///icons/filters/icon/tab_btn-a.png' : 'qrc:///icons/filters/icon/tab_btn.png'
                    }
                }
            }
            onClicked:{
                switchFilterType(videoType)
            }
        }
    }
    Rectangle{
        color: 'transparent'
        z:4
        width:50
        height:28
        anchors{
            bottom:videoBtnBack.bottom
            left:videoBtnBack.right
        }
        Button{
            id: chooseAudioFilter
            width:parent.width - 4
            height:parent.height - 1
            z:5
            anchors{
                left:parent.left
                leftMargin:-1
                bottom:parent.bottom
                bottomMargin:-1
            }
            Text{
                text:qsTr("Audio")
                color: chooseAudioFilter.checked ? activePalette.highlight : 'white'
                anchors.centerIn: parent
            }
            checked:filterType == audioType
            style: ButtonStyle {
                background: Rectangle {
                    color:'transparent'
                    Image{
                        anchors.centerIn: parent
                        width:parent.width
                        height:parent.height-4
                        source:chooseAudioFilter.checked ? 'qrc:///icons/filters/icon/tab_btn-a.png' : 'qrc:///icons/filters/icon/tab_btn.png'
                    }
                }
            }
            onClicked:{
                switchFilterType(audioType)
            }
        }
    }
    ListModel {
        id:videoFiltersList
    }
    ListModel {
        id:audioFiltersList
    }
    
    ScrollView {
        anchors.fill: parent
        style: ScrollViewStyle {
            transientScrollBars: false
            //  scrollToClickedPosition:true
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
            scrollBarBackground: Item {
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

        GridView {
            id: attachedFiltersView
            anchors.fill: parent
            cellHeight:82
            cellWidth:85
            flow:GridView.FlowTopToBottom
            displaced: Transition {
                NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
            }
            model: DelegateModel {
                id: visualModel
                model: (filterType == qsTr("Video"))?videoFiltersList:audioFiltersList
                delegate: MouseArea {
                    id: delegateRoot
                    property int visualIndex: DelegateModel.itemsIndex
                    height: attachedFiltersView.cellHeight
                    width: attachedFiltersView.cellWidth
                    propagateComposedEvents:true
                    drag.target: icon
                    onClicked: {
                        chooseFilter(index)
                    }
                    onDoubleClicked: {
                        model.checkState = !(model.checkState)
                        switchFilterChecked(index)
                        setCurrentFilter(attachedFiltersView.currentIndex)
                    }
                    onReleased: {
                        if(draged){
                            updateModelData()
                            draged = false
                            chooseFilter(getCurrentFilterIndex())
                            
                        }
                    }
                    Rectangle {
                        id: icon
                        z:2
                        width: 80
                        height: 60
                        anchors {
                            horizontalCenter: parent.horizontalCenter;
                            verticalCenter: parent.verticalCenter
                        }
                        color: (attachedFiltersView.currentIndex == index)? activePalette.highlight :'#787878'
                        radius: 2
                        CheckBox {
                            id: filterDelegateCheck
                            z:4
                            anchors{
                                top:filterDelegateImage.top
                                topMargin:-2
                                left:filterDelegateImage.left
                                leftMargin:-2
                            }
                            checkedState: model.checkState
                            onClicked: {
                                model.checkState = !(model.checkState)
                                switchFilterChecked(index)
                            }
                            style: CheckBoxStyle {
                                indicator: Rectangle {
                                    color:'transparent'
                                    implicitWidth: 15
                                    implicitHeight: 15
                                    radius: 3
                                    border.width: 0
                                    Image {
                                        anchors.fill: parent
                                        source:(icon.color==activePalette.highlight) ? (filterDelegateCheck.checkedState ? 'qrc:///icons/filters/icon/filter_select2-a.png' : 'qrc:///icons/filters/icon/filter_select2.png') : (filterDelegateCheck.checkedState ? 'qrc:///icons/filters/icon/filter_select-a.png' : 'qrc:///icons/filters/icon/filter_select.png')
                                    }
                                }
                            }
                        }
                        Button {
                            id:filterDelegateDelete
                            anchors{
                                top:parent.top
                                right:parent.right
                            }
                            tooltip: qsTr('Remove selected filter')
                            z:4
                            width:15
                            height:15
                            style: ButtonStyle {
                                background: Rectangle {
                                    color:'transparent'
                                    anchors.fill: parent
                                    Image{
                                        anchors.fill: parent
                                        source: filterDelegateDelete.pressed ? 'qrc:///icons/filters/icon/filter_remove-on.png' : 'qrc:///icons/filters/icon/filter_remove.png'
                                    }
                                }
                            }
                            onClicked: {
                                removeFilter(index)
                            }
                        }
                        Label {
                            id:filterDelegateName
                            z:3
                            text: translate2CH?Trans.transEn2Ch(model.display):model.display
                            verticalAlignment:Text.AlignBottom
                            wrapMode: Text.Wrap
                            anchors.fill: parent
                            anchors.leftMargin:2
                        }
                        Image {
                            id:filterDelegateImage
                            z:2
                            source: model.thumbnail
                            width: 76
                            height: 40
                            anchors {
                                horizontalCenter: parent.horizontalCenter;
                                top:parent.top
                                topMargin:2
                            }
                        }

                        Drag.active: delegateRoot.drag.active
                        Drag.source: delegateRoot
                        Drag.hotSpot.x: 36
                        Drag.hotSpot.y: 36

                        states: [
                            State {
                                when: icon.Drag.active
                                ParentChange {
                                    target: icon
                                    parent: attachedFiltersView
                                }
                                AnchorChanges {
                                    target: icon;
                                    anchors.horizontalCenter: 'undefined';
                                    anchors.verticalCenter: 'undefined'
                                }
                            }
                        ]
                    }
                    DropArea {
                        anchors { fill: parent;margins: 15}
                        onEntered: {
                            visualModel.items.move(drag.source.visualIndex, delegateRoot.visualIndex)
                            changeOrder(drag.source.visualIndex, delegateRoot.visualIndex)
                            draged = true
                        }
                    }
                }
            }
        }
    }
    
}