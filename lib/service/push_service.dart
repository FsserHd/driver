

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message
  print('Handling a background message: ${message.messageId}');
}

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initialize() {
    // Request permission for iOS
    _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages
      _handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle messages opened from a terminated state
      _handleMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data.containsKey('screen')) {
      // Extract screen and navigate
      String screen = message.data['screen'];
      _navigateToScreen(screen);
    }
  }

  void _navigateToScreen(String screen) {
    // Add your navigation logic here
    // You can use Navigator or any other method to navigate
    // Example:
    // Navigator.pushNamed(context, screen);
  }
}
