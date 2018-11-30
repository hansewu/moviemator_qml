import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    objectName: 'affineSizePosition'
    name: qsTr('Size and Position')
    mlt_service: 'affine'
    qml: 'ui_affine.qml'
    vui: 'vui_affine.qml'
    gpuAlt: 'movit.rect'
    isFavorite: true
    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['transition.rect_anim_relative']
        parameters: [
            Parameter {
                name: qsTr('Position / Size')
                property: 'transition.rect_anim_relative'
                paraType:'rect'
                value: 'X0.0Y0.0W1.0H1.0'
            }
        ]
    }
}
