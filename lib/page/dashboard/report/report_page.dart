

import 'package:driver/constants/app_style.dart';
import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../constants/api_constants.dart';
import '../../../controller/home_controller.dart';
import '../../../controller/order_controller.dart';
import '../../../navigation/page_navigation.dart';
import '../../../utils/time_utils.dart';
import '../service/service_details_page.dart';

class ReportPage extends StatefulWidget {

  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends StateMVC<ReportPage> {

  late OrderController _con;

  _ReportPageState() : super(OrderController()) {
    _con = controller as OrderController;
  }

  String _selectedItem = 'All';
  String? _startDate;
  String? _endDate;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _con.listAllReports("on_finish","all","","");
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDateDialog(
          onDatesSelected: (startDate, endDate) {
            setState(() {
              _startDate = startDate;
              _endDate = endDate;
              if(_selectedOption == "orders") {
                _con.listAllReports(
                    "on_finish", "custom", _startDate!, _endDate!);
              }else{
                _con.listServiceReports(
                    "on_finish", "custom", _startDate!, _endDate!);
              }
            });
          },
        );
      },
    );
  }

  String _selectedOption = 'orders';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white, // Light gray background color
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  border: Border.all(color: Colors.grey.shade300), // Border color
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedItem,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedItem = newValue!;
                        if(newValue == "All") {
                          if(_selectedOption == "orders") {
                            _con.listAllReports("on_finish", "all", "", "");
                          }else{
                            _con.listServiceReports("on_finish", "all", "", "");
                          }
                        }else if(newValue == "Week"){
                           if(_selectedOption == "orders") {
                             _con.listAllReports("on_finish", "week", "", "");
                           }else{
                             _con.listServiceReports("on_finish", "week", "", "");
                           }
                        }else if(newValue == "Month"){
                            if(_selectedOption == "orders") {
                              _con.listAllReports("on_finish", "month", "", "");
                            }else{
                              _con.listServiceReports("on_finish", "month", "", "");
                            }
                        }else if(newValue == "Year"){
                              if(_selectedOption == "orders") {
                                _con.listAllReports("on_finish", "year", "", "");
                              }else{
                                _con.listServiceReports("on_finish", "year", "", "");
                              }
                        }else if(newValue == "Custom"){
                          _showCustomDialog(context);
                        }else if(newValue == "Today"){
                            if(_selectedOption == "orders") {
                              _con.listAllReports("on_finish", "today", "", "");
                            }else{
                              _con.listServiceReports("on_finish", "today", "", "");
                            }
                        }
                      });
                    },
                    items: <String>[
                      'All',
                      'Today',
                      'Week',
                      'Month',
                      "Year",
                      "Custom"
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text('Orders'),
                      value: 'orders',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedItem = "All";
                          _selectedOption = value.toString();
                          _con.listAllReports("on_finish", "all", "", "");
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text('Service'),
                      value: 'service',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedItem = "All";
                          _selectedOption = value.toString();
                          _con.listServiceReports("on_finish", "all", "", "");
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _selectedOption == "orders" ? Column(
                    children: [
                      Text("Completed Orders",style: AppStyle.font18BoldWhite.override(fontSize: 18),),
                      SizedBox(height: 10,),
                      Text(_con.completedOrder.toString(),style: AppStyle.font14MediumBlack87.override(fontSize: 20),),
                    ],
                  ):
                  Column(
                    children: [
                      Text("Completed Services",style: AppStyle.font18BoldWhite.override(fontSize: 18),),
                      SizedBox(height: 10,),
                      Text(_con.serviceCompletedOrder.toString(),style: AppStyle.font14MediumBlack87.override(fontSize: 20),),
                    ],
                  )
                ],
              ),
              SizedBox(height: 10,),
              Divider(color: Colors.grey,),
              _selectedOption == "orders" ? Text("Orders",style: AppStyle.font18BoldWhite.override(fontSize: 18),):Text("Services",style: AppStyle.font18BoldWhite.override(fontSize: 18),),
              SizedBox(height: 10,),
              _selectedOption == "orders" ? _con.orderModel.data!=null ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _con.orderModel.data!.length,
                  itemBuilder: (context,index){
                    var orderBean = _con.orderModel.data![index];
                    var fromAddress = orderBean.vendor!.displayName!+", "+orderBean.vendor!.address!;
                    var toAddress = orderBean.address!.addressSelect!;
                    return InkWell(
                      onTap: (){

                      },
                      child: InkWell(
                        onTap: (){
                          PageNavigation.gotoOrderDetailsPage(context,orderBean);
                        },
                        child: Stack(
                          children: [
                            Padding(
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
                                          Text(
                                            TimeUtils.getTimeStampToDate(int.parse(orderBean.paymentTimestamp!)),
                                            style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.grey.shade500),
                                          ),
                                          Text(
                                            ApiConstants.currency+orderBean.paymentDetails!.grandTotal.toString(),
                                            style: AppStyle.font18BoldWhite.override(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      // Divider(
                                      //   color: Colors.grey.shade500,
                                      // ),
                                      // Text(
                                      //   "From",
                                      //   style: AppStyle.font14MediumBlack87.override(fontSize: 10,color: Colors.grey.shade500),
                                      // ),
                                      // SizedBox(height: 2,),
                                      // Text(
                                      //   fromAddress,
                                      //   maxLines: 1,
                                      //   overflow: TextOverflow.ellipsis,
                                      //   style: AppStyle.font18BoldWhite.override(fontSize: 12),
                                      // ),
                                      // SizedBox(height: 5,),
                                      // Text(
                                      //   "To",
                                      //   style: AppStyle.font14MediumBlack87.override(fontSize: 10,color: Colors.grey.shade500),
                                      // ),
                                      // SizedBox(height: 2,),
                                      // Text(
                                      //   toAddress,maxLines: 1,
                                      //   overflow: TextOverflow.ellipsis,
                                      //   style: AppStyle.font18BoldWhite.override(fontSize: 12),
                                      // ),
                                      //
                                      // Divider(
                                      //   color: Colors.grey.shade500,
                                      // ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Total Item: "+orderBean.productDetails!.length.toString(),
                                                style: AppStyle.font18BoldWhite.override(fontSize: 12),
                                              ),
                                              SizedBox(height: 2,),
                                              Text(
                                                "Mode: "+orderBean.paymentType!,
                                                style: AppStyle.font18BoldWhite.override(fontSize: 12,color: Colors.deepOrangeAccent),
                                              ),
                                            ],
                                          ),

                                          Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.green, // Background color
                                                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                              ),
                                              child: Text(
                                                "Finish",
                                                style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.white),
                                              )
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }):Container(
                child: Text("No Orders",style: AppStyle.font14MediumBlack87,),
              ): _con.serviceResponseModel.data!=null ?  ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _con.serviceResponseModel.data!.length,
                  itemBuilder: (context,index){
                    var serviceBean = _con.serviceResponseModel.data![index];
                    return InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailsPage(serviceBean),
                          ),
                        ).then((value){
                          //_con.listService(context);
                        });
                      },
                      child: Stack(
                        children: [
                          Padding(
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
                                    Text(
                                      "#Service ID: ${serviceBean.serviceCode!}",
                                      style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.black),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          TimeUtils.convertUTC(serviceBean.fromtime!),
                                          style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.grey.shade500),
                                        ),
                                        Text(
                                          ApiConstants.currency+serviceBean.deliveryfees!,
                                          style: AppStyle.font18BoldWhite.override(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    // Divider(
                                    //   color: Colors.grey.shade500,
                                    // ),
                                    // Text(
                                    //   "From",
                                    //   style: AppStyle.font14MediumBlack87.override(fontSize: 10,color: Colors.grey.shade500),
                                    // ),
                                    // SizedBox(height: 2,),
                                    // Text(
                                    //   serviceBean.fromlocation!,maxLines: 1,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   style: AppStyle.font18BoldWhite.override(fontSize: 12),
                                    // ),
                                    // SizedBox(height: 5,),
                                    // Text(
                                    //   "To",
                                    //   style: AppStyle.font14MediumBlack87.override(fontSize: 10,color: Colors.grey.shade500),
                                    // ),
                                    // SizedBox(height: 2,),
                                    // Text(
                                    //   serviceBean.tolocation!,maxLines: 1,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   style: AppStyle.font18BoldWhite.override(fontSize: 12),
                                    // ),
                                    //
                                    // Divider(
                                    //   color: Colors.grey.shade500,
                                    // ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "",
                                          style: AppStyle.font18BoldWhite.override(fontSize: 12),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.green, // Background color
                                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                          ),
                                          child: Text(
                                            serviceBean.deliveryStatus!,
                                            style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }):Container(
                child: Text("No Orders",style: AppStyle.font14MediumBlack87,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDateDialog extends StatefulWidget {

  final Function(String?, String?) onDatesSelected;

  CustomDateDialog({required this.onDatesSelected});

  @override
  State<CustomDateDialog> createState() => _CustomDateDialogState();
}

class _CustomDateDialogState extends State<CustomDateDialog> {

  String? _startDate;
  String? _endDate;


  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(()  {
        if (isStartDate) {
          _startDate = picked.toString().split(' ')[0];
        } else {
          _endDate =  picked.toString().split(' ')[0];

        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select',style: AppStyle.font14MediumBlack87.override(fontSize: 16),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text(
                    _startDate == null
                        ? 'Select Start Date'
                        : _startDate.toString(),
                  style: AppStyle.font14MediumBlack87,),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text(
                    _endDate == null
                        ? 'Select End Date'
                        : _endDate.toString(),
                    style: AppStyle.font14MediumBlack87,),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel',style: AppStyle.font14RegularBlack87),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Submit',style: AppStyle.font14RegularBlack87,),
          onPressed: () {
            widget.onDatesSelected(_startDate,_endDate);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

