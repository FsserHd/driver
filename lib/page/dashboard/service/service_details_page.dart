

import 'package:driver/controller/home_controller.dart';
import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../constants/api_constants.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_style.dart';
import '../../../model/service/service_response_model.dart';
import '../../../utils/tracking_utils.dart';
import '../../../utils/validation_utils.dart';

class ServiceDetailsPage extends StatefulWidget {
  Service serviceBean;

  ServiceDetailsPage(this.serviceBean, {super.key});

  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends StateMVC<ServiceDetailsPage> {

  late HomeController _con;

  _ServiceDetailsPageState() : super(HomeController()) {
    _con = controller as HomeController;
  }


  late GoogleMapController mapController;
  late LatLng _initialPosition = LatLng(double.parse(widget.serviceBean.fromLatitude!), double.parse(widget.serviceBean.fromLongitude!));
  late LatLng _desitinationPostion = LatLng(double.parse(widget.serviceBean.toLatitude!), double.parse(widget.serviceBean.toLongitude!));
  final _placesApiKey = 'AIzaSyAllf0gGdRTTog1ChI62srhdNZ-hVsEYe0'; // Replace with your API key
  final _geocoding = GoogleMapsGeocoding(apiKey: 'AIzaSyAllf0gGdRTTog1ChI62srhdNZ-hVsEYe0'); // Replace with your API key
  BitmapDescriptor? _customCustomerMarkerIcon;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _loadCustomerMarkerIcon() async {
    final customMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(100, 100)), // Adjust size as needed
      'assets/images/home.png',
    );
    setState(() {
      _customCustomerMarkerIcon = customMarker;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _loadCustomerMarkerIcon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dashboardBgColor,
      appBar:  AppBar(
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Details",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            widget.serviceBean.deliveryStatus != "Delivered" ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Service Details",style: TextStyle(color: AppColors.themeColor,fontFamily: AppStyle.robotoBold,fontSize: 16),),
            ):Container(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "#Service ID: ${widget.serviceBean.serviceCode!}",
                style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.black),
              ),
            ),
            // Container(
            //   width: double.infinity,
            //     color: AppColors.themeColor,
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("Need to purchase a essential things and make it fast on timing...",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 12),),
            //     )),
            // SizedBox(height: 10,),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       color: Colors.white, // Background color
            //       borderRadius: BorderRadius.circular(15.0), // Rounded corners
            //       border: Border.all(
            //         color: Colors.grey.shade300, // Light gray border color
            //         width: 2.0, // Border width
            //       ),
            //     ),
            //     child: Column(
            //       children: [
            //         Container(
            //           decoration: BoxDecoration(
            //             color: AppColors.themeColor, // Background color
            //             borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)), // Rounded corners
            //             border: Border.all(
            //               color: AppColors.themeColor, // Light gray border color
            //               width: 2.0, // Border width
            //             ),
            //           ),
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.center, // To align the texts to the start
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Text(
            //                   "Service is ${widget.serviceBean.deliveryStatus!.toLowerCase()}",
            //                   maxLines: 1,overflow: TextOverflow.ellipsis,
            //                   style: AppStyle.font18BoldWhite.override(fontSize: 16,color: Colors.white),
            //                 ),
            //                 SizedBox(height: 2),
            //               ],
            //             ),
            //           ),
            //           width: double.infinity,
            //         ),
            //         Container(
            //           height: 300,
            //           child: GoogleMap(
            //               onMapCreated: _onMapCreated,
            //               zoomGesturesEnabled: true,
            //               initialCameraPosition: CameraPosition(
            //                 target: _initialPosition,
            //                 zoom: 14.0,
            //               ),
            //
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.serviceBean.deliveryStatus != "Delivered"  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded,color: AppColors.themeColor,),
                          SizedBox(width: 10,),
                          Text("From",style: AppStyle.font18BoldWhite.override(color: AppColors.themeColor),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.serviceBean.fromname!,overflow:TextOverflow.ellipsis,maxLines: 2,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                              SizedBox(height: 5,),
                              Container(width: 220,
                                  child: Text(widget.serviceBean.fromlocation!,overflow:TextOverflow.ellipsis,maxLines: 2,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),)),
                            ],
                          ),
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
                                      FlutterPhoneDirectCaller.callNumber(widget.serviceBean.fphoneno!);
                                    },
                                  ),

                                ],
                              ),
                              SizedBox(width: 5,),
                              InkWell(
                                  onTap: (){
                                    ValidationUtils.openGoogleMap(double.parse(widget.serviceBean.fromLatitude!),double.parse(widget.serviceBean.fromLongitude!));
                                  },
                                  child: Image.asset("assets/images/map.png")),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded,color: AppColors.themeColor,),
                          SizedBox(width: 10,),
                          Text("Shipping to",style: AppStyle.font18BoldWhite.override(color:AppColors.themeColor),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.serviceBean.toname!,overflow:TextOverflow.ellipsis,maxLines: 2,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                              SizedBox(height: 5,),
                              Container(width: 220,
                                  child: Text(widget.serviceBean.tolocation!,overflow:TextOverflow.ellipsis,maxLines: 2,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),)),
                            ],
                          ),
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
                                      FlutterPhoneDirectCaller.callNumber(widget.serviceBean.tophoneno!);
                                    },
                                  ),

                                ],
                              ),
                              SizedBox(width: 5,),
                              InkWell(
                                  onTap: (){
                                    ValidationUtils.openGoogleMap(double.parse(widget.serviceBean.toLatitude!),double.parse(widget.serviceBean.toLongitude!));
                                  },
                                  child: Image.asset("assets/images/map.png")),
                            ],
                          )
                        ],
                      ),

                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Icon(Icons.category,color: AppColors.themeColor,),
                          SizedBox(width: 10,),
                          Text("Category",style: AppStyle.font18BoldWhite.override(color: AppColors.themeColor),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Text(widget.serviceBean.types!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Icon(Icons.description,color:AppColors.themeColor,),
                          SizedBox(width: 10,),
                          Text("Landmark / Comments",style: AppStyle.font18BoldWhite.override(color: AppColors.themeColor),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Text(widget.serviceBean.description!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Icon(Icons.description,color: AppColors.themeColor,),
                          SizedBox(width: 10,),
                          Text("Payment Mode",style: AppStyle.font18BoldWhite.override(color:AppColors.themeColor),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Text(widget.serviceBean.paymentmode!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                      SizedBox(height: 20,),
                    ],
                  ):Container(),
                  Text("Payment Details",style:AppStyle.font18BoldWhite.override(fontSize: 22,color: AppColors.themeColor),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Distance",style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                      Text(widget.serviceBean.distance1!+" Km",style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Service Charge",style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                      Text(ApiConstants.currency+widget.serviceBean.deliveryfees!,style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Divider(color: AppColors.lightGray,),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grand Total",style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 16),),
                      Text(ApiConstants.currency+widget.serviceBean.deliveryfees!,style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 16),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  widget.serviceBean.deliveryStatus == "Placed" && widget.serviceBean.isAccepted == "1" ? InkWell(
                    onTap: (){
                      _con.changeServiceStatus(widget.serviceBean.id!, "Picked", context);
                    },
                    child: Container(
                      width: double.infinity,
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

                  widget.serviceBean.deliveryStatus == "Picked" && widget.serviceBean.isAccepted == "1" ? InkWell(
                    onTap: (){
                      _con.changeServiceStatus(widget.serviceBean.id!, "InTransit", context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.themeColor, // Gray fill color
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                      ),
                      child: Center(
                        child:   Text("InTransit",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                      ),
                    ),
                  ):Container(),
                  widget.serviceBean.deliveryStatus == "InTransit" && widget.serviceBean.isAccepted == "1" ? InkWell(
                    onTap: (){
                      //_con.changeOrderStatus(widget.orderDetails.saleCode!, "on_finish", context);
                      showConfirmationBottomSheet(context);

                    },
                    child: Container(
                      width: double.infinity,
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
            )
          ],
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
                    if(otpController.text ==widget.serviceBean.otp){
                      _con.changeServiceStatus(widget.serviceBean.id!, "Delivered", context);
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