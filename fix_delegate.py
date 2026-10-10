import re

with open('./components/settings/pages/NetworkSection.qml', 'r') as f:
    content = f.read()

# I will replace the MouseArea and RowLayout manually for both Wifi and VPN to make sure z-index or event propagation is perfect.
# It's better to just move MouseArea before RowLayout and not use z: -1, and use propagateComposedEvents: true if necessary,
# but since MouseArea is before RowLayout, RowLayout will be ON TOP. We just need to make sure RowLayout doesn't consume the event unless it's the Button/TextField.

# For now, I'll just remove `z: -1` and place it at the top of the Rectangle.

content = re.sub(r'\s*MouseArea {\s*id: netMouse\s*z: -1[^}]+onClicked: [^}]+}[^}]+}[^}]+}', '', content)
# It's too complex to regex. I'll just rewrite NetworkSection.qml.
