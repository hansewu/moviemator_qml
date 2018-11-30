import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Vignette")
    mlt_service: "vignette"
    qml: "ui_oldfilm.qml"
    gpuAlt: "movit.vignette"
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['radius', 'smooth', 'opacity','mode']
        minimumVersion: '1.0'
        parameters: [
            Parameter {
                name: qsTr('Radius')
                property: 'radius'
                objectName: 'radiusSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '50'
                value: '0'
                factorFunc:  ['c:100.0']
            },
            Parameter {
                name: qsTr('Feathering')
                property: 'smooth'
                objectName: 'smoothSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '80'
                value: '0'
                factorFunc:  ['c:100.0']
            },
            Parameter {
                name: qsTr('mode')
                property: 'mode'
                objectName: 'modeCheckBox'
                controlType: 'CheckBox'
                paraType: 'int'
                defaultValue: ''
                value: ''
                factorFunc:  []
            },
            Parameter {
                name: qsTr('Opacity')
                property: 'opacity'
                objectName: 'opacitySlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '100'
                value: '0'
                factorFunc:  ['c:100.0','-:1.0','x:-1.0']
            }
        ]
    }
}
