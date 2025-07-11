

import 'dart:io';

import 'package:driver/model/common/common_response_model.dart';
import 'package:driver/model/earnings/order_earnings_response.dart';
import 'package:driver/model/forgot/forgot_model.dart';
import 'package:driver/navigation/page_navigation.dart';
import 'package:driver/utils/preference_utils.dart';
import 'package:driver/utils/validation_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../model/driver/driver_model.dart';
import '../model/earnings/service_earnings_response.dart';
import '../model/login/login_request.dart';
import '../network/api_service.dart';
import '../utils/loader.dart';

class AuthController extends ControllerMVC{

  //Network Service
  ApiService apiService = ApiService();
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  var loginRequest = LoginRequest();
  var commResponseModel = CommonResponseModel();
  var driverModel = DriverModel();
  var forgotModel = ForgotModel();
  var isOtpShow = false;
  var serviceEarningsModel = ServiceEarnings();
  var orderEarningsModel = OrderEarnings();

  login(BuildContext context){
    Loader.show();
    if(ValidationUtils.emptyValidation(loginRequest.phone!) && ValidationUtils.emptyValidation(loginRequest.password!)){
       apiService.signIn(loginRequest).then((value){
         Loader.hide();
         if(value.success!){
            PreferenceUtils.saveUserId(value.data!.id!);
            PreferenceUtils.saveUserType(value.data!.deliverytype!);
            PageNavigation.gotoDashboardPage(context);
         }else{
           ValidationUtils.showAppToast("Invalid Credentials");
         }
       }).catchError((e){
         Loader.hide();
         print(e);
        // ValidationUtils.showAppToast("Something went wrong.");
       });
    }else{
      ValidationUtils.showAppToast("All Fields are required.");
    }
  }

  getProfile(BuildContext context) async {
    Loader.show();
    apiService.getProfile().then((value){
      Loader.hide();
      setState(() {
        driverModel = value;
      });
    }).catchError((e){
      Loader.hide();
      print(e);
    //  ValidationUtils.showAppToast("Something went wrong.");
    });
  }

  forgotPasswordOtp(BuildContext context) async {
    Loader.show();
    apiService.forgotPassword(loginRequest.phone!).then((value){
      Loader.hide();
      setState(() {
        isOtpShow = true;
        forgotModel = value;
      });
    }).catchError((e){
      Loader.hide();
      print(e);
    //  ValidationUtils.showAppToast("Something went wrong.");
    });
  }

  changePassword(BuildContext context,String password,String mobile) async {
    Loader.show();
    apiService.changePassword(password,mobile).then((value){
      Loader.hide();
      setState(() {
        if(value.success!){
          ValidationUtils.showAppToast("Password update successfully.");
          Navigator.pushNamedAndRemoveUntil(context,'/',(_) => false);
        }
      });
    }).catchError((e){
      Loader.hide();
      print(e);
     // ValidationUtils.showAppToast("Something went wrong.");
    });
  }

  uploadImage(File file){
    Loader.show();
    apiService.uploadImage(file).then((value){
      Loader.hide();
      if(value.success!){
        commResponseModel = value;
        notifyListeners();
      }else{
      //  ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  logout(BuildContext context,bool status){
    Loader.show();
    apiService.statusUpdate(status).then((value){
      Loader.hide();
      PageNavigation.goLogout(context);
    }).catchError((e){
      Loader.hide();
      print(e);
    //  ValidationUtils.showAppToast("Something went wrong.");
    });
  }

  serviceEarnings(BuildContext context) async {
    Loader.show();
    apiService.getServiceEarnings().then((value){
      Loader.hide();
      setState(() {
        serviceEarningsModel = value;
      });
    }).catchError((e){
      Loader.hide();
      print(e);
      //  ValidationUtils.showAppToast("Something went wrong.");
    });
  }


  orderEarnings(BuildContext context) async {
    Loader.show();
    apiService.getOrderEarnings().then((value){
      Loader.hide();
      setState(() {
        orderEarningsModel = value;
      });
    }).catchError((e){
      Loader.hide();
      print(e);
      //  ValidationUtils.showAppToast("Something went wrong.");
    });
  }

}