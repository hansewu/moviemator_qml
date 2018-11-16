import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Sepia Tone")
    mlt_service: "sepia"
    qml: 'ui.qml'
    isFavorite: true
    allowMultiple: false
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['u','v']
        parameters: [
            Parameter {
                name: qsTr('u')
                property: 'u'
                isSimple: true
                isCurve: true
            },
            Parameter {
                name: qsTr('v')
                property: 'v'
                isSimple: true
                isCurve: true
            }
        ]
    }
}
