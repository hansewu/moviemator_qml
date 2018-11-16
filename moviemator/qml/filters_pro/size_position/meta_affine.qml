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
        simpleProperties: ['transition.rect','test']
        parameters: [
            Parameter {
                name: qsTr('Position / Size')
                property: 'transition.rect'
                isSimple: true
            },
            Parameter {
                name: qsTr('test')
                property: 'test'
                isSimple: true
                isCurve: true
            }
        ]
    }
}
