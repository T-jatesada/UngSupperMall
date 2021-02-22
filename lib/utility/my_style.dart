import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Color(0xff9d0000);
  Color primaryColor = Color(0xffd63e0f);
  Color lightColor = Color(0xffff713e);

  Widget showLogo() => Image(image: AssetImage('images/logo.png'));

  Widget titleH1(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkColor,
        ),
      );

  MyStyle();
}
