
import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:driver/navigation/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends StateMVC<LoginPage> {

  late AuthController _con;

  _LoginPageState() : super(AuthController()) {
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
                  Text("Let’s Get Started To \nLogin With Us",style: AppStyle.font22BoldWhite.override(color: Colors.black),textAlign: TextAlign.center,),
                  SizedBox(height:40,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30,right: 10),
                        child: Container(
                          width: 60,
                          height: 52,
                          child: AbsorbPointer(
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
                                hintText: '+91',
                                hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black),
                                counterText: "", // Hide the counter text
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Adjust padding to fit the height
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0,right: 30),
                          child: Container(
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30,top: 30,bottom: 30),
                    child: Container(
                      height: 52,
                      child: TextFormField(
                        onSaved: (e){
                          _con.loginRequest.password = e;
                        },
                        obscureText: true,
                        keyboardType: TextInputType.text,
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
                            hintText: 'Enter Password',
                            hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      _con.loginKey.currentState!.save();
                      _con.login(context);
                    },
                    child: Container(
                      width: 138,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.themeColor, // Gray fill color
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                      ),
                      child: Center(
                        child:   Text("Login",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  InkWell(
                      onTap: (){
                        PageNavigation.gotoForgotPage(context);
                      },
                      child: Text("Forgot Password",style: AppStyle.font22BoldWhite.override(color: Colors.black,fontSize: 14),textAlign: TextAlign.center,)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
