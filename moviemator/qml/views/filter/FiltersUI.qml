
import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import MovieMator.Controls 1.0

Rectangle {
    id: root
    color: "transparent"
    property int repeaterItemWidth: 130
    property int repeaterItemHeight: 96
    property var currentChoosed : 0

    property var filtersInfoList: []

    function findFilterModel(name){
        for(var i=0;i<filtersInfoList.length;i++){
            if(name == filtersInfoList[i].name){
                return filtersInfoList[i]
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

    Component.onCompleted: {
        var num = filtersInfo.rowCount();
        for(var i=0;i< filtersInfo.rowCount();i++){
            // console.log("visiblevisiblevisiblevisible-0: " + filtersInfo.get(i).visible)
            var filterInfo = {
                id: filtersInfo.get(i).name + '' + i,
                index : i,
                visible:filtersInfo.get(i).visible,
                name : filtersInfo.get(i).name,
                filterType : filtersInfo.get(i).filterType,
                imageSourcePath : filtersInfo.get(i).imageSourcePath,
            }
            filtersInfoList.push(filterInfo)
            
            console.log("visiblevisiblevisiblevisible: " + filterInfo.visible)
            
        }
        
        catList.clear()
        catListAll.clear()
        catListAll.append({"typename":qsTr('All')})
        for(var i=0;i<filtersInfoList.length;i++){
            console.log("filterTypeStrfilterTypeStr: " +i+":"+ filtersInfoList[i].filterType)
            if('' == filtersInfoList[i].filterType) continue;
            if(null == findFilterType(filtersInfoList[i].filterType)){
                catList.append({"typename":filtersInfoList[i].filterType})
                catListAll.append({"typename":filtersInfoList[i].filterType})
            }
        }

        console.log("catList: " + catList.count)
        console.log("catListAll: " + catListAll.count)
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

    Component{ //代理
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
                console.log("typename:"+typename)
                filters.clear()
                for(var i=0;i<filtersInfoList.length;i++){
                    if(typename === filtersInfoList[i].filterType){
                        if('1' == filtersInfoList[i].visible){
                            continue;
                        }
                        filters.append(filtersInfoList[i])
                        console.log("name: " + filtersInfoList[i].name)
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
                                topMargin:-10
                                right:parent.right
                                rightMargin:12
                            }
                            visible:id.checked ? true : false
                            checkable : true
                            onClicked:{
                                addFilter(index)
                            }
                            style: ButtonStyle { 
                                background:Rectangle{ 
                                    implicitHeight: parent.height 
                                    implicitWidth: parent.width 
                                    color: "transparent" //设置背景透明，否则会出现默认的白色背景 
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
                            Image {
                                id: myIcon
                                anchors.horizontalCenter : parent.horizontalCenter
                                width: 106
                                height: 60
                                source: 'j20.jpg'
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
                                text: name
                                color: '#ffffff'
                                font.pixelSize: 9
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    currentChoosed = parent.objectName
                                }
                                onDoubleClicked:{
                                    currentChoosed = parent.objectName
                                    addFilter(index)
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
            //  scrollToClickedPosition:true
            handle: Item {
                implicitWidth: 14
                implicitHeight: 14
                Rectangle {
                    color: "transparent"
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
        ListView{ //视图
            width:parent.width;
            height:parent.height
            model:catList //关联数据模型
            delegate:delegate //关联代理
            focus:true //可以获得焦点，这样就可以响应键盘了
        }
    }
}
