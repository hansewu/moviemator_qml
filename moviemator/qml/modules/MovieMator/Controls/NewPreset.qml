
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

RowLayout {
    property var parameters: []
    property ListModel presets: presetModel

    // Tell the parent QML page to update its controls.
    signal beforePresetLoaded()
    signal presetSelected()

    Component.onCompleted: {
        filter.loadPresets()
    }

    GridMenu {
        id: gridMenu
        width: 320
        height: 320
        listModel: presets
        onSelected: {
            beforePresetLoaded()
            filter.preset(presets.get(index).name)
            presetSelected()
        }
    }
}
