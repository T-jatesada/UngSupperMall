import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungsuppermall/models/typeuser_model.dart';
import 'package:ungsuppermall/utility/my_style.dart';

class InformationShop extends StatefulWidget {
  @override
  _InformationShopState createState() => _InformationShopState();
}

class _InformationShopState extends State<InformationShop> {
  double screen;
  TypeUserModel typeUserModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserLogin();
  }

  Future<Null> findUserLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        await FirebaseFirestore.instance
            .collection('typeuser')
            .doc(event.uid)
            .snapshots()
            .listen((event) {
          print('event ==> ${event.data()}');
          setState(() {
            typeUserModel = TypeUserModel.fromMap(event.data());
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addInformation'),
        child: MyStyle().titleH3Whete('Edit'),
      ),
      body: Center(
        child: Column(
          children: [
            buildImage(),
            MyStyle()
                .titleH1(typeUserModel == null ? 'Name ?' : typeUserModel.name),
          ],
        ),
      ),
    );
  }

  Container buildImage() {
    return Container(
      width: screen * 0.6,
      height: screen * 0.6,
      child: MyStyle().showImage(),
    );
  }
}
