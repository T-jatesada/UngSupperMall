import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Color(0xff9d0000);
  Color primaryColor = Color(0xffd63e0f);
  Color lightColor = Color(0xffff713e);

  Container buildBackground(BuildContext context) {
    return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image(
                    image: AssetImage('images/top1.png'),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image(
                    image: AssetImage('images/top2.png'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image(
                    image: AssetImage('images/bottom1.png'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image(
                    image: AssetImage('images/bottom2.png'),
                  ),
                ),
              ],
            ),
          );
  }

  Widget showLogo() => Image(image: AssetImage('images/logo.png'));

  Widget titleH1(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkColor,
        ),
      );

      Widget titleH2Dark(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: darkColor,
        ),
      );

      Widget titleH3Dark(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 16,
          // fontWeight: FontWeight.w700,
          color: darkColor,
        ),
      );

       Widget titleH3Whete(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 16,
          // fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      );

       Widget titleH3Button(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 16,
          // fontWeight: FontWeight.w700,
          color: Colors.pink.shade600,
        ),
      );

  MyStyle();
}
