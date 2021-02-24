import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ungsuppermall/models/typeuser_model.dart';
import 'package:ungsuppermall/states/add_information.dart';
import 'package:ungsuppermall/states/authen.dart';
import 'package:ungsuppermall/states/create_account.dart';
import 'package:ungsuppermall/states/my_service_buyer.dart';
import 'package:ungsuppermall/states/my_service_shopper.dart';
import 'package:ungsuppermall/utility/api.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/myServiceBuyer': (BuildContext context) => MyServiceBuyer(),
  '/myServiceShopper': (BuildContext context) => MyServiceShopper(),
  '/addInformation':(BuildContext context)=>AddInformation(),
};

String iniRount = '/authen';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //  Wait Thread Finish Job
  await Firebase.initializeApp().then((value) async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        String uid = event.uid;
        await FirebaseFirestore.instance
            .collection('typeuser')
            .doc(uid)
            .snapshots()
            .listen((event) {
          TypeUserModel model = TypeUserModel.fromMap(event.data());
          String typeuser = model.typeuser;
          print('uid ==> $uid, typeuser = $typeuser');
          iniRount = Api().findKeyByTypeUser(typeuser);
          runApp(MyApp());
        });
      } else {
        runApp(MyApp());
      }
    });
  });
}

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
