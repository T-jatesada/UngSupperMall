import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungsuppermall/models/typeuser_model.dart';
import 'package:ungsuppermall/states/show_product_user.dart';
import 'package:ungsuppermall/utility/my_style.dart';

class ShowShopUser extends StatefulWidget {
  @override
  _ShowShopUserState createState() => _ShowShopUserState();
}

class _ShowShopUserState extends State<ShowShopUser> {
  bool load = true;
  List<TypeUserModel> typeUserModels = [];
  List<Widget> widgets = [];
  List<String> uidShops = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('typeuser')
          .snapshots()
          .listen((event) {
        int index = 0;
        for (var item in event.docs) {
          String docName = item.id;
          TypeUserModel model = TypeUserModel.fromMap(item.data());
          if (model.typeuser == 'shopper') {
            setState(() {
              typeUserModels.add(model);
              uidShops.add(docName);
              widgets.add(createWidget(model, index));
            });
            index++;
          }
        }

        setState(() {
          load = false;
        });
      });
    });
  }

  Widget createWidget(TypeUserModel model, int index) {
    return GestureDetector(
      onTap: () {
        print('You Tap index = $index');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ShowProductUser(typeUserModel: typeUserModels[index], uidShop: uidShops[index],),
            ));
      },
      child: Card(
        color: MyStyle().lightColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                child: model.urlshopper == null
                    ? Image.asset('images/image.png')
                    : Image.network(model.urlshopper),
              ),
              MyStyle().titleH3Whete(model.name),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? MyStyle().showProgress()
          : GridView.extent(
              maxCrossAxisExtent: 160,
              children: widgets,
            ),
    );
  }
}
