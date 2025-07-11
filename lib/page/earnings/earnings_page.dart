


import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:driver/page/earnings/order_earnings_page.dart';
import 'package:driver/page/earnings/service_earnings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  _EarningsPageState createState() => _EarningsPageState();
}

class _EarningsPageState extends StateMVC<EarningsPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Earnings",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart,color: Colors.white,),
                  SizedBox(width: 8),
                  Text('Orders',style: AppStyle.font18BoldWhite.override(fontSize: 14,color:  Colors.white,),),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.build,color: Colors.white,),
                  SizedBox(width: 8),
                  Text('Service',style: AppStyle.font18BoldWhite.override(fontSize: 14,color:  Colors.white,),),
                ],
              ),
            ),

          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrderEarningsPage(),
          ServiceEarningsPage(),
        ],
      ),
    );
  }
}
