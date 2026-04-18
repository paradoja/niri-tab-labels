import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
    id: root

    property var pluginApi: null

    readonly property var cfg: pluginApi?.pluginSettings || ({})
    readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

    property string editPosition: cfg.position ?? defaults.position ?? "top"

    readonly property var positionOptions: [
        {
            key: "top",
            name: "Top edge"
        },
        {
            key: "bottom",
            name: "Bottom edge"
        },
        {
            key: "side",
            name: "Left side (rotated)"
        }
    ]

    spacing: Style.marginL

    NComboBox {
        Layout.fillWidth: true
        label: "Labels position"
        description: "Which edge of the screen the labels sit on."
        model: root.positionOptions
        currentKey: root.editPosition
        onSelected: key => root.editPosition = key
    }

    function saveSettings() {
        if (!pluginApi) {
            return;
        }
        pluginApi.pluginSettings.position = root.editPosition;
        pluginApi.saveSettings();
    }
}
