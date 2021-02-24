import 'package:flutter/material.dart';
import 'package:ungsuppermall/utility/my_style.dart';

class MyServiceBuyer extends StatefulWidget {
  @override
  _MyServiceBuyerState createState() => _MyServiceBuyerState();
}

class _MyServiceBuyerState extends State<MyServiceBuyer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
        title: Text('Buyer'),
      ),
      drawer: Drawer(child: MyStyle().buildSignOut(context),),
    );
  }
}
