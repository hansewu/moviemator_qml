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
     keyframes {
         allowAnimateIn: true
         allowAnimateOut: true
         simpleProperties: ['geometry','fgcolour', 'olcolour', 'outline']
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
             }
         ]
     }
}
