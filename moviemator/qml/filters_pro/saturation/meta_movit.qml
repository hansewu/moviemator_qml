import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Saturation")
    mlt_service: "movit.saturation"
    needsGPU: true
    qml: "ui_movit.qml"
    filterType: qsTr('Color Adjustment')
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['saturation']
        parameters: [
            Parameter {
                name: qsTr('Level')
                property: 'saturation'
                objectName: 'slider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '100'
                value: '0'
                factorFunc:  ['c:100.0']
            }
        ]
    }
}
