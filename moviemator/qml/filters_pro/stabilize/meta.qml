import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Stabilize")
    mlt_service: "vidstab"
    qml: "ui.qml"
    isClipOnly: true
    isGpuCompatible: false
    isFavorite: false
    allowMultiple: false
    keyframes {
        allowTrim: false
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['shakiness','accuracy','Zoom','refresh']
        parameters: [
            Parameter {
                name: qsTr('shakiness')
                property: 'shakiness'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('accuracy')
                property: 'accuracy'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('Zoom')
                property: 'zoom'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('refresh')
                property: 'refresh'
                isSimple: true
                isCurve: true
            }
        ]
    }
}
