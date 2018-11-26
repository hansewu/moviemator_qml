
import QtQuick 2.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import MovieMator.Controls 1.0
import com.moviemator.qml 1.0

Item {
    id: stabilizeRoot
    width: 300
    height: 250
    property string settingsSavePath: settings.savePath
    Component.onCompleted: {
        keyFrame.initFilter(layoutRoot)
    }

    function hasAnalysisCompleted() {
            return (filter.get("results").length > 0 &&
                    filter.get("filename").indexOf(filter.get("results")) !== -1)
    }

    function setStatus( inProgress ) {
        if (inProgress) {
            status.text = qsTr('Analyzing...')
        }
        else if (filter.get("results").length > 0 && 
                 filter.get("filename").indexOf(filter.get("results")) !== -1) {
            status.text = qsTr('Analysis complete.')
        }
        else
        {
            status.text = qsTr('Click Analyze to use this filter.')
        }
    }

    // This signal is used to workaround context properties not available in
    // the FileDialog onAccepted signal handler on Qt 5.5.
    signal fileSaved(string filename)
    onFileSaved: {
        var lastPathSeparator = filename.lastIndexOf('/')
        if (lastPathSeparator !== -1) {
            settings.savePath = filename.substring(0, lastPathSeparator)
        }
    }

    Connections {
        target: filter
        onAnalyzeFinished: {
            filter.set("reload", 1);
            setStatus(false)
            button.enabled = true
        }
    }
    
    FileSaveDialog {
        id: fileDialog
        title: qsTr( 'Select a file to store analysis results.' )
//        modality: Qt.WindowModal
//        selectExisting: false
//        selectMultiple: false
//        selectFolder: false
//        folder: settingsSavePath
        nameFilters: [ "Stabilize Results (*.stab)" ]
//        selectedNameFilter: "Stabilize Results (*.stab)"
        filename: "stabilize_analyze.stab"
        onAccepted: {
            var filename = fileDialog.fileUrl.toString()
            // Remove resource prefix ("file://")
            filename = filename.substring(7)
            if (filename.substring(2, 4) == ':/') {
                // In Windows, the prefix is a little different
                filename = filename.substring(1)
            }
            stabilizeRoot.fileSaved(filename)

            var extension = ".stab"
            // Force file extension to ".stab"
            var extIndex = filename.indexOf(extension, filename.length - extension.length)
            if (extIndex == -1) {
                filename += ".stab"
            }
            filter.set('filename', filename)
            filter.getHash()
            setStatus(true)
            filter.analyze();
        }
        onRejected: {
            button.enabled = true
        }
    }

    GridLayout {
        id: layoutRoot
        columns: 3
        anchors.fill: parent
        anchors.margins: 8

        YFKeyFrame{
            id: keyFrame
            Layout.columnSpan:3
            onSynchroData:{
                keyFrame.setDatas(layoutRoot)
            }
            onLoadKeyFrame:{
                keyFrame.loadFrameValue(layoutRoot)
            }
        }

        Label {
            text: qsTr('<b>Analyze Options</b>')
            Layout.columnSpan: 3
            color: '#ffffff'
        }

        Label {
            text: qsTr('Shakiness')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'shakinessSlider'
            id: shakinessSlider
            minimumValue: 1
            maximumValue: 10
            tickmarksEnabled: true
            stepSize: 1
            value: filter.getDouble('shakiness')
            onValueChanged:
            {
                keyFrame.controlValueChanged(shakinessSlider)
            }
        }
        UndoButton {
            onClicked: shakinessSlider.value = 4
        }

        Label {
            text: qsTr('Accuracy')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'accuracySlider'
            id: accuracySlider
            minimumValue: 1
            maximumValue: 15
            tickmarksEnabled: true
            stepSize: 1
            value: filter.getDouble('accuracy')
            onValueChanged:{
                keyFrame.controlValueChanged(accuracySlider)
            }
        }
        UndoButton {
            onClicked: accuracySlider.value = 4
        }

        Label {
            text: qsTr('<b>Filter Options</b>')
            Layout.columnSpan: 3
            color: '#ffffff'
        }

        Label {
            text: qsTr('Zoom')
            Layout.alignment: Qt.AlignRight
            color: '#ffffff'
        }
        SliderSpinner {
            objectName: 'zoomSlider'
            id: zoomSlider
            minimumValue: -50
            maximumValue: 50
            decimals: 1
            suffix: ' %'
            value: filter.getDouble('zoom')
            onValueChanged: {
                keyFrame.controlValueChanged(zoomSlider)
            }
        }
        UndoButton {
            onClicked: zoomSlider.value = 0
        }

        Button {
            id: button
            text: qsTr('Analyze')
            Layout.alignment: Qt.AlignRight
            onClicked: {
                button.enabled = false
//                fileDialog.folder = settings.savePath
                fileDialog.open()
            }
        }
        Label {
            id: status
            Layout.columnSpan: 2
            color: '#ffffff'
            Component.onCompleted: {
                setStatus(false)
            }
        }

        Item {
            Layout.fillHeight: true;
        }
    }
}
