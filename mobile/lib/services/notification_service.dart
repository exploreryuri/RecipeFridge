import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static Future<void> init() async {
    AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'expiring_products',
        channelName: 'Expiring Products',
        channelDescription: 'Notifications for products nearing expiration',
      )
    ]);
  }

  static Future<void> notifyProduct(String name, DateTime expiresAt) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: expiresAt.millisecondsSinceEpoch.remainder(100000),
        channelKey: 'expiring_products',
        title: '$name expiring soon',
        body: 'Expires on ${expiresAt.toLocal()}',
      ),
    );
  }
}
