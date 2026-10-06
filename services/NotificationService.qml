pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property alias server: notifServer
    property ListModel toasts: ListModel {}
    property bool notificationsEnabled: true
    
    onNotificationsEnabledChanged: {
        if (!notificationsEnabled) {
            toasts.clear();
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
