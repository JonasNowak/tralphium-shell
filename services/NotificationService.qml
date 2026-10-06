pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property alias server: notifServer
    property ListModel toasts: ListModel {}
    property bool notificationsEnabled: Config.notificationsEnabled
    
    onNotificationsEnabledChanged: {
        if (!notificationsEnabled) {
            toasts.clear();
        }
        if (Config.notificationsEnabled !== notificationsEnabled) {
            Config.setNotificationsEnabled(notificationsEnabled);
        }
    }

    Connections {
        target: Config
        function onNotificationsEnabledChanged() {
            if (root.notificationsEnabled !== Config.notificationsEnabled) {
                root.notificationsEnabled = Config.notificationsEnabled;
            }
        }
    }

    NotificationServer {
        id: notifServer
        onNotification: notif => {
            notif.tracked = true;
            if (root.notificationsEnabled) {
                root.toasts.append({ "notif": notif });
            }
        }
    }
}
