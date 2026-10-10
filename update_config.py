import re

with open('./services/Config.qml', 'r') as f:
    content = f.read()

# Add properties
props = """
    property bool voiceAssistantEnabled: true
    property string searchEngine: "Google"
    property bool phoneHubEnabled: true
    property bool accessibilityHighContrast: false
    property bool accessibilityLargeCursor: false
    property bool accessibilityScreenReader: false
    property bool privacyCameraAccess: true
    property bool privacyMicAccess: true
    property bool privacyLocationAccess: true
    property string displaysResolution: "1920x1080"
    property string keyboardLayout: "us"
    property int powerSleepTimeout: 30
    property bool syncOnlineAccountsEnabled: true
"""

content = re.sub(
    r'(property string shelfPosition: "bottom")',
    r'\1\n' + props,
    content
)

# Add to _doSave
save_props = """
            voiceAssistantEnabled: root.voiceAssistantEnabled,
            searchEngine: root.searchEngine,
            phoneHubEnabled: root.phoneHubEnabled,
            accessibilityHighContrast: root.accessibilityHighContrast,
            accessibilityLargeCursor: root.accessibilityLargeCursor,
            accessibilityScreenReader: root.accessibilityScreenReader,
            privacyCameraAccess: root.privacyCameraAccess,
            privacyMicAccess: root.privacyMicAccess,
            privacyLocationAccess: root.privacyLocationAccess,
            displaysResolution: root.displaysResolution,
            keyboardLayout: root.keyboardLayout,
            powerSleepTimeout: root.powerSleepTimeout,
            syncOnlineAccountsEnabled: root.syncOnlineAccountsEnabled,
"""

content = re.sub(
    r'(shelfPosition: root\.shelfPosition,)',
    r'\1\n' + save_props,
    content
)

# Add to _handleLoaded
load_props = """
            if (data.voiceAssistantEnabled !== undefined) root.voiceAssistantEnabled = Boolean(data.voiceAssistantEnabled);
            if (data.searchEngine !== undefined) root.searchEngine = String(data.searchEngine);
            if (data.phoneHubEnabled !== undefined) root.phoneHubEnabled = Boolean(data.phoneHubEnabled);
            if (data.accessibilityHighContrast !== undefined) root.accessibilityHighContrast = Boolean(data.accessibilityHighContrast);
            if (data.accessibilityLargeCursor !== undefined) root.accessibilityLargeCursor = Boolean(data.accessibilityLargeCursor);
            if (data.accessibilityScreenReader !== undefined) root.accessibilityScreenReader = Boolean(data.accessibilityScreenReader);
            if (data.privacyCameraAccess !== undefined) root.privacyCameraAccess = Boolean(data.privacyCameraAccess);
            if (data.privacyMicAccess !== undefined) root.privacyMicAccess = Boolean(data.privacyMicAccess);
            if (data.privacyLocationAccess !== undefined) root.privacyLocationAccess = Boolean(data.privacyLocationAccess);
            if (data.displaysResolution !== undefined) root.displaysResolution = String(data.displaysResolution);
            if (data.keyboardLayout !== undefined) root.keyboardLayout = String(data.keyboardLayout);
            if (data.powerSleepTimeout !== undefined) root.powerSleepTimeout = Number(data.powerSleepTimeout);
            if (data.syncOnlineAccountsEnabled !== undefined) root.syncOnlineAccountsEnabled = Boolean(data.syncOnlineAccountsEnabled);
"""

content = re.sub(
    r'(if \(data\.shelfPosition !== undefined\) root\.shelfPosition = String\(data\.shelfPosition\);)',
    r'\1\n' + load_props,
    content
)

with open('./services/Config.qml', 'w') as f:
    f.write(content)
