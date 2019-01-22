import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

Item {
    id: comboBox
    width: 100
    height: 18
    z: 3

    signal catChanged(var index)

    property ListModel model

    function setModel(md){
        model = md
    }

    Button {
        id: comboButton
        anchors.fill: parent
        checkable: true
        text : model.get(0).typename
        style: ButtonStyle {
            background: Rectangle {
                color: '#323232'
                smooth: true
                radius: 1
            }
            label: Text {
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                // font.family: "Courier"
                // font.capitalization: Font.SmallCaps
                font.pixelSize: 10
                color: "white"
                text: comboButton.text
            }
        }
        onVisibleChanged: {
            if(!visible)
                checked = false
        }
        onCheckedChanged: listView.visible = checked
    }
    ListView {
        id: listView
        height :250
        width: comboButton.width
        z: 3
        // 保证在最顶，控件可见
        anchors.top: comboButton.bottom
        visible: false
        model: comboBox.model

        delegate: Rectangle{
            id: delegateItem
            width: comboButton.width
            height: comboButton.height
            radius: 1
            color: '#525252'
            Text {
                renderType: Text.NativeRendering
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 10
                color: "white"
                elide: Text.ElideMiddle
                text: typename
            }
            MouseArea {
                hoverEnabled:true
                anchors.fill: parent;
                onClicked: {
                    listView.currentIndex = index
                    comboButton.text = comboBox.model.get(listView.currentIndex).typename
                    comboButton.checked = false
                    catChanged(index)
                }
                onEntered: {
                    parent.color = '#C0482C'
                }
                onExited: {
                    parent.color = '#525252'
                }
            }
        }
    }
}
