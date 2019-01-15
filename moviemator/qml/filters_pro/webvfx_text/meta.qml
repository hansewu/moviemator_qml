import QtQuick 2.0
import com.moviemator.qml 1.0

Metadata {
    type: Metadata.Filter
    objectName: 'webvfxText'
    name: qsTr("Text(HTML+CSS)")
    mlt_service: "webvfx"
    qml: "ui.qml"
    filterType: qsTr('Effect')
}
