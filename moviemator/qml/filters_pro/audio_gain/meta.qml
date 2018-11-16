import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    isAudio: true
    name: qsTr("Gain / Volume")
    mlt_service: "volume"
    qml: "ui.qml"
    isFavorite: true
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['gain']
        parameters: [
            Parameter {
                name: qsTr('gain')
                property: 'gain'
                isSimple: true
                isCurve: true
                minimum: -50
                maximum: 24
            }
        ]
    }
}
