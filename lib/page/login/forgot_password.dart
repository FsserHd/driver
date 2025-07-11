

import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:driver/navigation/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/auth_controller.dart';
import '../../utils/validation_utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends StateMVC<ForgotPasswordPage> {

  late AuthController _con;
  final _otpControllers = List<TextEditingController>.generate(5, (index) => TextEditingController());
  final _otpFocusNodes = List<FocusNode>.generate(5, (index) => FocusNode());

  String typeOtp = "";

  _ForgotPasswordPageState() : super(AuthController()) {
    _con = controller as AuthController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _con.loginKey,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png",height: 200,),
                 // Text("Let’s Get Started To \nLogin With Us",style: AppStyle.font22BoldWhite.override(color: Colors.black),textAlign: TextAlign.center,),
                  SizedBox(height:40,),
                  !_con.isOtpShow ? Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30),
                    child: Column(
                      children: [
                        Container(
                          height: 52,
                          child: TextFormField(
                            maxLength: 10,
                            onSaved: (e) {
                              _con.loginRequest.phone = e;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.themeLightColor, // Replace with your color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: AppColors.themeColor, // Replace with your color
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: AppColors.themeColor, // Replace with your color
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: AppColors.themeColor, // Replace with your color
                                  width: 1.0,
                                ),
                              ),
                              hintText: 'Enter Mobile Number',
                              hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black),
                              counterText: "", // Hide the counter text
                              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Adjust padding to fit the height
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ):Container(),
                  SizedBox(height:0,),
                  _con.isOtpShow ? Column(
                    children: [
                      Text("Enter 5 Digit Otp",style: AppStyle.font14MediumBlack87.override(fontSize: 16),),
                      SizedBox(height: 10,),
                      OtpTextField(
                        numberOfFields: 5,
                        fieldWidth: 50,
                        fieldHeight: 50,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.themeLightColor,
                          counterText: '', // Hide the counter text
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: AppColors.themeColor, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: AppColors.themeColor, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: AppColors.themeColor, width: 2.0),
                          ),
                        ),
                        hasCustomInputDecoration: true,
                        fillColor: AppColors.themeLightColor,
                        borderColor: AppColors.themeColor,
                        //set to true to show as box or false to show as dash
                        showFieldAsBox: true,
                        //runs when a code is typed in
                        onCodeChanged: (String code) {
                          //handle validation or checks here
                        },
                        //runs when every textfield is filled
                        onSubmit: (String verificationCode){
                          typeOtp = verificationCode;
                          if(verificationCode.length==5){
                            if(_con.forgotModel.otp.toString() == verificationCode){
                             PageNavigation.gotoChangePassword(context,_con.loginRequest.phone);
                            }else{
                              ValidationUtils.showAppToast("Otp Invalid");
                            }
                          }else{
                            ValidationUtils.showAppToast("Otp Required");
                          }
                          // showDialog(
                          //     context: context,
                          //     builder: (context){
                          //       return AlertDialog(
                          //         title: Text("Verification Code"),
                          //         content: Text('Code entered is $verificationCode'),
                          //       );
                          //     }
                          // );
                        }, // end onSubmit
                      ),
                      SizedBox(height: 20,),
                    ],
                  ):Container(),
                  InkWell(
                    onTap: (){
                      _con.loginKey.currentState!.save();
                      if(_con.isOtpShow) {
                        if(_con.forgotModel.otp.toString() == typeOtp){
                          PageNavigation.gotoChangePassword(context,_con.loginRequest.phone);
                        }else{
                          ValidationUtils.showAppToast("Otp Invalid");
                        }
                      }else{
                        _con.forgotPasswordOtp(context);
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
                  SizedBox(height: 40,),
                  InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text("Go Back",style: AppStyle.font22BoldWhite.override(color: Colors.black,fontSize: 14),textAlign: TextAlign.center,)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
