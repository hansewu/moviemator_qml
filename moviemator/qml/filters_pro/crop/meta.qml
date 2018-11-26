import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Crop")
    mlt_service: "crop"
    qml: "ui.qml"
    gpuAlt: "crop"
    allowMultiple: false
    isClipOnly: true
    freeVersion: true
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['center','center_bias','top','bottom','left','right']
        parameters: [
            Parameter {
                name: qsTr('center')
                property: 'center'
                objectName: 'centerCheckBox'
                controlType: 'CheckBox'
                paraType: 'int'
                defaultValue: ''
                value: ''
                factorFunc:  []
            },
            Parameter {
                name: qsTr('center_bias')
                property: 'center_bias'
                objectName: 'biasslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('top')
                property: 'top'
                objectName: 'topslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('bottom')
                property: 'bottom'
                objectName: 'bottomslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('left')
                property: 'left'
                objectName: 'leftslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('right')
                property: 'right'
                objectName: 'rightslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0'
                value: '0'
                factorFunc:  []
            }
        ]
    }
}
