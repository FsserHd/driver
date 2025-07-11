


import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:driver/model/firebase/firebase_order_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/app_style.dart';
import '../reject/order_reject_page.dart';

class IncomingNotificationPage extends StatefulWidget {

  IncomingNotificationPage( {super.key});

  @override
  State<IncomingNotificationPage> createState() => _IncomingNotificationPageState();
}

class _IncomingNotificationPageState extends State<IncomingNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Text("Test"),
        ],
      )
    );
  }
}
