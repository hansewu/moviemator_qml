import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    objectName: 'movitOpacity'
    name: qsTr("Opacity")
    mlt_service: "movit.opacity"
    needsGPU: true
    qml: "ui.qml"
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['opacity']
        parameters: [
            Parameter {
                name: qsTr('Level')
                property: 'opacity'
                objectName: 'slider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '100'
                value: '0'
                factorFunc:  []
            }
        ]
    }
}
