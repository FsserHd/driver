import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyOverlaContent extends StatefulWidget {
  const MyOverlaContent({ Key? key }) : super(key: key);

  @override
  State<MyOverlaContent> createState() => _MyOverlaContentState();
}

class _MyOverlaContentState extends State<MyOverlaContent> {
  String _dataFromApp = "Hey send data";

  @override
  void initState() {
    super.initState();

    // lisent for any data from the main app
    // FlutterOverlayApps.overlayListener().listen((event) {
    //   setState(() {
    //     _dataFromApp = event.toString();
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: (){
          // close overlay
          //FlutterOverlayApps.closeOverlay();
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(child: Text(_dataFromApp, style: const TextStyle(color: Colors.red),)),
        ),
      ),
    );
  }
}