


import 'package:driver/constants/api_constants.dart';
import 'package:driver/constants/app_style.dart';
import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../controller/auth_controller.dart';

class ServiceEarningsPage extends StatefulWidget {
  const ServiceEarningsPage({super.key});

  @override
  _ServiceEarningsPageState createState() => _ServiceEarningsPageState();
}

class _ServiceEarningsPageState extends StateMVC<ServiceEarningsPage> {

  late AuthController _con;

  _ServiceEarningsPageState() : super(AuthController()) {
    _con = controller as AuthController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.serviceEarnings(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if(_con.serviceEarningsModel.completedamount!=null)
              Text("Total Earnings: "+ApiConstants.currency+_con.serviceEarningsModel.completedamount.toString(),style: AppStyle.font18BoldWhite.override(fontSize: 16,),),
              SizedBox(height: 10,),
              if(_con.serviceEarningsModel.pendingamount!=null)
              Text("Pending Earnings: "+ApiConstants.currency+_con.serviceEarningsModel.pendingamount.toString(),style: AppStyle.font18BoldWhite.override(fontSize: 16,),),
              SizedBox(height: 10,),
              if(_con.serviceEarningsModel.datalist!=null)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _con.serviceEarningsModel.datalist!.length,
                  itemBuilder: (context,index){
                var databean = _con.serviceEarningsModel.datalist![index];
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
                                    "Service ID: "+databean.serviceCode!,
                                    style: AppStyle.font18BoldWhite.override(fontSize: 12),
                                  ),
                                  SizedBox(height: 2,),
                                  Text(
                                    "Amount: ${ApiConstants.currency}"+databean.deliveryfees!,
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
      ),
    );
  }
}
