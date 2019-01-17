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
    name: qsTr("Brightness")
    mlt_service: "brightness"
    qml: "ui.qml"
    isFavorite: true
    gpuAlt: "movit.opacity"
    allowMultiple: false
    filterType: qsTr('Color Adjustment')
    keyframes {
            allowAnimateIn: true
            allowAnimateOut: true
            simpleProperties: ['level']
            parameters: [
                Parameter {
                    name: qsTr('Level')
                    property: 'level'
                    objectName: 'brightnessSlider'
                    controlType: 'SliderSpinner'
                    paraType: 'double'
                    defaultValue: '0.01'
                    value: '0'
                    factorFunc:  ['c:100.0']
                }
            ]
        }

}
