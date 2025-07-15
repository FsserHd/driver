

import 'dart:io';

import 'package:driver/controller/auth_controller.dart';
import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:driver/navigation/page_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_style.dart';
import '../../../controller/home_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends StateMVC<ProfilePage> {

  late AuthController _con;

  _ProfilePageState() : super(AuthController()) {
    _con = controller as AuthController;
  }

  File? _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getProfile(context);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _con.uploadImage(_image!);
      });
    }
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
        title: Text("Profile",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      backgroundColor: AppColors.themeColor,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 100,),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 0,
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0.0),bottomRight: Radius.circular(0.0),topLeft:Radius.circular(20.0),topRight: Radius.circular(20.0) ),
                  ),
                  child: Column(
                    children: [
                       SizedBox(height: 100,),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Container(
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //       color: Color(0XFFF7F7F7),
                      //       border: Border.all(
                      //         color:Color(0XFFF7F7F7),
                      //         width: 0,
                      //       ),
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(12.0),
                      //       child: Row(
                      //         children: [
                      //           Icon(Icons.settings,color: AppColors.themeColor,),
                      //           SizedBox(width: 5,),
                      //           Text(
                      //             'Settings',
                      //             style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        onTap: (){
                          PageNavigation.gotoEarningsPage(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0XFFF7F7F7),
                              border: Border.all(
                                color:Color(0XFFF7F7F7),
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.money,color: AppColors.themeColor,),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Earnings',
                                    style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                            PageNavigation.gotoPolicyPage(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0XFFF7F7F7),
                              border: Border.all(
                                color:Color(0XFFF7F7F7),
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.policy,color: AppColors.themeColor,),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Policy',
                                    style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Share.share('App Link: https://thee4square.com/');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0XFFF7F7F7),
                              border: Border.all(
                                color:Color(0XFFF7F7F7),
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.share,color: AppColors.themeColor,),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Refer App',
                                    style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: (){
                      //     PageNavigation.gotoHelpPage(context);
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Container(
                      //       width: double.infinity,
                      //       decoration: BoxDecoration(
                      //         color: Color(0XFFF7F7F7),
                      //         border: Border.all(
                      //           color:Color(0XFFF7F7F7),
                      //           width: 0,
                      //         ),
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(12.0),
                      //         child: Row(
                      //           children: [
                      //             Icon(Icons.help,color: AppColors.themeColor,),
                      //             SizedBox(width: 5,),
                      //             Text(
                      //               'Help',
                      //               style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            _con.logout(context, false);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0XFFF7F7F7),
                              border: Border.all(
                                color:Color(0XFFF7F7F7),
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.logout,color: AppColors.themeColor,),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Logout',
                                    style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _con.driverModel.data!=null ? Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        _pickImage(ImageSource.gallery);
                      },
                      child: Stack(
                        children: [
                          _image!=null ? ClipOval(
                            child: Image.file(
                              _image!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ) :_con.driverModel.data!.image!=null ? ClipOval(
                            child: Image.network(
                              _con.driverModel.data!.image!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )  :Image.asset("assets/images/account.png", width: 120,
                            height: 120,),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Icon(Icons.edit_calendar_outlined,color: AppColors.themeColor,),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    _con.driverModel.data!=null ?
                    Column(
                      children: [
                        Text(_con.driverModel.data!.name!,style: AppStyle.font14MediumBlack87.override(color: CupertinoColors.inactiveGray,fontSize: 16),),
                        SizedBox(height: 5,),
                        Text(_con.driverModel.data!.phone!,style: AppStyle.font14MediumBlack87.override(color: CupertinoColors.inactiveGray,fontSize: 16),),


                      ],
                    ):Container(),
                  ],
                )),
          ):Container(),
        ],
      ),
    );
  }
}
