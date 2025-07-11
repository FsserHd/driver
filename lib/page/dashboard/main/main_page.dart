
import 'package:driver/constants/api_constants.dart';
import 'package:driver/constants/app_colors.dart';
import 'package:driver/constants/app_style.dart';
import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:driver/navigation/page_navigation.dart';
import 'package:driver/utils/preference_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../controller/home_controller.dart';
import '../../chat/order_chat_page.dart';
import '../../reject/order_reject_page.dart';

class MainPage extends StatefulWidget {
  Function() updatePage;
  MainPage(this.updatePage, {super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends StateMVC<MainPage> with WidgetsBindingObserver {

  Offset offset = Offset.zero;
  String _currentLocation = "Fetching location...";

  late HomeController con;

  _MainPageState() : super(HomeController()) {
    con = controller as HomeController;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        con.listNewOrderNotifications();
        con.listMainPage();
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
  void initState() {
    // TODO: implement initState
    super.initState();
    con.listMainPage();
    _determinePosition();
    con.listNewOrderNotifications();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      con.listMainPage();
      con.listNewOrderNotifications();
    });
  }

  Future<void> _determinePosition() async {
    LocationPermission permission;
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

  @override
  Widget build(BuildContext context) {

    return con.mainPageResponse.data!=null ? Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     width: double.infinity,
            //     child: Card(child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Column(
            //         children: [
            //           Text("Current Location: ",style: AppStyle.font14MediumBlack87,),
            //           SizedBox(height: 2,),
            //           Text(_currentLocation,style: AppStyle.font14MediumBlack87.override(fontSize: 16),),
            //         ],
            //       ),
            //     )),
            //   ),
            // ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){

                      FlutterPhoneDirectCaller.callNumber(con.mainPageResponse.sos!);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red, // Background color
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),bottomRight: Radius.circular(10.0)), // Rounded corners
                        border: Border.all(
                          color: Colors.red, // Light gray border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.call,color: Colors.white, size: 12,),
                            SizedBox(width: 5,),
                            Text("SOS",style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.white),),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text("Dashboard",style: AppStyle.font14MediumBlack87.override(fontSize: 14),),
                  InkWell(child: Stack(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.support_agent,color: AppColors.themeColor,size: 25,),
                          SizedBox(height: 2,),
                          Text("Chat",style: AppStyle.font14MediumBlack87.override(fontSize: 14),)
                        ],
                      ),
                      Badge(
                        label: Text(
                          con.mainPageResponse.data!.overallchatcount.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Container(),
                      ),
                    ],
                  ),
                    onTap: () async {
                      String? userId = await PreferenceUtils.getUserId();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderChatPage(userId!, "admin","driver"),
                        ),
                      ).then((value){
                        con.listMainPage();
                      });
                    },),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 10,),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: InkWell(
                  //         onTap: (){
                  //           PageNavigation.gotoHomeOrderPage(context,"on_finish");
                  //         },
                  //         child: Container(
                  //           height: 60,
                  //           width: double.infinity,
                  //           decoration: BoxDecoration(
                  //             color: AppColors.themeColor, // Background color
                  //             borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),bottomLeft: Radius.circular(10.0)), // Rounded corners
                  //             border: Border.all(
                  //               color: AppColors.themeColor, // Light gray border color
                  //               width: 2.0, // Border width
                  //             ),
                  //           ),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               SizedBox(width: 10,),
                  //               Image.asset("assets/images/circle.png"),
                  //               SizedBox(width: 10,),
                  //               Text(
                  //                 "Today Orders Delivered",
                  //                 style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       height: 60,
                  //       width: 60,
                  //       decoration: BoxDecoration(
                  //         color: Colors.grey.shade300, // Background color
                  //         borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),bottomRight: Radius.circular(10.0)), // Rounded corners
                  //         border: Border.all(
                  //           color: Colors.grey.shade300, // Light gray border color
                  //           width: 2.0, // Border width
                  //         ),
                  //       ),
                  //       child: Center(
                  //         child: Text(
                  //           con.mainPageResponse.data!.todaycount.toString(),
                  //           style: AppStyle.font14MediumBlack87.override(fontSize: 18,color: Colors.black),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            PageNavigation.gotoHomeOrderPage(context,"on_ready");
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.themeColor, // Background color
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),bottomLeft: Radius.circular(10.0)), // Rounded corners
                              border: Border.all(
                                color: AppColors.themeColor, // Light gray border color
                                width: 2.0, // Border width
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 10,),
                                Image.asset("assets/images/circle.png"),
                                SizedBox(width: 10,),
                                Text(
                                  "Current Ready Orders",
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300, // Background color
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),bottomRight: Radius.circular(10.0)), // Rounded corners
                          border: Border.all(
                            color: Colors.grey.shade300, // Light gray border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: Center(
                          child: Text(
                            con.mainPageResponse.data!.currentcount.toString(),
                            style: AppStyle.font14MediumBlack87.override(fontSize: 18,color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                  // SizedBox(height: 10,),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         height: 60,
                  //         width: double.infinity,
                  //         decoration: BoxDecoration(
                  //           color: AppColors.themeColor, // Background color
                  //           borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),bottomLeft: Radius.circular(10.0)), // Rounded corners
                  //           border: Border.all(
                  //             color: AppColors.themeColor, // Light gray border color
                  //             width: 2.0, // Border width
                  //           ),
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             SizedBox(width: 10,),
                  //             Image.asset("assets/images/circle.png"),
                  //             SizedBox(width: 10,),
                  //             Text(
                  //               "Today Service Completed",
                  //               style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       height: 60,
                  //       width: 60,
                  //       decoration: BoxDecoration(
                  //         color: Colors.grey.shade300, // Background color
                  //         borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),bottomRight: Radius.circular(10.0)), // Rounded corners
                  //         border: Border.all(
                  //           color: Colors.grey.shade300, // Light gray border color
                  //           width: 2.0, // Border width
                  //         ),
                  //       ),
                  //       child: Center(
                  //         child: Text(
                  //           con.mainPageResponse.data!.todayotherservicecount.toString(),
                  //           style: AppStyle.font14MediumBlack87.override(fontSize: 18,color: Colors.black),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            PageNavigation.gotoPendingServicePage(context);
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.themeColor, // Background color
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),bottomLeft: Radius.circular(10.0)), // Rounded corners
                              border: Border.all(
                                color: AppColors.themeColor, // Light gray border color
                                width: 2.0, // Border width
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 10,),
                                Image.asset("assets/images/circle.png"),
                                SizedBox(width: 10,),
                                Text(
                                  "Pending Other Services",
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300, // Background color
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),bottomRight: Radius.circular(10.0)), // Rounded corners
                          border: Border.all(
                            color: Colors.grey.shade300, // Light gray border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: Center(
                          child: Text(
                            con.mainPageResponse.data!.overallotherservicependingcount.toString(),
                            style: AppStyle.font14MediumBlack87.override(fontSize: 18,color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                  // SizedBox(height: 10,),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         height: 60,
                  //         width: double.infinity,
                  //         decoration: BoxDecoration(
                  //           color: AppColors.themeColor, // Background color
                  //           borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),bottomLeft: Radius.circular(10.0)), // Rounded corners
                  //           border: Border.all(
                  //             color: AppColors.themeColor, // Light gray border color
                  //             width: 2.0, // Border width
                  //           ),
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             SizedBox(width: 10,),
                  //             Image.asset("assets/images/circle.png"),
                  //             SizedBox(width: 10,),
                  //             Text(
                  //               "Total Other Services",
                  //               style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       height: 60,
                  //       width: 60,
                  //       decoration: BoxDecoration(
                  //         color: Colors.grey.shade300, // Background color
                  //         borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),bottomRight: Radius.circular(10.0)), // Rounded corners
                  //         border: Border.all(
                  //           color: Colors.grey.shade300, // Light gray border color
                  //           width: 2.0, // Border width
                  //         ),
                  //       ),
                  //       child: Center(
                  //         child: Text(
                  //           con.mainPageResponse.data!.overallotherservicecount.toString(),
                  //           style: AppStyle.font14MediumBlack87.override(fontSize: 18,color: Colors.black),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.themeColor, // Background color
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),bottomLeft: Radius.circular(10.0)), // Rounded corners
                            border: Border.all(
                              color: AppColors.themeColor, // Light gray border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 10,),
                              Image.asset("assets/images/circle.png"),
                              SizedBox(width: 10,),
                              Text(
                                "In Hand Amount",
                                style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300, // Background color
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),bottomRight: Radius.circular(10.0)), // Rounded corners
                          border: Border.all(
                            color: Colors.grey.shade300, // Light gray border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: Center(
                          child: Text(
                            con.mainPageResponse.data!.inHandAmount!=null ? ApiConstants.currency+con.mainPageResponse.data!.inHandAmount.toString():"0",
                            style: AppStyle.font14MediumBlack87.override(fontSize: 18,color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text("Current New Orders",style: AppStyle.font14MediumBlack87.override(fontSize: 14),),
                  SizedBox(height: 10,),
                  if(con.notificationModel.data!=null)
                  ListView.builder(
                      itemCount: con.notificationModel.data!.length ,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        var orderData = con.notificationModel.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 0,right: 0,top: 10,bottom: 10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0)), // Rounded corners
                          border: Border.all(
                            color: AppColors.themeColor, // Light gray border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.themeColor, // Background color
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0),topRight: Radius.circular(8.0)), // Rounded corners
                                border: Border.all(
                                  color: AppColors.themeColor, // Light gray border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "New Orders",
                                    style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "From:",
                                          style: AppStyle.font14RegularBlack87.override(fontSize: 14,color: Colors.grey),
                                        ),
                                        Text(
                                          orderData.generalDetail!.storeName!,
                                          style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Order ID:",
                                          style: AppStyle.font14RegularBlack87.override(fontSize: 14,color: Colors.grey),
                                        ),
                                        Text(
                                          orderData.saleCode!,
                                          style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10,),
                                Image.asset("assets/images/order.png"),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white, // Background color
                                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                  border: Border.all(
                                    color: Colors.grey.shade300, // Light gray border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Delivery Address",style: AppStyle.font18BoldWhite.override(color: Colors.black87,fontSize: 14),),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(orderData.shippingAddress!.addressSelect!,style: AppStyle.font14RegularBlack87.override(color: Colors.black,fontSize: 14),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderRejectPage(orderData.saleCode!,orderData.vendor.toString()),
                                        ),
                                      ).then((value){
                                        con.listNewOrderNotifications();
                                        widget.updatePage();
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.red, // Background color
                                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Reject",
                                          style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.white),
                                        ),
                                      ),
                                      width: 120,
                                    ),
                                  ),
                                  InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.green, // Background color
                                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Accept",
                                          style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.white),
                                        ),
                                      ),
                                      width: 120,
                                    ),
                                    onTap: (){
                                      PreferenceUtils.clearNotificationData();
                                      con.changeOrderStatus(orderData.saleCode!, "on_going",context,widget.updatePage);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    ):Container();
  }
}
