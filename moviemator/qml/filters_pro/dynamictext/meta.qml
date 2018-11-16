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
    // keyframes {
    //     allowAnimateIn: true
    //     allowAnimateOut: true
    //     //simpleProperties: ['geometry','fgcolour','argument','family','weight','olcolour','outline','bgcolour','pad','valign','halign']
    //     simpleProperties: ['geometry']
    //     parameters: [
    //         Parameter {
    //             name: qsTr('Position / Size')
    //             property: 'geometry'
    //             isSimple: true
    //         }
    //         // Parameter {
    //         //     name: qsTr('Position / Size')
    //         //     property: 'fgcolour'
    //         //     isSimple: true
    //         // },
    //         // Parameter {
    //         //     name: qsTr('Position / Size')
    //         //     property: 'argument'
    //         //     isSimple: true
    //         // },
    //         // Parameter {
    //         //     name: qsTr('Position / Size')
    //         //     property: 'family'
    //         //     isSimple: true
    //         // },
    //         // Parameter {
    //         //     name: qsTr('Position / Size')
    //         //     property: 'weight'
    //         //     isSimple: true
    //         // },
    //         // Parameter {
    //         //     name: qsTr('Position / Size')
    //         //     property: 'olcolour'
    //         //     isSimple: true
    //         // },
    //         // Parameter {
    //         //     name: qsTr('Position / Size')
    //         //     property: 'outline'
    //         //     isSimple: true
    //         // },
    //         // Parameter {
    //         //     name: qsTr('Position / Size')
    //         //     property: 'bgcolour'
    //         //     isSimple: true
    //         // },
    //         // Parameter {
    //         //     name: qsTr('Position / Size')
    //         //     property: 'pad'
    //         //     isSimple: true
    //         // },
    //         // Parameter {
    //         //     name: qsTr('Position / Size')
    //         //     property: 'valign'
    //         //     isSimple: true
    //         // },
    //         // Parameter {
    //         //     name: qsTr('Position / Size')
    //         //     property: 'halign'
    //         //     isSimple: true
    //         // }

    //     ]
    // }
}
