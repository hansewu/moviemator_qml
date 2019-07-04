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
    name: qsTr("Saturation")
    mlt_service: "frei0r.saturat0r"
    qml: "ui_frei0r.qml"
    gpuAlt: "movit.saturation"
    filterType: qsTr('3 Basic Coloring Tool')
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['0']
        parameters: [
            Parameter {
                name: qsTr('Level')
                property: '0'
                objectName: 'slider'
                controlType: 'SliderSpinner'
                paraType: 'double'
                defaultValue: '0.375'
                value: '0'
                factorFunc:  ['c:800.0']
            }
        ]
    }
}
