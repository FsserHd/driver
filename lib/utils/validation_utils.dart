

import 'package:driver/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_style.dart';

class ValidationUtils{

  static bool emptyValidation(String value){
    if(value.isNotEmpty && value!=null){
      return true;
    }else{
      return false;
    }
  }

  static bool emptyIntegerValidation(int value){
    if(value.toString().isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  static showAppToast(String value){
    Fluttertoast.showToast(
        msg: value,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.themeColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static saveUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userId);
  }

  static saveUserToken(String userToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token",userToken);
  }

  static Future<String?> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }


  static Widget showEmptyPage(String message,String icon){
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Image.asset(icon),
              SizedBox(height: 10,),
              Text(message,style: AppStyle.font18BoldWhite,),
            ],
          )
        ],
      ),
    );
  }

  static openGoogleMap(double latitude,double longitude) async {
      final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        throw 'Could not open the map.';
      }
  }

}