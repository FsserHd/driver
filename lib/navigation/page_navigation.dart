import 'package:driver/model/service/service_response_model.dart';
import 'package:driver/page/chat/order_chat_page.dart';
import 'package:driver/page/dashboard/dashboard_page.dart';
import 'package:driver/page/dashboard/notifications/notification_page.dart';
import 'package:driver/page/dashboard/order/home_order_page.dart';
import 'package:driver/page/dashboard/order/order_details_page.dart';
import 'package:driver/page/dashboard/profile/profile_page.dart';
import 'package:driver/page/dashboard/service/pending_service_page.dart';
import 'package:driver/page/dashboard/service/service_details_page.dart';
import 'package:driver/page/earnings/earnings_page.dart';
import 'package:driver/page/help/help_page.dart';
import 'package:driver/page/login/change_password_page.dart';
import 'package:driver/page/login/forgot_password.dart';
import 'package:driver/page/policy/policy_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../page/login/login_page.dart';

class PageNavigation{


  static gotoLoginScreen(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  static gotoDashboardPage(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashBoardPage(),
      ),
    );
  }

  static gotoOrderDetailsPage(BuildContext context,orderBean){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(orderBean),
      ),
    );
  }

  static gotoProfilePage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  static gotoChatPage(BuildContext context,String orderId,String type,String sender){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderChatPage(orderId, type,sender),
      ),
    );
  }

  static gotoPolicyPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PolicyPage(),
      ),
    );
  }

  static gotoHelpPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpPage(),
      ),
    );
  }

  static gotoForgotPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPasswordPage(),
      ),
    );
  }

  static gotoChangePassword(BuildContext context, String? phone){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangePasswordPage(phone),
      ),
    );
  }

  static gotoNotificationPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPage(),
      ),
    );
  }


  static gotoServiceDetailsPage(BuildContext context, Service serviceBean){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailsPage(serviceBean),
      ),
    );
  }

  static gotoHomeOrderPage(BuildContext context, String type){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeOrderPage(type),
      ),
    );
  }

  static gotoPendingServicePage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PendingServicePage(),
      ),
    );
  }

  static gotoEarningsPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EarningsPage(),
      ),
    );
  }

  static goLogout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    gotoLoginScreen(context);
  }

}