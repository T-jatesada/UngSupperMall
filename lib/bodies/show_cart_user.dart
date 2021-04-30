import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungsuppermall/models/order_model.dart';
import 'package:ungsuppermall/models/sqlite_model.dart';
import 'package:ungsuppermall/models/typeuser_model.dart';
import 'package:ungsuppermall/utility/dialog.dart';
import 'package:ungsuppermall/utility/my_style.dart';
import 'package:ungsuppermall/utility/sqlite_helper.dart';

class ShowCartUser extends StatefulWidget {
  @override
  _ShowCartUserState createState() => _ShowCartUserState();
}

class _ShowCartUserState extends State<ShowCartUser> {
  List<SQLiteModel> sqliteModels = [];
  bool load = true, haveData;
  int total = 0;
  List<String> nameProducts = [];
  List<String> prices = [];
  List<String> amounts = [];
  List<String> sums = [];
  String uidShoper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    if (sqliteModels.length != 0) {
      sqliteModels.clear();
      total = 0;
    }

    await SQLiteHelper().readAllData().then((value) {
      print('### value ===>>> $value');
      setState(() {
        load = false;
      });
      for (var item in value) {
        int sumInt = int.parse(item.sum);

        uidShoper = item.idShop;

        nameProducts.add(item.nameProduct);
        prices.add(item.price);
        amounts.add(item.amount);
        sums.add(item.sum);

        setState(() {
          total = total + sumInt;
          sqliteModels = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: load
          ? MyStyle().showProgress()
          : sqliteModels.length == 0
              ? Center(child: MyStyle().titleH1('Empty Cart'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyStyle().titleH1(sqliteModels[0].nameShop),
                      buildHead(),
                      buildListView(),
                      Divider(
                        thickness: 1,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyStyle().titleH2Dark('Total :'),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: MyStyle().titleH2Dark(total.toString()),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => processOrder(),
      child: Text('Order'),
    );
  }

  Future<Null> processOrder() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uidBuyer = event.uid;

        await FirebaseFirestore.instance
            .collection('typeuser')
            .doc(uidBuyer)
            .snapshots()
            .listen((event) async {
          TypeUserModel typeUserModel = TypeUserModel.fromMap(event.data());
          String nameBuyer = typeUserModel.name;

          OrderModel orderModel = OrderModel(
            uidBuyer: uidBuyer,
            nameBuyer: nameBuyer,
            nameProducts: nameProducts,
            prices: prices,
            amounts: amounts,
            sums: sums,
            total: total.toString(),
          );

          await FirebaseFirestore.instance
              .collection('typeuser')
              .doc(uidShoper)
              .collection('order')
              .doc()
              .set(orderModel.toMap())
              .then((value) => normalDialog(
                  context, 'Order Success', 'Thank You Order Success '));
        });
      });
    });
  }

  Container buildHead() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[400]),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: MyStyle().titleH3Dark('Product'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().titleH3Dark('Price'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().titleH3Dark('Amount'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().titleH3Dark('Sum'),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(sqliteModels[index].nameProduct),
          ),
          Expanded(
            flex: 1,
            child: Text(sqliteModels[index].price),
          ),
          Expanded(
            flex: 1,
            child: Text(sqliteModels[index].amount),
          ),
          Expanded(
            flex: 1,
            child: Text(sqliteModels[index].sum),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  print('#### delete id = ${sqliteModels[index].id}');
                  await SQLiteHelper()
                      .deleteSQLiteById(sqliteModels[index].id)
                      .then((value) => readSQLite());
                }),
          ),
        ],
      ),
    );
  }
}
