

/*
 * Copyright (c) 2011-2016 Meltytech, LLC
 *
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: wyl <wyl@pylwyl.local>
 */

import QtQuick 2.0
SizePositionUI {
    fillProperty: 'transition.fill'
    distortProperty: 'transition.distort'
    // legacyRectProperty: 'transition.geometry'
    rectProperty: 'transition.rect_anim_relative'
    valignProperty: 'transition.valign'
    halignProperty: 'transition.halign'
    Component.onCompleted: {
        if (filter.isNew) {
            filter.set('transition.threads', 0)
        }
    }
}