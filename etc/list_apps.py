#!/usr/bin/env python3
"""Print a compact JSON list of apps from installed .desktop files."""
import glob
import json
import os

SEARCH_PATHS = [
    '/usr/share/applications',
    '/usr/local/share/applications',
    '~/.local/share/applications',
    '/var/lib/flatpak/exports/share/applications',
    '~/.local/share/flatpak/exports/share/applications',
    '/var/lib/snapd/desktop/applications',
]
KEYS = ('Name', 'NoDisplay', 'Icon', 'Exec')


def read_entry(path):
    """Return the wanted keys of the [Desktop Entry] section (stops reading after it)."""
    entry = {}
    in_entry = False
    with open(path, encoding='utf-8') as f:
        for line in f:
            if line.startswith('['):
                if in_entry:
                    break
                in_entry = line.strip() == '[Desktop Entry]'
            elif in_entry:
                key, _, value = line.partition('=')
                if key.strip() in KEYS:
                    entry[key.strip()] = value.strip()
    return entry


def to_app(path):
    entry = read_entry(path)
    if entry.get('NoDisplay', 'false').lower() == 'true' or not entry.get('Name'):
        return None
    app_id = os.path.basename(path).removesuffix('.desktop')
    icon = entry.get('Icon') or app_id.lower()
    return {
        'id': app_id,
        'name': entry['Name'],
        'icon': 'file://' + icon if icon.startswith('/') else 'image://icon/' + icon,
        'exec': entry.get('Exec', '').split('%')[0].strip(),
    }


def main():
    apps = {}
    for base in SEARCH_PATHS:
        for path in glob.glob(os.path.join(os.path.expanduser(base), '**/*.desktop'), recursive=True):
            try:
                app = to_app(path)
            except Exception:
                continue
            if app:
                apps.setdefault(app['name'], app)  # first match wins

    result = sorted(apps.values(), key=lambda a: a['name'].lower())
    print(json.dumps(result, separators=(',', ':'), ensure_ascii=False))


if __name__ == '__main__':
    main()
