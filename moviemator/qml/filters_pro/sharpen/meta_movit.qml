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
    name: qsTr("Sharpen")
    mlt_service: "movit.sharpen"
    needsGPU: true
    qml: "ui_movit.qml"
    filterType: qsTr('Effect')
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['circle_radius', 'gaussian_radius', 'correlation', 'noise']
        parameters: [
            Parameter {
                name: qsTr('Circle radius')
                property: 'circle_radius'
                objectName: 'cradiusslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '2'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('Gaussian radius')
                property: 'gaussian_radius'
                objectName: 'gradiusslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('Correlation')
                property: 'correlation'
                objectName: 'corrslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.95'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('Noise')
                property: 'noise'
                objectName: 'noiseslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.01'
                value: '0'
                factorFunc:  []
            }
        ]
    }
}
