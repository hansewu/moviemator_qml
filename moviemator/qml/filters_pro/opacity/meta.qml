import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    objectName: 'brightnessOpacity'
    name: qsTr("Opacity")
    mlt_service: "brightness"
    qml: "ui.qml"
    gpuAlt: "movit.opacity"
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['alpha']
        parameters: [
            Parameter {
                name: qsTr('Level')
                property: 'alpha'
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
