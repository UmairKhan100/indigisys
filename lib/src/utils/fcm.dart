import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../resources/db_provider.dart';

final dbProvider = DbProvider();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage) async {
  String vehicleNumber = remoteMessage.notification!.title!;
  String alarmName = remoteMessage.notification!.body!;
  String gpsTime = remoteMessage.data['gpsTime'];
  int customerId = int.parse(remoteMessage.data['customerId']);
  dbProvider.addNotification(customerId, alarmName, gpsTime, vehicleNumber);
}

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future generateDeviceRecognitionToken() async {
    String? deviceRecognitionToken = await messaging.getToken();
    return deviceRecognitionToken;
  }

  Future whenNotificationReceived(context) async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 1. Terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        showNotificationWhenOpenApp(
          remoteMessage,
          context,
        );
      }
    });

    // 2. Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        showNotificationWhenOpenApp(
          remoteMessage,
          context,
        );
      }
    });

    // 3. Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        showNotificationWhenOpenApp(
          remoteMessage,
          context,
        );
      }
    });
  }

  Future showNotificationWhenOpenApp(
      RemoteMessage remoteMessage, context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange,
        content: Text(
          '${remoteMessage.notification!.title!} - ${remoteMessage.notification!.body!}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );

    String vehicleNumber = remoteMessage.notification!.title!;
    String alarmName = remoteMessage.notification!.body!;
    String gpsTime = remoteMessage.data['gpsTime'];
    int customerId = int.parse(remoteMessage.data['customerId']);
    dbProvider.addNotification(customerId, alarmName, gpsTime, vehicleNumber);
  }
}
