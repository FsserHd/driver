import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:driver/page/notification/incoming_notification_page.dart';
import 'package:driver/page/splash/splash_page.dart';
import 'package:driver/utils/preference_utils.dart';
import 'package:driver/utils/time_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/app_colors.dart';
import 'constants/app_style.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'language/app_localizations.dart';
import 'model/firebase/firebase_order_response.dart';
import 'navigation/navigation_service.dart';

final AudioPlayer _audioPlayer = AudioPlayer();

playOrderSound() async {
  await _audioPlayer.play(AssetSource("sound/order.wav"));
}

playServiceOrderSound() async {
  await _audioPlayer.play(AssetSource("sound/service.mp3"));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCD307r1TTsBbvJ_9ibBwUp4254v5ySHPc',
        appId: '1:211166356684:android:9758b8f5877423a9968e69',
        messagingSenderId: '211166356684',
        projectId: 'square-new-d8e68',
        storageBucket: 'square-new-d8e68.appspot.com',
      ),
    );
    initializeService();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _requestPermissions();
  }
  runApp(OverlaySupport.global(child: MyApp()));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCD307r1TTsBbvJ_9ibBwUp4254v5ySHPc',
      appId: '1:211166356684:android:9758b8f5877423a9968e69',
      messagingSenderId: '211166356684',
      projectId: 'square-new-d8e68',
      storageBucket: 'square-new-d8e68.appspot.com',
    ),
  );
  // Handle background message
  var firebaseOrderResponse = FirebaseOrderResponse();
  firebaseOrderResponse.type = message.data['type'];
  firebaseOrderResponse.message = message.data['message'];
  if(firebaseOrderResponse.type == "on_service"){
    showNotification("4square Service request");
    playServiceOrderSound();
  }else if(firebaseOrderResponse.type == "on_notification"){
    showMessageNotification(firebaseOrderResponse);
  } else if(firebaseOrderResponse.type == "order_message"){
    showMessageNotification(firebaseOrderResponse);
  }else {
    showNotification("4square Order request");
    playOrderSound();
  }
  print(firebaseOrderResponse.toJson());
 // PreferenceUtils.saveNotificationData(message.data);

}

Future<void> showNotification(String s) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidDetails =
  AndroidNotificationDetails(
    'channelId',
    'channelName',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
    0,
    s,
    'Tap to open the app',
    notificationDetails,
    payload: 'notification_payload',
  );
}

Future<void> showMessageNotification(FirebaseOrderResponse firebaseOrderResponse) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidDetails =
  AndroidNotificationDetails(
    'channelId1',
    'channelName1',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
    0,
    '4square',
    firebaseOrderResponse.message,
    notificationDetails,
    payload: 'notification_payload',
  );
}



Future<void> _requestPermissions() async {
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
}

@pragma('vm:entry-point')
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //  playOrderSound();
    //PreferenceUtils.saveNotificationData(message.data);
    //await FlutterOverlayApps.showOverlay(height: 300, width: 400, alignment: OverlayAlignment.center);
  });
  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
      print("onBackground 4Square");
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
      print("onBackground 4Square");
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
    print("onBackground 4Square");
  });

  // bring to foreground
  // Timer.periodic(const Duration(seconds: 1), (timer) async {
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {
  //       flutterLocalNotificationsPlugin.show(
  //         888,
  //         '4SQUARE SERVICE',
  //         'Listening your orders..',
  //         const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             'my_foreground',
  //             'MY FOREGROUND SERVICE',
  //             icon: 'ic_bg_service_small',
  //             ongoing: true,
  //           ),
  //         ),
  //       );
  //
  //       // if you don't using custom notification, uncomment this
  //       service.setForegroundNotificationInfo(
  //         title: "4Square Driver Service",
  //         content: "Updated at ${TimeUtils.convertDateTime(DateTime.now())}",
  //       );
  //     }
  //   }
  //   print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
  //   service.invoke(
  //     'update',
  //     {
  //       "current_date": DateTime.now().toIso8601String(),
  //       "device": "Android",
  //     },
  //   );
  // });
}



// overlay entry point
@pragma("vm:entry-point")
void showOverlay() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(child: Text("My overlay"))
  ));
}


class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp>  with WidgetsBindingObserver {

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  void setThemeMode(ThemeMode mode) => setState(() {
    _themeMode = mode;
    FlutterFlowTheme.saveThemeMode(mode);
  });


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        //SystemNavigator.pop();
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message opened app");
    });
  }


  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayColor: Colors.grey.withOpacity(0.5),
      useDefaultLoading: false,
      overlayWidgetBuilder: (_) { //ignored progress for the moment
        return Center(
          child: SpinKitThreeBounce(
            color: AppColors.themeColor,
            size: 50.0,
          ),
        );
      },
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey, // set property
        locale: Locale('en'), // Default locale
        supportedLocales: [
          Locale('en', ''),
          Locale('es', ''),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(brightness: Brightness.light),
        themeMode: ThemeMode.light,
        title: '4square',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.themeColor),
          useMaterial3: true,
          fontFamily: AppStyle.robotoRegular,
    
        ),
        home: SplashPage(),
      ),
    );
  }

}
