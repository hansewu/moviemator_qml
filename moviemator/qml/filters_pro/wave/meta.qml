import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Wave")
    mlt_service: "wave"
    qml: "ui.qml"
    isFavorite: false
    allowMultiple: false
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['wave','speed','deformX','deformY']
        parameters: [
            Parameter {
                name: qsTr('wave')
                property: 'wave'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('speed')
                property: 'speed'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('deformX')
                property: 'deformX'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('deformY')
                property: 'deformY'
                isSimple: true
                isCurve: true
            }
        ]
    }
}
