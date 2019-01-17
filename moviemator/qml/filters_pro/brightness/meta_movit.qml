import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Brightness")
    objectName: "movitBrightness"
    mlt_service: "movit.opacity"
    needsGPU: true
    qml: "ui_movit.qml"
    isFavorite: true
    filterType: qsTr('Color Adjustment')
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['opacity']
        parameters: [
            Parameter {
                name: qsTr('Level')
                property: 'opacity'
                objectName: 'brightnessSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.01'
                value: '0'
                factorFunc:  ['c:100.0']
            }
        ]
    }
}
