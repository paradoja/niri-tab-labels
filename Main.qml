import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons

Item {
  id: root

  property var pluginApi: null

  readonly property var cfg: pluginApi?.pluginSettings || ({})
  readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})
  readonly property string position: cfg.position ?? defaults.position ?? "top"

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      color: Color.mPrimary

      implicitHeight: 24
      implicitWidth: 32

      WlrLayershell.namespace: "noctalia:niri-tab-labels"
      WlrLayershell.layer: WlrLayer.Top
      WlrLayershell.exclusionMode: ExclusionMode.Ignore

      anchors {
        top: root.position === "top" || root.position === "side"
        bottom: root.position === "bottom" || root.position === "side"
        left: true
        right: root.position !== "side"
      }
    }
  }
}
