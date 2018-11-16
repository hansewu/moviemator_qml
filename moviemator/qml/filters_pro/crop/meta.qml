import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Crop")
    mlt_service: "crop"
    qml: "ui.qml"
    gpuAlt: "crop"
    allowMultiple: false
    isClipOnly: true
    freeVersion: true
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['center','center_bias','top','bottom','left','right']
        parameters: [
            Parameter {
                name: qsTr('center')
                property: 'center'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('center_bias')
                property: 'center_bias'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('top')
                property: 'top'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('bottom')
                property: 'bottom'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('left')
                property: 'left'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('right')
                property: 'right'
                isSimple: true
                isCurve: true
            }
        ]
    }
}
