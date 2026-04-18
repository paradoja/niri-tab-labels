pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Commons

Item {
  id: root

  property var pluginApi: null

  readonly property var cfg: pluginApi?.pluginSettings || ({})
  readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})
  readonly property string position: cfg.position ?? defaults.position ?? "top"

  function handleEvent(line) {
    if (!line) {
      return;
    }
    try {
      const ev = JSON.parse(line);
      const kind = Object.keys(ev)[0];
      console.log("niri-tab-labels event:", kind);
    } catch (e) {
      console.warn("niri-tab-labels: failed to parse line:", line, e);
    }
  }

  Process {
    id: niriEventStream

    command: ["niri", "msg", "--json", "event-stream"]
    running: true

    stdout: SplitParser {
      onRead: line => root.handleEvent(line)
    }

    onExited: code => {
      console.warn("niri-tab-labels: event-stream exited code=" + code);
      eventStreamRestart.start();
    }
  }

  Timer {
    id: eventStreamRestart
    interval: 2000
    repeat: false
    onTriggered: niriEventStream.running = true
  }

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
