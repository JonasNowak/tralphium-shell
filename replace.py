import re

with open('services/Network.qml', 'r') as f:
    content = f.read()

target = """                        if (ssid && !seen.has(ssid)) {
                            seen.add(ssid);
                            netList.push({ssid: ssid, active: active, signal: signal, security: security});
                        }"""

replacement = """                        if (ssid && !seen.has(ssid)) {
                            seen.add(ssid);
                            netList.push({ssid: ssid, active: active, signal: signal, security: security});
                            if (active) {
                                root.currentSignal = signal;
                                root.currentSecurity = (security !== "");
                            }
                        }"""

if target in content:
    content = content.replace(target, replacement)
    with open('services/Network.qml', 'w') as f:
        f.write(content)
    print("Replaced listReader successfully.")
else:
    print("Target not found!")
