

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils{


  static saveUserType(String userType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userType", userType);
  }

  static Future<String?> getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userType");
  }


  static saveUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userId);
  }

  static saveLatitude(String latitude) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("latitude", latitude);
  }

  static saveLocation(String latitude) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("location", latitude);
  }


  static saveLongitude(String longitude) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("longitude", longitude);
  }

  static Future<String?> getLatitude() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("latitude");
  }

  static Future<String?> getLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("location");
  }

  static Future<String?> getLongitude() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("longitude");
  }


  static saveUserToken(String userToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token",userToken);
  }

  static saveAddressId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("addressId",id);
  }

  static getAddressId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("addressId");
  }

  static Future<String?> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

  static saveZoneId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("zoneId",id);
  }

  static getZoneId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("zoneId");
  }

  static Future<void> saveNotificationData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(data);
    await prefs.setString('notification_data', jsonString);
  }

  static Future<Map<String, dynamic>?> getNotificationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('notification_data');
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }
  static Future<void> clearNotificationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("notification_data");
  }

}