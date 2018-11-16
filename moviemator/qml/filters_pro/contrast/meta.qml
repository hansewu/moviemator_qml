import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Contrast")
    objectName: "contrast"
    mlt_service: "lift_gamma_gain"
    qml: "ui.qml"
    isFavorite: true
    gpuAlt: "movit.lift_gamma_gain"
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['gamma_r','gamma_g','gamma_b','gain_r','gain_g','gain_b']
        parameters: [
            Parameter {
                name: qsTr('Level')
                property: 'gamma_r'
                isSimple: true
            },
            Parameter {
                name: qsTr('Level')
                property: 'gamma_g'
                isSimple: true
            },
            Parameter {
                name: qsTr('Level')
                property: 'gamma_b'
                isSimple: true
            },
            Parameter {
                name: qsTr('Level')
                property: 'gain_r'
                isSimple: true
            },
            Parameter {
                name: qsTr('Level')
                property: 'gain_g'
                isSimple: true
            },
            Parameter {
                name: qsTr('Level')
                property: 'gain_b'
                isSimple: true
            }
        ]
    }
}
