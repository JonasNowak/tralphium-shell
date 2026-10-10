import re

with open('./components/settings/pages/NetworkSection.qml', 'r') as f:
    content = f.read()

# Change z-index or move MouseArea inside RowLayout before IconButton?
# Actually, let's just make the MouseArea cover everything except the IconButton, or add `z: -1` to the MouseArea.
# A better way is to move MouseArea before RowLayout in the Rectangle.

content = re.sub(
    r'(RowLayout\s*{[^}]+IconButton\s*{\s*icon:\s*"delete"[^}]+}\s*}\s*}\s*MouseArea\s*{\s*id:\s*vpnMouse[^}]+})',
    lambda m: m.group(0).replace('MouseArea {', 'MouseArea {\n                            z: -1'),
    content
)

with open('./components/settings/pages/NetworkSection.qml', 'w') as f:
    f.write(content)

