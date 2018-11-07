import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    isAudio: true
    name: qsTr("Balance")
    mlt_service: 'panner'
    objectName: 'audioBalance'
    qml: 'ui.qml'
}
