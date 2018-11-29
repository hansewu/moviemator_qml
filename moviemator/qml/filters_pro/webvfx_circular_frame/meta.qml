import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    objectName: 'webvfxCircularFrame'
    name: qsTr("Circular Frame (HTML)")
    mlt_service: "webvfx"
    qml: "ui.qml"
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['radius']
        parameters: [
            Parameter {
                name: qsTr('Radius')
                property: 'radius'
                objectName: 'slider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '50'
                value: '0'
                factorFunc:  ['c:100']
            }
        ]
    }
}
