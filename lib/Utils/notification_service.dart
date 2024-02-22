import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  ///Initialize Notification in main screen
  Future<void> initNotification()async {
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload)async{});

    var initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse)async{
        });
  }


  notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails("channelId", "channelName",importance: Importance.high),
      iOS: DarwinNotificationDetails()
    );
  }

  ///Show Notification function use for showing notification
  Future showNotification({int id=0, String? title, String? body, String? payload})async{
         return flutterLocalNotificationsPlugin.show(id, title, body, await notificationDetails());
  }

  ///Remove/cancel Notification
  Future<void> removeNotification(int notificationId) async {
    print("--------->?Notification's REMOVED-----");
    //await flutterLocalNotificationsPlugin.cancel(notificationId);
    await flutterLocalNotificationsPlugin.cancelAll();
  }

}
