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
    name: qsTr("Glow")
    mlt_service: "movit.glow"
    needsGPU: true
    qml: "ui_movit.qml"
    filterType: qsTr('6 Light')
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['radius', 'blur_mix', 'highlight_cutoff']
        parameters: [
            Parameter {
                name: qsTr('Radius')
                property: 'radius'
                objectName: 'radiusslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.20'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('Highlight blurriness')
                property: 'blur_mix'
                objectName: 'blurslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.01'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('Highlight cutoff')
                property: 'highlight_cutoff'
                objectName: 'cutoffslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.002'
                value: '0'
                factorFunc:  []
            }
        ]
    }
}
