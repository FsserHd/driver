


import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constants/api_constants.dart';
import '../../constants/app_style.dart';
import '../../controller/auth_controller.dart';

class OrderEarningsPage extends StatefulWidget {
  const OrderEarningsPage({super.key});

  @override
  _OrderEarningsPageState createState() => _OrderEarningsPageState();
}

class _OrderEarningsPageState extends StateMVC<OrderEarningsPage> {

  late AuthController _con;

  _OrderEarningsPageState() : super(AuthController()) {
    _con = controller as AuthController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.orderEarnings(context);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if(_con.orderEarningsModel.completedamount!=null)
            Text("Total Earnings: "+ApiConstants.currency+_con.orderEarningsModel.completedamount.toString(),style: AppStyle.font18BoldWhite.override(fontSize: 16,),),

            SizedBox(height: 10,),
            if(_con.orderEarningsModel.pendingamount!=null)
            Text("Pending Earnings: "+ApiConstants.currency+_con.orderEarningsModel.pendingamount.toString(),style: AppStyle.font18BoldWhite.override(fontSize: 16,),),
            SizedBox(height: 10,),
            if(_con.orderEarningsModel.datalist!=null)
            ListView.builder(
                shrinkWrap: true,
                itemCount: _con.orderEarningsModel.datalist!.length,
                itemBuilder: (context,index){
                  var databean = _con.orderEarningsModel.datalist![index];
                  return  Padding(
                    padding: const EdgeInsets.only(top: 10),
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
                                    Text(
                                      "Order ID: "+databean.saleCode!,
                                      style: AppStyle.font18BoldWhite.override(fontSize: 12),
                                    ),
                                    SizedBox(height: 2,),
                                    Text(
                                      "Amount: ${ApiConstants.currency}"+databean.driverCharge!,
                                      style: AppStyle.font18BoldWhite.override(fontSize: 12,color: Colors.black87),
                                    ),
                                    SizedBox(height: 2,),
                                    Text(
                                      "Status: "+databean.settlement!,
                                      style: AppStyle.font18BoldWhite.override(fontSize: 12,color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
