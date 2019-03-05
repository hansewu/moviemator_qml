/*
 * Copyright (c) 2014-2016 Meltytech, LLC
 * Author: Brian Matherly <code@brianmatherly.com>
 *
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: vgawen <gdb_1986@163.com>
 *
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: wyl <wyl@pylwyl.local>
 * Author: fuyunhuaxin <2446010587@qq.com>
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

import QtQuick 2.1
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0
import QtQuick.Controls.Styles 1.4
import Qt.labs.controls 1.0

Rectangle {
    id: root

    
    signal currentFilterRequested(int attachedIndex)
    
    function clearCurrentFilter() {
        if (filterConfig.item) {
            filterConfig.item.width = 1
            filterConfig.item.height = 1
        }
        filterConfig.source = ""
    }
    
    function setCurrentFilter(index) {
        attachedFilters.setCurrentFilter(index)
        // removeButton.selectedIndex = index
        filterConfig.source = metadata ? metadata.qmlFilePath : ""
    }

    color: '#353535'//activePalette.window
    width: 400

    onWidthChanged: _setLayout()
    onHeightChanged: _setLayout()
    
    function _setLayout() {
        // if (height > width - 200) {
        //     root.state = "portrait"
        // } else {
        //     root.state = "landscape"
        // }
    }
    
    SystemPalette { id: activePalette }
    
    FilterMenu {
        id: filterMenu

        height: 400
        onFilterSelected: {
            attachedfiltersmodel.add(metadatamodel.get(index))
        }
    }

    Rectangle {
        id: titleBackground
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: titleLabel.bottom
            topMargin: 10
            leftMargin: 10
            rightMargin: 10
        }
        color: '#535353'
        visible: attachedfiltersmodel.producerTitle != ""
    }

    Label {
        id: titleLabel
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 10
            leftMargin: 10
            rightMargin: 10
        }
        text: attachedfiltersmodel.producerTitle
        elide: Text.ElideLeft
        color: activePalette.highlightedText
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
    }

    GridLayout {
        id: attachedContainer
        columns: 3
        // width: titleBackground.width
        height: 100
        anchors {
            top: titleBackground.bottom
            topMargin: 20
            left: parent.left
            leftMargin: 10
            right:parent.right
            rightMargin: 10
        }
        Rectangle{
            color: '#353535'
            border.color: "black"
            border.width: 1
            anchors.fill: parent
            anchors.topMargin: 5
            AttachedFilters {
                id: attachedFilters
                color:'transparent'
                Layout.columnSpan: 3
                height:parent.height - 4
                anchors {
                    top: parent.top
                    topMargin: 2
                    left: parent.left
                    leftMargin: 2
                    right:parent.right
                    rightMargin: 2
                }
                onFilterClicked: {
                    root.currentFilterRequested(index)
                }
                Label {
                    anchors.centerIn: parent
                    text: qsTr("Nothing selected")
                    color: activePalette.text
                    visible: !attachedfiltersmodel.isProducerSelected
                }
            }
        }
    }

    ScrollView {
        id: filterConfigScrollView
        anchors {
            top: attachedContainer.bottom
            bottom: keyFrameControlContainer.top
            left: root.left
            right: root.right
        }
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
                corner: Item {
                    implicitWidth: 14
                    implicitHeight: 14
                }

            }

        function expandWidth() {

            if (filterConfig.item) {
                filterConfig.item.width =
                    Math.max(filterConfig.minimumWidth,
                             filterConfigScrollView.width /* scroll bar */)
            }
        }
        onWidthChanged: expandWidth()
        Loader {
            id: filterConfig
            property int minimumWidth: 0
            onLoaded: {
                minimumWidth = item.width
                filterConfigScrollView.expandWidth()
            }
        }
    }
    Rectangle{
        id:keyFrameControlContainer
        color: '#353535'
        border.color: "black"
        border.width: 1
        height: 90
        // width:parent.width -10
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin:10
            rightMargin:10
            bottomMargin:5
        }
        radius: 2//圆角
        visible: metadata && (metadata.keyframes.parameterCount > 0)

        KeyFrameControl {
            id: keyFrameControl
            width:parent.width-4
            height:parent.height+10
            anchors {
                horizontalCenter: parent.horizontalCenter;
                bottom: parent.bottom
            }
        }
    }
    


    // states: [
    //     State {
    //         name: "landscape"  // 左右结构
    //         AnchorChanges {
    //             target: filterConfigScrollView
    //             anchors {
    //                 top: titleBackground.bottom
    //                 bottom: attachedContainer.bottom //root.bottom
    //                 left: attachedContainer.right
    //                 right: root.right
    //             }
    //         }
    //         PropertyChanges {
    //             target: attachedContainer; width: 120
    //             height: root.height
    //         }
    //     },
    //     State {
    //         name: "portrait"  //上下结构
    //         AnchorChanges {
    //             target: filterConfigScrollView
    //             anchors {
    //                 top: attachedContainer.bottom
    //                 bottom: keyFrameControl.top
    //                 left: root.left
    //                 right: root.right
    //             }
    //         }
    //         PropertyChanges {
    //             target: attachedContainer
    //             width: titleBackground.width
    //             height: 100
    //         }
    //     }
    // ]
}
