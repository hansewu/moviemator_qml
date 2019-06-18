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
    objectName: "movitContrast"
    mlt_service: "movit.lift_gamma_gain"
    needsGPU: true
    qml: "ui.qml"
    isFavorite: true
    filterType: qsTr('Color Adjustment')
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['gain_r']
        parameters: [
            Parameter {
                name: qsTr('Level')
                property: 'gain_r'
                objectName: 'contrastSlider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.24'
                value: '0'
                factorFunc:  ['c:100.0']
            }
        ]
    }
}
