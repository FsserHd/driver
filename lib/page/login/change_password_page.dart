

import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:driver/utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/auth_controller.dart';

class ChangePasswordPage extends StatefulWidget {
  String? phone;
  ChangePasswordPage(this.phone, {super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends StateMVC<ChangePasswordPage> {

  late AuthController _con;
  var passwordController = TextEditingController();
  var retypePasswordController = TextEditingController();
  _ChangePasswordPageState() : super(AuthController()) {
    _con = controller as AuthController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
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
                  SizedBox(height:40,),
                  Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30,top: 30,bottom: 10),
                    child: Container(
                      height: 52,
                      child: TextFormField(
                        controller: passwordController,
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
                  SizedBox(height:0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30,top: 0,bottom: 10),
                    child: Container(
                      height: 52,
                      child: TextFormField(
                        controller: retypePasswordController,
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
                            hintText: 'Re Enter Password',
                            hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      if(passwordController.text == retypePasswordController.text) {
                        _con.changePassword(
                            context, passwordController.text, widget.phone!);
                      }else{
                        ValidationUtils.showAppToast("Mis match password");
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
                        child:   Text("Update",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
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
