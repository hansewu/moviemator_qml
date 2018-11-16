import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    isAudio: true
    name: qsTr("Normalize: Two Pass")
    mlt_service: "loudness"
    qml: "ui.qml"
    isClipOnly: true
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['program']
        parameters: [
            Parameter {
                name: qsTr('program')
                property: 'program'
                isSimple: true
                isCurve: true
            }
        ]
    }
}
