import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Wave")
    mlt_service: "wave"
    qml: "ui.qml"
    isFavorite: false
    allowMultiple: false
    filterType: qsTr('Effect')
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['wave','speed','deformX','deformY']
        parameters: [
            Parameter {
                name: qsTr('wave')
                property: 'wave'
                objectName: 'waveSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.10'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('speed')
                property: 'speed'
                objectName: 'speedSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.05'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('deformX')
                property: 'deformX'
                objectName: 'deformXCheckBox'
                controlType: 'CheckBox'
                paraType: 'int'
                defaultValue: '0'
                value: ''
                factorFunc:  []
            },
            Parameter {
                name: qsTr('deformY')
                property: 'deformY'
                objectName: 'deformYCheckBox'
                controlType: 'CheckBox'
                paraType: 'int'
                defaultValue: '0'
                value: ''
                factorFunc:  []
            }
        ]
    }
}
