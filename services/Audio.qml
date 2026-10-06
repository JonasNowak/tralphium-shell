pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

// Default sink volume and sink selection through PipeWire (event driven, no processes).
Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0
    readonly property bool isMuted: sink && sink.audio ? sink.audio.muted : false
    
    // Returns sinks in a format compatible with ControlPanel ({ id, name, isDefault, node })
    readonly property var sinks: {
        const raw = Pipewire.nodes.values.filter(n => n.isSink && !n.isStream && n.audio);
        return raw.map(n => ({
            id: n.id,
            node: n,
            name: n.description || n.nickname || n.name,
            isDefault: Boolean(root.sink && root.sink.id === n.id)
        }));
    }

    // Nodes only expose their audio properties while tracked
    PwObjectTracker {
        objects: [root.sink].concat(Pipewire.nodes.values.filter(n => n.isSink && !n.isStream && n.audio))
    }

    // Compatibility functions for callers expecting refresh methods
    function refresh() {}
    function refreshSinks() {}

    function setVolume(value) {
        if (!sink || !sink.audio) return;
        sink.audio.volume = value;
        sink.audio.muted = false;
    }

    function toggleMute() {
        if (sink && sink.audio) sink.audio.muted = !sink.audio.muted;
    }

    function setDefaultSink(target) {
        if (!target) return;
        if (typeof target === "object" && target.isSink) {
            Pipewire.preferredDefaultAudioSink = target;
        } else {
            const found = Pipewire.nodes.values.find(n => n.id === target || n.id === parseInt(target));
            if (found) Pipewire.preferredDefaultAudioSink = found;
        }
    }
}
