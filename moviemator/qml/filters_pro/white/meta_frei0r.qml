import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("White Balance")
    mlt_service: "frei0r.colgate"
    qml: "ui.qml"
    isFavorite: true
    gpuAlt: "movit.white_balance"
    // keyframes {
    //     allowAnimateIn: true
    //     allowAnimateOut: true
    //     simpleProperties: ['0','1']
    //     parameters: [
    //         Parameter {
    //             name: qsTr('0')
    //             property: '0'
    //             isSimple: true
    //             isCurve: true
    //         },
    //         Parameter {
    //             name: qsTr('1')
    //             property: '1'
    //             isSimple: true
    //             isCurve: true
    //         }
    //     ]
    // }
}
