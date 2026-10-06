import sys
#!/usr/bin/env python3
"""Generate a JSON list of apps from installed .desktop files."""
import configparser
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


def read_entry(path):
    """Return the [Desktop Entry] section of a .desktop file, or None."""
    with open(path, encoding='utf-8') as f:
        content = f.read()
    if '[Desktop Entry]' not in content:
        return None
    config = configparser.ConfigParser(interpolation=None)
    config.read_string('[Desktop Entry]\n' + content.split('[Desktop Entry]', 1)[1])
    return config['Desktop Entry']


def to_app(path):
    entry = read_entry(path)
    if entry is None or entry.get('NoDisplay', 'false').lower() == 'true' or not entry.get('Name'):
        return None
    app_id = os.path.basename(path).removesuffix('.desktop')
    icon = entry.get('Icon', '') or app_id.lower()
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
    print(json.dumps(result, indent=4, ensure_ascii=False))

if __name__ == '__main__':
    main()
