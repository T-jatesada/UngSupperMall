import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ungsuppermall/states/authen.dart';
import 'package:ungsuppermall/states/create_account.dart';
import 'package:ungsuppermall/states/my_service_buyer.dart';
import 'package:ungsuppermall/states/my_service_shopper.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/myServiceBuyer': (BuildContext context) => MyServiceBuyer(),
  '/myServiceShopper': (BuildContext context) => MyServiceShopper(),
};

String iniRount = '/authen';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      routes: map,
      title: 'Ung Supper Mall',
      initialRoute: iniRount,
    );
  }
}
