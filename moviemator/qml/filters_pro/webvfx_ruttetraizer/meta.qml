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
    objectName: 'webvfxRuttEtraIzer'
    name: qsTr("Rutt-Etra-Izer (HTML)")
    mlt_service: "webvfx"
    qml: "ui.qml"
    filterType: qsTr('9 Effect')
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['disable']
        parameters: [
            Parameter {
                name: qsTr('resource')
                property: 'resource'
                objectName: '*'
                controlType: ''
                paraType: 'string'
                defaultValue: 'ruttetraizer.html'
                value: '0'
                factorFunc:  []
            },
            Parameter {
                name: qsTr('disable')
                property: 'disable'
                objectName: '*'
                controlType: ''
                paraType: 'double'
                defaultValue: '0'
                value: ''
                factorFunc:  []
            },
            Parameter {
                name: qsTr('opacity')
                property: 'opacity'
                objectName: '*'
                controlType: ''
                paraType: 'double'
                defaultValue: '1.0'
                value: ''
                factorFunc:  []
            },
            Parameter {
                name: qsTr('thickness')
                property: 'thickness'
                objectName: '*'
                controlType: ''
                paraType: 'double'
                defaultValue: '3.0'
                value: ''
                factorFunc:  []
            },
            Parameter {
                name: qsTr('density')
                property: 'density'
                objectName: '*'
                controlType: ''
                paraType: 'double'
                defaultValue: '10.0'
                value: ''
                factorFunc:  []
            },
            Parameter {
                name: qsTr('depth')
                property: 'depth'
                objectName: '*'
                controlType: ''
                paraType: 'double'
                defaultValue: '100.0'
                value: ''
                factorFunc:  []
            },
            Parameter {
                name: qsTr('scale')
                property: 'scale'
                objectName: '*'
                controlType: ''
                paraType: 'double'
                defaultValue: '3.0'
                value: ''
                factorFunc:  []
            },
            Parameter {
                name: qsTr('out')
                property: 'out'
                objectName: '*'
                controlType: ''
                paraType: 'double'
                defaultValue: '4459.0'
                value: ''
                factorFunc:  []
            }
        ]
    }
}
