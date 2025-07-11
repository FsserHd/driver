

import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:driver/constants/app_style.dart';
import 'package:driver/controller/order_controller.dart';
import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:driver/model/notification/notification_model.dart';
import 'package:driver/navigation/page_navigation.dart';
import 'package:driver/page/dashboard/home/home_page.dart';
import 'package:driver/page/dashboard/main/main_page.dart';
import 'package:driver/page/dashboard/order/order_page.dart';
import 'package:driver/page/dashboard/profile/profile_page.dart';
import 'package:driver/page/dashboard/report/report_page.dart';
import 'package:driver/page/dashboard/service/service_page.dart';
import 'package:driver/page/reject/order_reject_page.dart';
import 'package:driver/utils/tracking_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constants/app_colors.dart';
import '../../controller/home_controller.dart';
import '../../model/firebase/firebase_order_response.dart';
import '../../network/api_service.dart';
import '../../utils/loader.dart';
import '../../utils/preference_utils.dart';
import '../../utils/validation_utils.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends StateMVC<DashBoardPage> with WidgetsBindingObserver {

  late HomeController _con;

  _DashBoardPageState() : super(HomeController()) {
    _con = controller as HomeController;
  }



  String title = "Profile";
  var icon = Icon(Icons.person,color: Colors.white,size: 24,);
  late final FirebaseMessaging _firebaseMessaging;

  updatePage(){
    _con.listMainPage();
  }


  late List<Widget> _widgetOptions;
  String _selectedItem = 'Select Reasons';


  static List<String> _widetTitle = <String>[
    "Dashboard",
    "Orders Report",
    "Orders",
    "Service"
  ];

  static List<Icon> _widetIcons = <Icon>[
    Icon(Icons.person,color: Colors.white,),
    Icon(Icons.person,color: Colors.white,),
    Icon(Icons.person,color: Colors.white,),
    Icon(Icons.person,color: Colors.white,),
    Icon(Icons.person,color: Colors.white,),
  ];

  int _remainingTime = 30;
  Timer? _timer;
  static late StreamSubscription<Position> _positionStreamSubscription;
  ApiService apiService = ApiService();
 bool isShowFoodDialog = false;
  void _onItemTapped(int index) {
    setState(() {
      _con.selectedIndex = index;
      title = _widetTitle[index];
      icon = _widetIcons[index];
    });
  }

  void startLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) async {
      PreferenceUtils.saveLatitude(position.latitude.toString());
      PreferenceUtils.saveLongitude(position.longitude.toString());
      _con.locationUpdate(context, position.latitude.toString(), position.longitude.toString());
    });
  }

  String _currentLocation = "Fetching location...";


  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    _widgetOptions = <Widget>[
      MainPage(updatePage),
      OrderPage(updatePage),
      ServicePage(updatePage),
      ReportPage()
    ];
    _firebaseMessaging = FirebaseMessaging.instance;
    _con.checkLiveStatus(context);
    startLocationTracking();
    _con.listMainPage();
    getFCMToken();
    _determinePosition();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //print(message.data.toString());
      //PreferenceUtils.saveNotificationData(message.data);

      var firebaseOrderResponse = FirebaseOrderResponse();
      firebaseOrderResponse = FirebaseOrderResponse();
      firebaseOrderResponse.vendorId = message.data['vendor_id'];
      firebaseOrderResponse.type = message.data['type'];
      firebaseOrderResponse.message = message.data['message'];
      firebaseOrderResponse.orderid = message.data['orderid'];
      print(firebaseOrderResponse.toJson());

      if(firebaseOrderResponse.type == "on_track") {
        playOrderSound();
        isShowFoodDialog = true;
       // PreferenceUtils.saveNotificationData(message.data);
       // checkOrderNotifications(context, firebaseOrderResponse);
      }else if(firebaseOrderResponse.type == "order_message"){
        showMessageNotification(firebaseOrderResponse);

      }else {
        // /startTimer();
        if(firebaseOrderResponse.type == "on_service"){
            playServiceOrderSound();
            _con.listMainPage();
            _showServiceDialog(context, _remainingTime,firebaseOrderResponse);
        }else if(firebaseOrderResponse.type == "on_notification"){
          showMessageNotification(firebaseOrderResponse);
        }else{
          if(firebaseOrderResponse.orderid!=null) {
            playOrderSound();
            _showOnReadyCustomDialog(
                context, _remainingTime, firebaseOrderResponse);
          }
        }
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   firebaseOrderResponse = FirebaseOrderResponse();
    //   firebaseOrderResponse.vendorId = message.data['vendor_id'];
    //   firebaseOrderResponse.type = message.data['type'];
    //   firebaseOrderResponse.orderid = message.data['orderid'];
    //
    //   playOrderSound();
    //   if(firebaseOrderResponse.type == "on_track") {
    //     checkOrderNotifications(context, firebaseOrderResponse.orderid!);
    //   }else {
    //     // /startTimer();
    //     if(firebaseOrderResponse.type == "on_service"){
    //       _showServiceDialog(context, _remainingTime);
    //     }else{
    //       _showOnReadyCustomDialog(context, _remainingTime);
    //     }
    //   }
    // });

    // PreferenceUtils.getNotificationData().then((value){
    //      if(value!=null) {
    //        Map<String, dynamic>? data = value;
    //        var firebaseOrderResponse = FirebaseOrderResponse();
    //        firebaseOrderResponse = FirebaseOrderResponse();
    //        firebaseOrderResponse.vendorId = data['vendor_id'];
    //        firebaseOrderResponse.type = data['type'];
    //        firebaseOrderResponse.orderid = data['orderid'];
    //        // playOrderSound();
    //        if(firebaseOrderResponse.type == "on_track") {
    //          isShowFoodDialog = true;
    //          checkOrderNotifications(context, firebaseOrderResponse);
    //        }
    //
    //      }else{
    //        print("no data found");
    //      }
    //    });

  }

  Future<void> showMessageNotification(FirebaseOrderResponse firebaseOrderResponse) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'channelId12',
      'channelName12',
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

  Future<void> _determinePosition() async {
    LocationPermission permission;

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = "Location services are disabled.";
      });
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = "Location permissions are permanently denied.";
      });
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      //_currentLocation = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      PreferenceUtils.saveLatitude(position.latitude.toString());
      PreferenceUtils.saveLongitude(position.longitude.toString());

      _getAddressFromLatLng(position);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        position!.latitude, position!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentLocation =
        '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
      PreferenceUtils.saveLocation(_currentLocation);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  checkOrderNotifications(BuildContext context, FirebaseOrderResponse firebaseOrderResponse){
    Loader.show();
    apiService.checkOrderNotifications(firebaseOrderResponse.orderid!).then((value){
      Loader.hide();
      if(value.data!=null){
          //startTimer();
          if (firebaseOrderResponse.type == "on_track") {
            if(isShowFoodDialog) {
              _showCustomDialog(
                  context, _remainingTime, value, firebaseOrderResponse);
            }
          } else if (firebaseOrderResponse.type == "on_service") {
            _showServiceDialog(context, _remainingTime,firebaseOrderResponse);
          } else {
            _showOnReadyCustomDialog(context, _remainingTime,firebaseOrderResponse);
          }         // data = null;
      }
    }).catchError((e){
      Loader.hide();
      print(e);
     // ValidationUtils.showAppToast("Something went wrong.");
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        // PreferenceUtils.getNotificationData().then((value){
        //   print(value.toString());
        //   if(value!=null) {
        //     Map<String, dynamic>? data = value;
        //     var firebaseOrderResponse = FirebaseOrderResponse();
        //     firebaseOrderResponse = FirebaseOrderResponse();
        //     firebaseOrderResponse.vendorId = data['vendor_id'];
        //     firebaseOrderResponse.type = data['type'];
        //     firebaseOrderResponse.orderid = data['orderid'];
        //     // playOrderSound();
        //     if(firebaseOrderResponse.type == "on_track") {
        //       if(!isShowFoodDialog) {
        //         checkOrderNotifications(context, firebaseOrderResponse);
        //       }
        //     }
        //
        //   }else{
        //     print("no data found");
        //   }
        // });
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");

        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  playBikeStartSound() async {
    await _audioPlayer.play(AssetSource("sound/bike.mp3"));
    setState(() {
      isPlaying = true;
    });
  }

  playOrderSound() async {
    await _audioPlayer.play(AssetSource("sound/order.wav"));
    setState(() {
      isPlaying = true;
    });
  }

  playServiceOrderSound() async {
    await _audioPlayer.play(AssetSource("sound/service.mp3"));
    setState(() {
      isPlaying = true;
    });
  }


  void getFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
    _con.updateFcmToken(context, token!);
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        try {
            _timer?.cancel();
        }catch(e){
          print(e.toString());
        }
      }
    });
  }




  void _showServiceDialog(BuildContext context, int remainingTime, FirebaseOrderResponse firebaseOrderResponse) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New Service Request",
                        style: AppStyle.font14MediumBlack87.override(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),

                  Image.asset("assets/images/received.png",height: 80,width: 80,),
                  SizedBox(height: 10,),
                  Text(
                    "Service ID:#${firebaseOrderResponse.orderid}",
                    style: AppStyle.font14MediumBlack87.override(fontSize: 16),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          _audioPlayer.stop();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/images/accept.png",height:  40,width: 40,fit: BoxFit.fill,),
                        ),
                      ),
                      // SizedBox(width: 120,),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Image.asset("assets/images/decline.png",height: 60,width: 60,fit: BoxFit.fill,),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCustomDialog(BuildContext context, int remainingTime, NotificationModel value, FirebaseOrderResponse firebaseOrderResponse) {
    isShowFoodDialog = true;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: 450,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New Orders",
                        style: AppStyle.font14MediumBlack87.override(fontSize: 16),
                      ),
                      SizedBox(width: 20,),

                    ],
                  ),
                  SizedBox(height: 20,),

                  Image.asset("assets/images/received.png",height: 80,width: 80,),
                  SizedBox(height: 10,),
                  Text(
                    "Shop Name:${value.data![0].shopName}",
                    maxLines: 1,overflow: TextOverflow.ellipsis,
                    style: AppStyle.font14MediumBlack87.override(fontSize: 16),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Order ID:#${firebaseOrderResponse.orderid}",
                    style: AppStyle.font14MediumBlack87.override(fontSize: 16),
                  ),

                  SizedBox(height: 20,),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                        border: Border.all(
                          color: Colors.grey.shade300, // Light gray border color
                          width: 1.0, // Border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivery Address:",
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 15),
                                ),
                                SizedBox(height: 2,),
                                Text(value.data![0].shippingAddress!.addressSelect!,style: AppStyle.font14RegularBlack87.override(color: Colors.black,fontSize: 14),),
                                SizedBox(height: 10,),
                              ],
                            ),
                            // Positioned(right: 0,
                            //     top: 0,
                            //     bottom: 0,
                            //     child: InkWell(
                            //         onTap: (){
                            //           ValidationUtils.openGoogleMap(value.data![0].shippingAddress!.latitude!,value.data![0].shippingAddress!.longitude!);
                            //         },
                            //         child: Image.asset("assets/images/map.png"))),
                          ],
                        ),
                      )),
                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          _audioPlayer.stop();
                          PreferenceUtils.clearNotificationData();
                          isShowFoodDialog = false;
                         // _con.changeOrderStatus(firebaseOrderResponse.orderid!, "on_going",context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/images/accept.png",height:  40,width: 40,fit: BoxFit.fill,),
                        ),
                      ),
                      SizedBox(width: 120,),
                      InkWell(
                        onTap: (){
                          _audioPlayer.stop();
                          isShowFoodDialog = false;
                          PreferenceUtils.clearNotificationData();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderRejectPage(firebaseOrderResponse.orderid!,firebaseOrderResponse.vendorId!),
                            ),
                          ).then((value){

                          });
                          //_showRejectedReasons(context);
                          //_con.orderRejectStatus(context,firebaseOrderResponse.orderid!,"Rejected","Heavy Rain",firebaseOrderResponse.vendorId!);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/images/decline.png",height: 60,width: 60,fit: BoxFit.fill,),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showOnReadyCustomDialog(BuildContext context, int remainingTime, FirebaseOrderResponse firebaseOrderResponse) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Order is Ready. \n Please pick the order now.",
                        textAlign: TextAlign.center,
                        style: AppStyle.font14MediumBlack87.override(fontSize: 16),
                      ),

                    ],
                  ),
                  SizedBox(height: 20,),

                  Image.asset("assets/images/received.png",height: 80,width: 80,),
                  SizedBox(height: 10,),
                  Text(
                    "Order ID:#${firebaseOrderResponse.orderid}",
                    style: AppStyle.font14MediumBlack87.override(fontSize: 16),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          _audioPlayer.stop();
                          Navigator.pop(context);
                          //_con.changeOrderStatus(firebaseOrderResponse.orderid!, "on_going",context);
                          _con.orderController.updateStatus("");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/images/accept.png",height:  40,width: 40,fit: BoxFit.fill,),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final maxDuration = Duration(seconds: 2);

        if (lastPressed == null || now.difference(lastPressed!) > maxDuration) {
          lastPressed = now;
          final snackBar = SnackBar(content: Text('Press back again to exit'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.themeColor,
          title: InkWell(
            onTap: (){
              //_showCustomDialog(context);
            },
            child: Row(
              children: [
                InkWell(
                  onTap: (){
                    PageNavigation.gotoProfilePage(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: icon,
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(child: Column(
                  children: [
                    Text("Current Location",style: AppStyle.font14MediumBlack87.override(color: Colors.white,fontSize: 12,),maxLines: 2,),
                    Text(_currentLocation,style: AppStyle.font14MediumBlack87.override(color: Colors.white,fontSize: 10,),maxLines: 2,),
                  ],
                )),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  PageNavigation.gotoNotificationPage(context);
                },
                  child: Icon(Icons.notifications_active,color: Colors.white,)),
            ),
            SizedBox(width: 5,),
            Switch.adaptive(
              value: _con.driverStatus,
              onChanged: (newValue) async {
                  if(newValue){
                    playBikeStartSound();
                  }
                  _con.statusUpdate(context, newValue);
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.black87,
              inactiveTrackColor: Colors.black26,
              inactiveThumbColor: FlutterFlowTheme.of(context).secondaryText,
            )
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_con.selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          backgroundColor:  AppColors.themeColor,
          unselectedItemColor: Colors.white, // Unselected icon color
          selectedItemColor: Colors.black45, // Selected icon color
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: _con.mainPageResponse.data!=null ? Badge(
                label: Text(
                  _con.mainPageResponse.data!.currentcount.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: Icon(Icons.ac_unit),
              ):Icon(Icons.ac_unit),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon:  _con.mainPageResponse.data!=null ? Badge(
                label: Text(
                  _con.mainPageResponse.data!.overallotherservicecount.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: Icon(Icons.design_services),
              ):Icon(Icons.design_services),
              label: 'Service',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_rounded),
              label: 'Report',
            ),
          ],
          currentIndex: _con.selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
