

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_util.dart';

class TimeUtils{

  static String convertMonthDateYear(String date){
    DateTime inputDate = DateFormat("yyyy-MM-dd").parse(date);
    return DateFormat("MMM dd, yyyy").format(inputDate);
  }

  static String convertMonthOnly(String date){
    DateTime inputDate = DateFormat("yyyy-MM-dd").parse(date);
    return DateFormat("MMM").format(inputDate);
  }
  static String convertYearOnly(String date){
    DateTime inputDate = DateFormat("yyyy-MM-dd").parse(date);
    return DateFormat("yyyy").format(inputDate);
  }

  static String convertUTC(String date){
    final DateTime dateTime = DateTime.parse(date);
    String formattedDateTime = DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
    return formattedDateTime;
  }

  static String convertYearMonthDate(String date){
    final DateTime dateTime = DateTime.parse(date);
    String formattedDateTime = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDateTime;
  }

  static String convertDateTime(DateTime time){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yyyy HH:mm:ss').format(now);
    return formattedDate; // Output: 13 Jul 2024 12:33:03
  }

  static String getDateComparison(DateTime currentDate, String date) {
    DateTime targetDate = DateTime.parse(date);
    if (currentDate.year == targetDate.year &&
        currentDate.month == targetDate.month &&
        currentDate.day == targetDate.day) {
      return 'Today';
    } else if (currentDate.year == targetDate.year &&
        currentDate.month == targetDate.month &&
        currentDate.day + 1 == targetDate.day) {
      return 'Tomorrow';
    } else {
      return convertUTC(targetDate.toString()); // Format: YYYY-MM-DD
    }
  }

  static String getTimeStampToDate(int timeStamp){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String formattedDate = DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
    return formattedDate;
  }

  static int getTimestamp() {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch ~/ 1000;  // Unix timestamp in seconds
  }


}