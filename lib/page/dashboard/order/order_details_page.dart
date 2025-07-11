

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/constants/api_constants.dart';
import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:driver/navigation/page_navigation.dart';
import 'package:driver/utils/tracking_utils.dart';
import 'package:driver/utils/validation_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_style.dart';
import '../../../controller/order_controller.dart';
import '../../../model/order/order_response.dart';
import '../../../utils/preference_utils.dart';
import '../../../utils/time_utils.dart';

class OrderDetailsPage extends StatefulWidget {

  OrderDetails orderDetails;

  OrderDetailsPage(this.orderDetails, {super.key});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends StateMVC<OrderDetailsPage> {
  late OrderController _con;

  _OrderDetailsPageState() : super(OrderController()) {
    _con = controller as OrderController;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.orderDetails.deliveryState == "on_picked" || widget.orderDetails.deliveryState == "on_reached"){
        TrackingUtils.startTracking(widget.orderDetails.saleCode!,widget.orderDetails.deliveryState);
    }
    //_con.changeOrderStatus(widget.orderDetails.saleCode!, "on_going",context);
  }

  updateLocation() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String? userId = await PreferenceUtils.getUserId();
    await _firestore.collection('driverTrack').doc(widget.orderDetails.saleCode).set({
      'driverId': userId!,
      'latitude': await PreferenceUtils.getLatitude(),
      'longitude': await PreferenceUtils.getLongitude(),
      'order_status': widget.orderDetails.deliveryState,
    });
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
        title: Text("Order Details",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
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
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey.shade300, // Light gray border color
                                      width: 1.0, // Border width
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Order ID:#${widget.orderDetails.saleCode}",style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                                  )),

                              SizedBox(height: 2,),
                              Text( TimeUtils.getTimeStampToDate(int.parse(widget.orderDetails.paymentTimestamp!)),style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),)
                            ],
                          ),
                          Column(
                            children: [
                              Text("Total Item",style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 12),),
                              SizedBox(height: 5,),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: AppColors.themeColor,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.orderDetails.productDetails!.length.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Text("Order Products",style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                      ListView.builder(
                          physics:
                          const NeverScrollableScrollPhysics(),
                          itemCount: widget.orderDetails.productDetails!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, dindex) {
                            var productBean  = widget.orderDetails.productDetails![dindex];
                            return Padding(
                              padding:
                              const EdgeInsets.only(
                                  top: 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Image.asset(
                                      //   "assets/images/non_veg.png",
                                      //   height: 14,
                                      // ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        "${productBean.qty}x",
                                        style: AppStyle
                                            .font14MediumBlack87
                                            .override(
                                            color: Colors
                                                .black,
                                            fontSize:
                                            14,
                                            fontWeight:
                                            FontWeight
                                                .bold),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        productBean.productName!,
                                        style: AppStyle
                                            .font14MediumBlack87
                                            .override(
                                            color: Colors
                                                .black,
                                            fontSize:
                                            14,
                                            fontWeight:
                                            FontWeight
                                                .bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                      if(widget.orderDetails.addonDetails!=null && widget.orderDetails.addonDetails!.isNotEmpty)
                      SizedBox(height: 10,),
                      if(widget.orderDetails.addonDetails!=null && widget.orderDetails.addonDetails!.isNotEmpty)
                      Text("Add On Products",style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                      if(widget.orderDetails.addonDetails!=null && widget.orderDetails.addonDetails!.isNotEmpty)
                      ListView.builder(
                          physics:
                          const NeverScrollableScrollPhysics(),
                          itemCount: widget.orderDetails.addonDetails!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, dindex) {
                            var addOnBean  = widget.orderDetails.addonDetails![dindex];
                            return Padding(
                              padding:
                              const EdgeInsets.only(
                                  top: 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Image.asset(
                                      //   "assets/images/non_veg.png",
                                      //   height: 14,
                                      // ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        "${addOnBean.qty}x",
                                        style: AppStyle
                                            .font14MediumBlack87
                                            .override(
                                            color: Colors
                                                .black,
                                            fontSize:
                                            14,
                                            fontWeight:
                                            FontWeight
                                                .bold),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        addOnBean.name!,
                                        style: AppStyle
                                            .font14MediumBlack87
                                            .override(
                                            color: Colors
                                                .black,
                                            fontSize:
                                            14,
                                            fontWeight:
                                            FontWeight
                                                .bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,),
             widget.orderDetails.deliveryState != "on_finish" ?
             Container(
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
                              Text("Delivery Address",style: AppStyle.font18BoldWhite.override(color: AppColors.themeColor,fontSize: 16),),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            border: Border.all(
                              color: Colors.grey.shade300, // Light gray border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.orderDetails.address!.addressSelect!,style: AppStyle.font14RegularBlack87.override(color: Colors.black,fontSize: 14),),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.call,color: AppColors.themeColor,),
                                              ),
                                              onTap: (){
                                                FlutterPhoneDirectCaller.callNumber(widget.orderDetails.address!.phone!);
                                              },
                                            ),
                                            SizedBox(width: 5,),
                                            InkWell(
                                              onTap: (){
                                                PageNavigation.gotoChatPage(context,widget.orderDetails.saleCode!,"user","driver");
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.chat,color: AppColors.themeColor,),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: InkWell(
                                        onTap: (){
                                          ValidationUtils.openGoogleMap(widget.orderDetails.address!.latitude!,widget.orderDetails.address!.longitude!);
                                        },
                                        child: Image.asset("assets/images/map.png"))),
                              ],
                            ),
                          )),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Shop Address",style: AppStyle.font18BoldWhite.override(color: AppColors.themeColor,fontSize: 16),),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            border: Border.all(
                              color: Colors.grey.shade300, // Light gray border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.orderDetails.vendor!.address!,style: AppStyle.font14RegularBlack87.override(color: Colors.black,fontSize: 14),),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.call,color: AppColors.themeColor,),
                                          ),
                                          onTap: (){
                                            FlutterPhoneDirectCaller.callNumber(widget.orderDetails.vendor!.phone!);
                                          },
                                        ),

                                      ],
                                    ),

                                  ],
                                ),
                                Positioned(right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: InkWell(
                                        onTap: (){
                                          ValidationUtils.openGoogleMap(double.parse(widget.orderDetails.vendor!.latitude!),double.parse(widget.orderDetails.vendor!.longitude!));
                                        },
                                        child: Image.asset("assets/images/map.png"))),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ):Container(),
              SizedBox(height: 30,),
              Container(
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
                              Text("Payment Details",style: AppStyle.font18BoldWhite.override(color: AppColors.themeColor,fontSize: 16),),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            border: Border.all(
                              color: Colors.grey.shade300, // Light gray border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if( widget.orderDetails.deliveryState == "on_finish")
                                Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Delivery Fees",style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                                        Text(ApiConstants.currency+widget.orderDetails.driverCharge!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Delivery Tips",style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                                        Text(ApiConstants.currency+widget.orderDetails.paymentDetails!.deliveryTips!.toString(),style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                                      ],
                                    ),
                                  ],
                                ),
                                if( widget.orderDetails.deliveryState != "on_finish")
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Mode",style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                                    Text(widget.orderDetails.paymentType!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                if( widget.orderDetails.deliveryState != "on_finish")
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Grand Total",style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                                    Text(ApiConstants.currency+widget.orderDetails.paymentDetails!.grandTotal.toString()!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                                  ],
                                ),

                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,),
              widget.orderDetails.deliveryState == "on_ready" ? InkWell(
                onTap: (){
                  //_startTracking();
                  TrackingUtils.startTracking(widget.orderDetails.saleCode!,widget.orderDetails.deliveryState);
                  _con.changeOrderStatus(widget.orderDetails.saleCode!, "on_picked", context);
                },
                child: Container(
                  width: 138,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.themeColor, // Gray fill color
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  ),
                  child: Center(
                    child:   Text("Picked",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                  ),
                ),
              ):Container(),
              widget.orderDetails.deliveryState == "on_going" ? InkWell(
                onTap: (){
                  ValidationUtils.openGoogleMap(double.parse(widget.orderDetails.vendor!.latitude!),double.parse(widget.orderDetails.vendor!.longitude!));
                },
                child: Container(
                  width: 138,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.themeColor, // Gray fill color
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  ),
                  child: Center(
                    child:   Text("Go to Store",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                  ),
                ),
              ):Container(),
              widget.orderDetails.deliveryState == "on_picked" ? InkWell(
                onTap: (){
                    TrackingUtils.startTracking(widget.orderDetails.saleCode!,widget.orderDetails.deliveryState);
                  _con.changeOrderStatus(widget.orderDetails.saleCode!, "on_reached", context);
                },
                child: Container(
                  width: 138,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.themeColor, // Gray fill color
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  ),
                  child: Center(
                    child:   Text("Reached",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                  ),
                ),
              ):Container(),

              widget.orderDetails.deliveryState == "on_reached" ? InkWell(
                onTap: (){
                  showConfirmationBottomSheet(context);
                },
                child: Container(
                  width: 138,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.themeColor, // Gray fill color
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  ),
                  child: Center(
                    child:   Text("Delivered",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                  ),
                ),
              ):Container(),

            ],
          ),
        ),
      ),
    );
  }

  void showConfirmationBottomSheet(BuildContext context) {
    var otpController = TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Please enter the otp',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20,),
                Container(
                  height: 52,
                  child: TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.themeLightColor, // Gray fill color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: AppColors.themeColor,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: AppColors.themeColor,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: AppColors.themeColor,
                            width: 1.0,
                          ),
                        ),
                        hintText: 'Enter 4 digit otp',
                        hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    if(otpController.text ==widget.orderDetails.otp){
                      TrackingUtils.startTracking(widget.orderDetails.saleCode!,widget.orderDetails.deliveryState);
                      _con.changeOrderStatus(widget.orderDetails.saleCode!, "on_finish", context);
                    }else{
                      ValidationUtils.showAppToast("Invalid OTP");
                    }
                  },
                  child: Container(
                    width: 138,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.themeColor, // Gray fill color
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    ),
                    child: Center(
                      child:   Text("Submit",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



}
