

import 'dart:async';

import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../navigation/page_navigation.dart';
import '../../utils/preference_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {


  String _currentLocation = "Fetching location...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkAndRequestLocationPermission(context);

  }



  Future<void> _checkAndRequestLocationPermission(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show an error.
      _showModalBottomSheet(context);
      //await Geolocator.requestPermission();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied.
        _showModalBottomSheet(context);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, open app settings.
      bool opened = await openAppSettings();
      if (!opened) {
        // Show an error if opening settings fails.
        _showModalBottomSheet(context);
      }
      return;
    }

    Timer(const Duration(seconds: 1), () async {
      String? userId = await PreferenceUtils.getUserId();
      if(userId!=null){
        PageNavigation.gotoDashboardPage(context);
      }else{
        PageNavigation.gotoLoginScreen(context);
      }
    });
    // Permissions are granted, get the current position.
   // _determinePosition();
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Icon(Icons.location_off_outlined,color: Colors.red,size: 40,),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Device location not enabled",style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 12),),
                      Text("Ensure your device location for a better delivery",style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 8),),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: () async {
                          checkLocationServices();
                        },
                        child: Container(
                          width: 120,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.themeColor, // Gray fill color
                            borderRadius: BorderRadius.circular(15.0), // Rounded corners
                          ),
                          child: Center(
                            child:   Text("Enable",style: AppStyle.font14MediumBlack87.override(color: Colors.white,fontSize: 12)),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),

            ],
          ),
        );
      },
    );
  }

  void checkLocationServices() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      String? userId = await PreferenceUtils.getUserId();
      if(userId!=null){
        PageNavigation.gotoDashboardPage(context);
      }else{
        PageNavigation.gotoLoginScreen(context);
      }
      // Recheck after user returns from location settings
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        setState(() {

        }); // Update UI after enabling location services
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset("assets/images/splash.png",height: 350,width: 350,),
          ],
        ),
      ),
    );
  }
}
