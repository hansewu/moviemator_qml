import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Glow")
    mlt_service: "frei0r.glow"
    qml: "ui_frei0r.qml"
    gpuAlt: "movit.glow"
    filterType: qsTr('Effect')
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['0']
        parameters: [
            Parameter {
                name: qsTr('Blur')
                property: '0'
                objectName: 'bslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.050'
                value: '0'
                factorFunc:  ['c:100']
            }
        ]
    }
}
