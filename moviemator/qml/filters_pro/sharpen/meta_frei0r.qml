import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Sharpen")
    mlt_service: "frei0r.sharpness"
    qml: "ui_frei0r.qml"
    gpuAlt: "movit.sharpen"
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['0', '1']
        parameters: [
            Parameter {
                name: qsTr('Amount')
                property: '0'
                objectName: 'aslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '50'
                value: '0'
                factorFunc:  ['c:100.0']
            },
            Parameter {
                name: qsTr('Size')
                property: '1'
                objectName: 'sslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '50'
                value: '0'
                factorFunc:  ['c:100.0']
            }
        ]
    }
}
