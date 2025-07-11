

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../model/category/shop_focus_model.dart';
import '../model/order/order_response.dart';
import '../model/service/service_response_model.dart';
import '../network/api_service.dart';
import '../utils/loader.dart';
import '../utils/preference_utils.dart';
import '../utils/validation_utils.dart';

class OrderController extends ControllerMVC{

  static final OrderController _instance = OrderController._internal();
  factory OrderController() => _instance;
  OrderController._internal();

  ApiService apiService = ApiService();
  var _orderModel = OrderResponse();
  OrderResponse get orderModel => _orderModel;
  var serviceResponseModel = ServiceResponseModel();
  var completedOrder = 0;
  var earning = 0.0;
  var serviceCompletedOrder = 0;
  var serviceEarning = 0.0;

  var shopFocusModel = ShopFocusModel();


  updateStatus(String newState) {
    setState(()  {
     listAllOrders("0", "0");
    });
  }

  listServiceReports(String status,String type,String startDate,String endDate){
    earning = 0.0;
    Loader.show();
    apiService.listServiceReports(status,type,startDate,endDate).then((value) {
      Loader.hide();
      if(value.data!=null) {
        setState(() {
          serviceResponseModel = value;
          serviceCompletedOrder = serviceResponseModel.data!.length;
          serviceResponseModel.data!.forEach((element) {
            serviceEarning = serviceEarning + double.parse(element.deliveryfees!);
          });
        });
      }else{
        serviceResponseModel.data!.clear();
      }
      notifyListeners();
    }).catchError((e){
      Loader.hide();
      print(e);
      //ValidationUtils.showAppToast("Something went wrong.");
    });
  }

  listAllReports(String status,String type,String startDate,String endDate){
    earning = 0.0;
    Loader.show();
    apiService.listReports(status,type,startDate,endDate).then((value) {
      Loader.hide();
      if(value.data!=null) {
        setState(() {
          _orderModel = value;
          completedOrder = orderModel.data!.length;
          orderModel.data!.forEach((element) {
            earning = earning + double.parse(element.driverCharge!);
          });
        });
      }else{
        if(_orderModel.data!=null) {
          _orderModel.data!.clear();
        }
        completedOrder = 0;
      }
      notifyListeners();
    }).catchError((e){
      Loader.hide();
      print(e);
      //ValidationUtils.showAppToast("Something went wrong");
    });
  }

  listAllOrders(String status, String shopFocusId){
    earning = 0.0;
    Loader.show();
    apiService.listOrders(status,shopFocusId).then((value) {
      Loader.hide();
        if(value.data!=null) {
          setState(() {
            _orderModel = value;
            completedOrder = orderModel.data!.length;
            orderModel.data!.forEach((element) {
              earning = earning + double.parse(element.driverCharge!);
            });
          });
        }else{
          // setState(() {
          //   _orderModel = value;
          // });
          ValidationUtils.showAppToast("No Orders found");
        }
      notifyListeners();
    }).catchError((e){
      Loader.hide();
      print(e);
     // ValidationUtils.showAppToast("Something went wrong.");
    });
  }

  changeOrderStatus(String saleCode,String status, BuildContext context) async {
    // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // String? userId = await PreferenceUtils.getUserId();
    // await _firestore.collection('driverTrack').doc(saleCode).set({
    //   'driverId': userId!,
    //   'latitude': await PreferenceUtils.getLatitude(),
    //   'longitude': await PreferenceUtils.getLongitude(),
    //   'order_status': status,
    // });
    Loader.show();
    apiService.orderStatus(saleCode,status).then((value) async {
      Loader.hide();
      updateStatus("newState");
      Navigator.pop(context);
      if(status == "on_finish"){
        Navigator.pop(context);
      }
    }).catchError((e){
      Loader.hide();
      print(e);
      //ValidationUtils.showAppToast("Something went wrong.");
    });
  }

  getShopFocus(BuildContext context) async {
    Loader.show();
    apiService.getShopFocus().then((value){
      Loader.hide();
      if(value.success!) {
          shopFocusModel = value;
          ShopFocusData focusData = new ShopFocusData();
          focusData.title = "All";
          focusData.shopFocusId = "0";
          shopFocusModel.data!.insert(0, focusData);

      }
      notifyListeners();
    }).catchError((e){
      Loader.hide();
      print(e);
     // ValidationUtils.showAppToast("Something went wrong.");
    });
  }


}