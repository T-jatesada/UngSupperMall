import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungsuppermall/models/typeuser_model.dart';
import 'package:ungsuppermall/utility/api.dart';
import 'package:ungsuppermall/utility/dialog.dart';
import 'package:ungsuppermall/utility/my_style.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  double screen;
  String typeUser, name, user, password;

  Container buildDisplayName() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.6,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.fingerprint,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(color: MyStyle().darkColor),
          labelText: 'DisplayName :',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.6,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.perm_identity,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(color: MyStyle().darkColor),
          labelText: 'User :',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.6,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_open_outlined,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(color: MyStyle().darkColor),
          labelText: 'Password :',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
        title: Text('Create Account'),
      ),
      body: Stack(
        children: [
          MyStyle().buildBackground(context),
          buildContent(),
        ],
      ),
    );
  }

  Center buildContent() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDisplayName(),
            Container(
              margin: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                border: Border.all(color: MyStyle().darkColor),
              ),
              width: screen * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        MyStyle().titleH2Dark('Type User:'),
                      ],
                    ),
                    RadioListTile(
                      value: 'buyer',
                      groupValue: typeUser,
                      onChanged: (value) {
                        setState(() {
                          typeUser = value;
                        });
                      },
                      title: MyStyle().titleH3Dark('User'),
                    ),
                    Container(
                      width: screen * 0.6,
                      child: RadioListTile(
                        value: 'shopper',
                        groupValue: typeUser,
                        onChanged: (value) {
                          setState(() {
                            typeUser = value;
                          });
                        },
                        title: MyStyle().titleH3Dark('Shoper'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            buildUser(),
            buildPassword(),
            buildBtnCreateAccount(),
          ],
        ),
      ),
    );
  }

  Future<Null> createSingInAndInsertData() async {
    await Firebase.initializeApp().then((value) async {
      print('firebase initalize Success');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user, password: password)
          .then((value) async {
        String uid = value.user.uid;
        print('uid ==>> $uid');

        // update Display Name
        await value.user
            .updateProfile(displayName: name)
            .then((value) => print('display name Success'));

        // Insert Value To CloudFirestore
        TypeUserModel model = TypeUserModel(name: name, typeuser: typeUser);
        Map<String, dynamic> data = model.toMap();
       
        await FirebaseFirestore.instance
            .collection('typeuser')
            .doc(uid)
            .set(data)
            .then((value) {
          String result = Api().findKeyByTypeUser(typeUser);
         
          Navigator.pushNamedAndRemoveUntil(context, result, (route) => false);
        });
      }).catchError((onError) =>
              normalDialog(context, onError.code, onError.message));
    });
  }

  Container buildBtnCreateAccount() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      width: screen * 0.6,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(primary: MyStyle().primaryColor),
        onPressed: () {
          if ((name?.isEmpty ?? true) ||
              (user?.isEmpty ?? true) ||
              (password?.isEmpty ?? true)) {
            normalDialog(context, 'Have Space ?', 'Please Fill Every Blank');
          } else if (typeUser == null) {
            normalDialog(context, 'No TypeUser',
                'Please Choose Type User by Click Buyer or Shopper');
          } else {
            createSingInAndInsertData();
          }
        },
        icon: Icon(Icons.cloud_upload),
        label: Text('Create Account'),
      ),
    );
  }
}
