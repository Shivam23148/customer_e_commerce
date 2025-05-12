import 'dart:io';

import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/* class NotificationService {
  final FirebaseMessaging _messaging = serviceLocator<FirebaseMessaging>();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      serviceLocator<FlutterLocalNotificationsPlugin>();

  Future<void> init() async {
    //Android Permission
    await _messaging.requestPermission();

    //Init Local Notificaion
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // Handle foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notificaiton = message.notification;
      if (notificaiton != null) {
        showNotificaiton(notificaiton.title!, notificaiton.body!);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void showNotificaiton(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);
    await _flutterLocalNotificationsPlugin.show(
        0, title, body, platformDetails);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
  }
}
 */
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    print("Initializing notifications...");

    // 1. Request permissions (Android 13+)
    await _requestPermissions();

    // 2. Configure notification channels
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    // 3. Initialize plugin
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification taps
      },
    );
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      print("Current permission status: $status");

      if (status.isDenied || status.isPermanentlyDenied) {
        final result = await Permission.notification.request();
        print("Permission request result: $result");

        if (result.isPermanentlyDenied) {
          await openAppSettings();
        }
      }
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      channelDescription: 'Important notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.show(id, title, body, platformDetails);
  }
}
