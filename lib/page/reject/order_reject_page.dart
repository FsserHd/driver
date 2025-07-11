import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:driver/utils/validation_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/home_controller.dart';

class OrderRejectPage extends StatefulWidget {

  String orderId;
  String vendorId;
  OrderRejectPage(this.orderId,this.vendorId, {super.key});

  @override
  _OrderRejectPageState createState() => _OrderRejectPageState();
}

class _OrderRejectPageState extends StateMVC<OrderRejectPage> {

  late HomeController _con;

  _OrderRejectPageState() : super(HomeController()) {
    _con = controller as HomeController;
  }

  List<String> rejectReasons = [
    "Heavy Rains",
    "Vehicle Issue",
    "Currently not accept orders"
  ];
  var otherTextController = TextEditingController();
  int? selectedIndex;
  String selectedValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Reject Reasons", style: TextStyle(color: Colors.white,
            fontFamily: AppStyle.robotoRegular,
            fontSize: 16),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: rejectReasons.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        selectedValue = rejectReasons[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                        border: Border.all(
                          color: selectedIndex == index ? Colors.blue : Colors.grey.shade300, // Highlight border color if selected
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              rejectReasons[index],
                              style: TextStyle(
                                fontSize: 14,
                                color: selectedIndex == index ? Colors.blue : Colors.black87, // Highlight text color if selected
                              ),
                            ),
                            if (selectedIndex == index)
                              Icon(
                                Icons.do_not_disturb_on_total_silence,
                                color: Colors.green,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Other Reasons",style: AppStyle.font14MediumBlack87.override(fontSize: 16),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 52,
                child: TextFormField(
                  onChanged: (e){
                    setState(() {
                      selectedIndex = null;
                      selectedValue = e;
                    });
                  },
                  controller: otherTextController,
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
                      hintText: 'Enter Reasons',
                      hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: (){
                  if(otherTextController.text.length >0  || selectedValue.length>0){
                  _con.orderRejectStatus(context,widget.orderId,"Rejected",selectedValue,widget.vendorId);
                  }else{
                    ValidationUtils.showAppToast("Select Reasons");
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
            ),
          ],
        ),
      ),
    );
  }
}
