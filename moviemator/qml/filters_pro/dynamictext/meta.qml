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
    objectName: 'dynamicText'
    name: qsTr('Text')
    mlt_service: 'dynamictext'
    qml: "ui.qml"
    vui: 'vui.qml'
    isGpuCompatible: false
    filterType: qsTr('Text')
    freeVersion: true
     keyframes {
         allowAnimateIn: true
         allowAnimateOut: true
         simpleProperties: ['geometry', 'fgcolour', 'olcolour', 'outline', 'bgcolour', 'pad', 'letter_spaceing']
         parameters: [
             Parameter {
                 name: qsTr('Position / Size')
                 property: 'geometry'
                 isSimple: true
                 paraType: "rect"
             },
             Parameter {
                 name: qsTr('Text Color')
                 property: 'fgcolour'
                 isSimple: true
                 paraType: "rect"
             },
             Parameter {
                 name: qsTr('Outline Color')
                 property: 'olcolour'
                 isSimple: true
                 paraType: "rect"
             },
             Parameter {
                 name: qsTr('Outline')
                 property: 'outline'
                 isSimple: true
                 paraType: "int"
             },
             Parameter {
                 name: qsTr('Background Color')
                 property: 'bgcolour'
                 isSimple: true
                 paraType: "rect"
             },
             Parameter {
                 name: qsTr('Pad')
                 property: 'pad'
                 isSimple: true
                 paraType: "int"
             },
             Parameter {
                 name: qsTr('Letter Spaceing')
                 property: 'letter_spaceing'
                 isSimple: true
                 paraType: "int"
             }
         ]
     }
}
