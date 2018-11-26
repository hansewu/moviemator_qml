import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Vignette")
    mlt_service: "movit.vignette"
    needsGPU: true
    qml: "ui_movit.qml"
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['radius', 'inner_radius']
        parameters: [
            Parameter {
                name: qsTr('Outer radius')
                property: 'radius'
                objectName: 'radiusSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '30'
                value: '0'
                factorFunc:  ['c:100.0']
            },
            Parameter {
                name: qsTr('Inner radius')
                property: 'inner_radius'
                objectName: 'innerSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '30'
                value: '0'
                factorFunc:  ['c:100.0']
            }
        ]
    }
}
