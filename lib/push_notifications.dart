import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flavour/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum AppState {
  foreground,
  background,
  terminated,
}

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  bool notificationArrivedInTerminatedState = false;

  /// notification channel for sending local notifications in android.
  final AndroidNotificationChannel _androidForegroundNotificationChannel = AndroidNotificationChannel(
    'app_notification_channel', // id: To be same in Android manifest file for [default_notification_channel_id]
    'High Importance Notifications',
    'This channel is used for important notifications.',
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    _setFCMToken();
    _configure();
  }

  void _setFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String token = await messaging.getToken();
      print('FirebaseMessaging token: $token');
    }
  }

  void _configure() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotificationInAndroid(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotification(message: message.data, appState: AppState.foreground);
    });

    RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleNotification(message: initialMessage.data, appState: AppState.terminated);
    }
  }

  void _showForegroundNotificationInAndroid(RemoteMessage message) async {
    if (Platform.isAndroid) {
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
      final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
        print(payload);
        _handleNotification(message: jsonDecode(payload), appState: AppState.foreground);
      });
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidForegroundNotificationChannel);
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        await _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidForegroundNotificationChannel.id,
              _androidForegroundNotificationChannel.name,
              _androidForegroundNotificationChannel.description,
              icon: android?.smallIcon,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    }
  }

  void _handleNotification({
    Map<String, dynamic> message,
    AppState appState,
  }) async {
    dynamic data = message['data'] ?? message;
    if (data != null) {
      var metadata = data['metadata'];
      if (metadata != null && metadata.toString().isNotEmpty) {
        var decodedMap = jsonDecode(metadata);

        LoggerInst.print('decodedMap $decodedMap');
      }
    }
  }
}
