

import QtQuick 2.0
SizePositionUI {
    fillProperty: 'transition.fill'
    distortProperty: 'transition.distort'
    // legacyRectProperty: 'transition.geometry'
    rectProperty: 'transition.rect'
    valignProperty: 'transition.valign'
    halignProperty: 'transition.halign'
    Component.onCompleted: {
        if (filter.isNew) {
            filter.set('transition.threads', 0)
        }
    }
}