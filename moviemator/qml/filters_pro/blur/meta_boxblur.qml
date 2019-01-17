import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Blur")
    mlt_service: "boxblur"
    qml: "ui_boxblur.qml"
    gpuAlt: "movit.blur"
    filterType: qsTr('Effect')
    keyframes {
        minimumVersion: '3'
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['hori', 'vert']
        parameters: [
            Parameter {
                name: qsTr('Width')
                property: 'hori'
                objectName: 'wslider'
                controlType: 'SliderSpinner'
                paraType: 'int'
                defaultValue: '0.02'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('Height')
                property: 'vert'
                objectName: 'hslider'
                controlType: 'SliderSpinner'
                paraType: 'int'
                defaultValue: '0.02'
                value: '0'
                factorFunc:  []
            }
        ]
    }
}
