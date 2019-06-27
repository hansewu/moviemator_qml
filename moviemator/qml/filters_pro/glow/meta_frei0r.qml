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
    mlt_service: "frei0r.glow"
    qml: "ui_frei0r.qml"
    gpuAlt: "movit.glow"
    filterType: qsTr('6 Light')
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['0']
        parameters: [
            Parameter {
                name: qsTr('Blur')
                property: '0'
                objectName: 'bslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.050'
                value: '0'
                factorFunc:  ['c:100']
            }
        ]
    }
}
