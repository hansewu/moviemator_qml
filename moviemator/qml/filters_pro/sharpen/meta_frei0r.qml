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
    mlt_service: "frei0r.sharpness"
    qml: "ui_frei0r.qml"
    gpuAlt: "movit.sharpen"
    filterType: qsTr('Effect')
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['0', '1']
        parameters: [
            Parameter {
                name: qsTr('Amount')
                property: '0'
                objectName: 'aslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.050'
                value: '0'
                factorFunc:  ['c:100.0']
            },
            Parameter {
                name: qsTr('Size')
                property: '1'
                objectName: 'sslider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.050'
                value: '0'
                factorFunc:  ['c:100.0']
            }
        ]
    }
}
