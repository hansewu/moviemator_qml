import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Old Film: Grain")
    mlt_service: "grain"
    qml: "ui.qml"
    keyframes {
        minimumVersion: '3'
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['noise', 'vert']
        parameters: [
            Parameter {
                name: qsTr('noise')
                property: 'noise'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('brightness')
                property: 'brightness'
                isSimple: true
                isCurve: true
            }
        ]
    }
}
