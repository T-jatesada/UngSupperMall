import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungsuppermall/bodies/information_shopper.dart';
import 'package:ungsuppermall/bodies/show_order_shopper.dart';
import 'package:ungsuppermall/bodies/show_product.dart';
import 'package:ungsuppermall/models/typeuser_model.dart';
import 'package:ungsuppermall/utility/my_style.dart';

class MyServiceShopper extends StatefulWidget {
  @override
  _MyServiceShopperState createState() => _MyServiceShopperState();
}

class _MyServiceShopperState extends State<MyServiceShopper> {
  TypeUserModel typeUserModel;
  String nameLogin;
  List<Widget> widgets = [
    ShowOrderShopper(),
    ShowProduct(),
    InformationShop(),
  ];

  List<String> titles = [
    'Show Order',
    'Show Product',
    'Information',
  ];

  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserLogin();
  }

  Future<Null> findUserLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;

        await FirebaseFirestore.instance
            .collection('typeuser')
            .doc(uid)
            .snapshots()
            .listen((event) {
          typeUserModel = TypeUserModel.fromMap(event.data());
          print(
              'name ==> ${typeUserModel.name}, urlshopper ==>> ${typeUserModel.urlshopper}');
          if (typeUserModel.urlshopper == null) {
            setState(() {
              index = 2;
            });
          }
        });

        setState(() {
          nameLogin = event.displayName;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
        title: Text(titles[index]),
      ),
      drawer: buildDrawer(context),
      body: widgets[index],
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Column(
            children: [
              buildUserAccountsDrawerHeader(),
              buildMenuShowOrder(context),
              buildMenuShowProduct(context),
              buildMenuInformation(context),
            ],
          ),
          MyStyle().buildSignOut(context),
        ],
      ),
    );
  }

  ListTile buildMenuShowOrder(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          index = 0;
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.home,
        color: MyStyle().primaryColor,
      ),
      title: MyStyle().titleH2Dark(titles[0]),
      subtitle: MyStyle().titleH3Dark('Display Order of Customer'),
    );
  }

  ListTile buildMenuShowProduct(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          index = 1;
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.list,
        color: MyStyle().primaryColor,
      ),
      title: MyStyle().titleH2Dark(titles[1]),
      subtitle: MyStyle().titleH3Dark('Display Product of Shopper'),
    );
  }

  ListTile buildMenuInformation(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          index = 2;
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.info,
        color: MyStyle().primaryColor,
      ),
      title: MyStyle().titleH2Dark(titles[2]),
      subtitle: MyStyle().titleH3Dark('Display Informaion'),
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
        currentAccountPicture: MyStyle().showLogo(),
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/top2.png'))),
        accountName: nameLogin == null ? null : MyStyle().titleH1(nameLogin),
        accountEmail: MyStyle().titleH2Dark('Shoper'));
  }
}
