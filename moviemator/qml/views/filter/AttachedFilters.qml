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
    property int oldIndexVideo:0
    property int oldIndexAudio:0
    property int oldFiltersNum:0
    property bool translate2CH: ("zh_CN" == Qt.locale().name)

    property var filterType: qsTr("Video")
    SystemPalette { id: activePalette }
    Timer {
        id: indexDelay
        property int index: 0
        interval: 1
        onTriggered: {
            // Delay the index setting to allow model updates to complete
            attachedFiltersView.currentIndex = index
            if(isFilterVisible(attachedFiltersView.currentIndex)){
                chooseAudioFilter.checked = false
                chooseVideoFilter.checked = true
                filterType = qsTr("Video")
                visualModel.filterOnGroup = "video"
            }else{
                chooseVideoFilter.checked = false
                chooseAudioFilter.checked = true
                filterType = qsTr("Audio")
                visualModel.filterOnGroup = "audio"
            }
        }
    }
    function setCurrentFilter(index) {
        indexDelay.index = index
        indexDelay.running = true
    }
    //只用于模板clip被选中时被调用
    Connections {
        target: timeline
        onSizeAndPositionFilterSelected: {
            attachedFiltersView.currentIndex = index
            showParamterSetting(index)
            setCurrentFilter(index)
        }
    }

    Connections { 
        target: attachedfiltersmodel
        onIsProducerSelectedChanged: {
            switchFilterType()
        }
    }
    function switchFilterType(){
        if(typeof attachedfiltersmodel == 'undefined'){
            throw new Error("attachedfiltersmodel is undefined")
        }

        attachedFilters.oldFiltersNum = attachedfiltersmodel.rowCount()
        refreshGridModel()
            if(chooseVideoFilter.checked && (visualModel.groups[3].count <= 0)){
                chooseVideoFilter.checked = false
                chooseAudioFilter.checked = true
                filterType = qsTr("Audio")
                visualModel.filterOnGroup = "audio"
                showParamterSetting(0)
            }else if(chooseAudioFilter.checked && (visualModel.groups[4].count <= 0)){
                chooseAudioFilter.checked = false
                chooseVideoFilter.checked = true
                filterType = qsTr("Video")
                visualModel.filterOnGroup = "video"
                showParamterSetting(0)
            }else{
                showParamterSetting(attachedFiltersView.currentIndex)
            }
    }

    function isFilterVisible(index){
        if(typeof attachedfiltersmodel == 'undefined'){
            throw new Error("attachedfiltersmodel is undefined")
        }
        var rt = false
        if(attachedfiltersmodel.rowCount() > 0){
            if((index >=0)&&(index < attachedfiltersmodel.rowCount())&&(attachedfiltersmodel.isVisible(index))){
                rt = true
            }
        }
        return rt
    }
    function refreshGridModel(){
        if(typeof attachedfiltersmodel == 'undefined'){
            throw new Error("attachedfiltersmodel is undefined")
        }
        if(visualModel.groups[3].count > 0)
            visualModel.groups[3].remove(0,visualModel.groups[3].count)
        if(visualModel.groups[4].count > 0)
            visualModel.groups[4].remove(0,visualModel.groups[4].count)
        for(var i=0;i<attachedfiltersmodel.rowCount();i++){
            if(isFilterVisible(i)){
                visualModel.items.addGroups(i,1,"video")
            }else{
                visualModel.items.addGroups(i,1,"audio")
            }
        }
        if(chooseVideoFilter.checked == true){
            attachedFiltersView.currentIndex = attachedFilters.oldIndexVideo
        }else{
            attachedFiltersView.currentIndex = attachedFilters.oldIndexAudio
        }
    }
    function showParamterSetting(index) {
        if((isFilterVisible(index) && chooseVideoFilter.checked) || (!isFilterVisible(index) && chooseAudioFilter.checked)){
            filterClicked(index)
        }
    }
    

    Connections {
        target: attachedfiltersmodel
        onChanged: {
            changeFilters()
        }
    }
    function changeFilters(){
        if(typeof attachedfiltersmodel == 'undefined'){
            throw new Error("attachedfiltersmodel is undefined")
        }
        attachedFilters.oldFiltersNum = attachedfiltersmodel.rowCount()
        if(attachedFilters.oldFiltersNum <= attachedfiltersmodel.rowCount() || attachedfiltersmodel.rowCount() == 0){
            if(attachedFiltersView.currentIndex < 0 || attachedFiltersView.currentIndex >= attachedfiltersmodel.rowCount()){
                return
            }
            if(chooseVideoFilter.checked == true){
                if(isFilterVisible(attachedFiltersView.currentIndex)){
                    attachedFilters.oldIndexVideo = attachedFiltersView.currentIndex
                    attachedFilters.oldIndexAudio++
                }else{
                    attachedFilters.oldIndexAudio = attachedFiltersView.currentIndex
                    chooseVideoFilter.checked = false
                    chooseAudioFilter.checked = true
                    filterType = qsTr("Audio")
                    visualModel.filterOnGroup = "audio"
                }
            }else{
                if(isFilterVisible(attachedFiltersView.currentIndex)){
                    chooseAudioFilter.checked = false
                    chooseVideoFilter.checked = true
                    filterType = qsTr("Video")
                    visualModel.filterOnGroup = "video"
                    attachedFilters.oldIndexVideo = attachedFiltersView.currentIndex
                    attachedFilters.oldIndexAudio++
                }else{
                    attachedFilters.oldIndexAudio = attachedFiltersView.currentIndex
                }
            }
            refreshGridModel()
        }else{
            showParamterSetting(attachedFiltersView.currentIndex)
        }
    }

    Rectangle{
        id:videoBtnBack
        color: 'transparent'
        //border.color: chooseVideoFilter.checked ? "black":'#353535'
        //border.width: 2
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
            checkable:true
            checked:true
            style: ButtonStyle {
                background: Rectangle {
                    color:'transparent'
                    //border.width: 2
                    //border.color: control.checked ? '#353535' : 'black'
                    Image{
                        anchors.centerIn: parent
                        width:parent.width
                        height:parent.height-4
                        source:chooseVideoFilter.checked ? 'qrc:///icons/filters/icon/tab_btn-a.png' : 'qrc:///icons/filters/icon/tab_btn.png'
                    }
                }
            }
            onClicked:{
                if(!checked) checked=true
                chooseAudioFilter.checked = false
                filterType = qsTr("Video")
                refreshGridModel()
                visualModel.filterOnGroup = "video"
                showParamterSetting(attachedFilters.oldIndexVideo)
            }
        }
    }
    Rectangle{
        color: 'transparent'
        //border.color: chooseAudioFilter.checked ? "black":'#353535'
        //border.width: 2
        z:4
        width:50
        height:28
        //radius: 4
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
            checkable:true
            checked:false
            style: ButtonStyle {
                background: Rectangle {
                    color:'transparent'
                    //border.width: 2
                    //border.color: control.checked ? '#353535' : 'black'
                    Image{
                        anchors.centerIn: parent
                        width:parent.width
                        height:parent.height-4
                        source:chooseAudioFilter.checked ? 'qrc:///icons/filters/icon/tab_btn-a.png' : 'qrc:///icons/filters/icon/tab_btn.png'
                    }
                }
            }
            onClicked:{
                if(!checked) checked=true
                chooseVideoFilter.checked = false
                filterType = qsTr("Audio")
                refreshGridModel()
                visualModel.filterOnGroup = "audio"
                showParamterSetting(attachedFilters.oldIndexAudio)
            }
        }
    }
    function filterItemChosed(index){
        if(visualModel.filterOnGroup == 'video'){
            attachedFilters.oldIndexVideo = index
        }else{
            attachedFilters.oldIndexAudio = index
        }
        showParamterSetting(index)
        attachedFiltersView.currentIndex = index
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
            property int dragTarget: -1
            property bool isReady:false
            property int preferIndex:0
            cellHeight:82
            cellWidth:85
            anchors.fill: parent
            flow:GridView.FlowTopToBottom
            displaced: Transition {
                NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
            }

            model: DelegateModel {
                id: visualModel
                model:attachedfiltersmodel
                groups: [
                    DelegateModelGroup {
                        includeByDefault: false
                        name: "displayField"
                    }
                    ,DelegateModelGroup {
                        includeByDefault: false
                        name: "video"
                    }
                    ,DelegateModelGroup {
                        includeByDefault: false
                        name: "audio"
                    }
                ]
                // filterOnGroup: "video"

                delegate: MouseArea {
                    id: delegateRoot
                    property int visualIndex: DelegateModel.itemsIndex
                    height: attachedFiltersView.cellHeight
                    width: attachedFiltersView.cellWidth
                    drag.target: icon

                    onClicked: {
                        filterItemChosed(index)
                    }
                    function chooseFilterItem(index){

                    }
                    onDoubleClicked: {
                        if(visualModel.filterOnGroup == 'video'){
                            attachedFilters.oldIndexVideo = index
                        }else{
                            attachedFilters.oldIndexAudio = index
                        }
                        model.checkState = !model.checkState
                        filterDelegateCheck.checkedState = model.checkState
                        showParamterSetting(index)
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

                        Component.onCompleted: {
                            if(!attachedFiltersView.isReady){
                                refreshGridModel()
                                attachedFiltersView.isReady = true
                                attachedFilters.oldFiltersNum = visualModel.items.count
                                visualModel.filterOnGroup = "video"
                                if(visualModel.groups[3].count <= 0){
                                    visualModel.filterOnGroup = "audio"
                                }
                            }
                        }

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
                                model.checkState = !model.checkState
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
                                attachedFiltersView.model.model.remove(index)
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
                                    anchors.horizontalCenter: undefined;
                                    anchors.verticalCenter: undefined
                                }
                            }
                        ]
                    }

                    DropArea {
                        anchors { fill: parent; margins: 15 }
                        onEntered: {
                            if(typeof attachedfiltersmodel == 'undefined'){
                                throw new Error("attachedfiltersmodel is undefined")
                            }
                            // visualModel.items.move(drag.source.visualIndex, delegateRoot.visualIndex)
                            attachedfiltersmodel.move(drag.source.visualIndex, delegateRoot.visualIndex)
                            attachedFiltersView.currentIndex = drag.source.visualIndex
                            filterItemChosed(attachedFiltersView.currentIndex)
                        }
                    }
                }
            }
            onCurrentIndexChanged: {
                possiblySelectFirstFilter();
                positionViewAtIndex(currentIndex, GridView.Contain);
            }
            onCountChanged: {
                possiblySelectFirstFilter();
            }

            function possiblySelectFirstFilter() {
                if (count > 0 && currentIndex == -1) {
                    currentIndex = 0;
                    showParamterSetting(currentIndex);
                }
            }

            Loader {
                id: dragItem

                // Emulate the delegate properties added by ListView
                property var model : Object()

                onLoaded: {
                    item.color = activePalette.highlight
                    item.opacity = 0.5
                    item.width = attachedFiltersView.width
                }
            }
        }
    }
}
