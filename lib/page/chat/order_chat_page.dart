


import 'package:driver/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/home_controller.dart';
import '../../utils/time_utils.dart';

class OrderChatPage extends StatefulWidget {
  String orderId;
  String type;
  String sender;
  OrderChatPage(this.orderId,this.type, this.sender, {super.key});

  @override
  _OrderChatPageState createState() => _OrderChatPageState();
}

class _OrderChatPageState extends StateMVC<OrderChatPage> {

  TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late HomeController _con;

  _OrderChatPageState() : super(HomeController()) {
    _con = controller as HomeController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.listOrderChat(widget.orderId,widget.type,widget.sender);
    _con.updateChatCount();
  }
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Chat",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body:  Column(
        children: <Widget>[
          Expanded(
            child:  _con.chatResponse.data!=null ? ListView.builder(
              controller: _scrollController,
                itemCount: _con.chatResponse.data!.length,shrinkWrap: true,itemBuilder: (context,index){
              var chatBean = _con.chatResponse.data![index];
              WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
              return    chatBean.type == "driver" ?  ListTile(
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(chatBean.message!,style: AppStyle.font14RegularBlack87.override(color: Colors.white)),
                        Text(TimeUtils.convertMonthDateYear(chatBean.createdAt!),style: AppStyle.font14RegularBlack87.override(color: Colors.white)),

                      ],
                    ),
                  ),
                ),
              ):ListTile(
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(chatBean.message!,style: AppStyle.font14RegularBlack87.override(color: Colors.white)),
                        Text(TimeUtils.convertMonthDateYear(chatBean.createdAt!),style: AppStyle.font14RegularBlack87.override(color: Colors.white)),

                      ],
                    ),
                  ),
                ),
              );
            }):Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Handle send message action
                      String message = _messageController.text;
                      if (message.isNotEmpty) {
                        // Add the message to your chat logic here
                        _messageController.clear();
                      }
                      _con.chatRequest.orderId = widget.orderId;
                      _con.chatRequest.message =message;
                      _con.chatRequest.type = widget.type;
                      _con.chatRequest.sender = "driver";
                      _con.addOrderChat(_con.chatRequest);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
