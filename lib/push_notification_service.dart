import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Background handler for FCM messages.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages here.
}

/// Initializes Firebase Messaging, requesting iOS permissions
/// and setting up foreground/background message handlers.
Future<void> initFirebaseMessaging() async {
  // Request permission on iOS
  await FirebaseMessaging.instance.requestPermission();

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Show a local notification or handle it as desired
  });

  // Handle background/terminated messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
