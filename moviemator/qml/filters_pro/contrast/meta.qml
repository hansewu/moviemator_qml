/*
 * Copyright (c) 2011-2016 Meltytech, LLC
 *
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: wyl <wyl@pylwyl.local>
 */

import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Contrast")
    objectName: "contrast"
    mlt_service: "lift_gamma_gain"
    qml: "ui.qml"
    isFavorite: true
    gpuAlt: "movit.lift_gamma_gain"
    filterType: qsTr('Color Adjustment')
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['gamma_r','gamma_g','gamma_b','gain_r','gain_g','gain_b']
        parameters: [
            Parameter {
                name: qsTr('Level')
                property: 'gamma_r'
                objectName: 'contrastSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.75'
                value: '0'
                factorFunc:  ['c:100.0','-:1','x:-2']
            },
            Parameter {
                name: qsTr('Level')
                property: 'gamma_g'
                objectName: 'contrastSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.75'
                value: '0'
                factorFunc:  ['c:100.0','-:1','x:-2']
            },
            Parameter {
                name: qsTr('Level')
                property: 'gamma_b'
                objectName: 'contrastSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.75'
                value: '0'
                factorFunc:  ['c:100.0','-:1','x:-2']
            },
            Parameter {
                name: qsTr('Level')
                property: 'gain_r'
                objectName: 'contrastSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.75'
                value: '0'
                factorFunc:  ['c:50.0']
            },
            Parameter {
                name: qsTr('Level')
                property: 'gain_g'
                objectName: 'contrastSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.75'
                value: '0'
                factorFunc:  ['c:50.0']
            },
            Parameter {
                name: qsTr('Level')
                property: 'gain_b'
                objectName: 'contrastSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.75'
                value: '0'
                factorFunc:  ['c:50.0']
            }
        ]
    }
}
