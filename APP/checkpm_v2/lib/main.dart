import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'login_page.dart';
import 'index_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      // home: LoginPage(), // Login page로 연결
      home: IndexPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlue[400],
        child: Center(child: mainTextWiget(context)),
      ),
    );
  }

  mainTextWiget(context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(width: 20.0, height: 100.0),
        Text(
          "Be",
          style: TextStyle(
            fontSize: 50.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 20.0, height: 100.0),
        SizedBox(
          width: 200.0,
          height: 200.0,
          child: RotateAnimatedTextKit(
            text: ["Clean", "Smart", "Easy"],
            textStyle: TextStyle(
              fontSize: 50.0,
              fontFamily: "Horizion",
              color: Colors.white,
            ),
            textAlign: TextAlign.start,
            totalRepeatCount: 1,
            duration: Duration(milliseconds: 1000),
            onFinished: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: Login2(),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class User {
  String token;

  User(this.token);
}

class Device {
  String token;
  int device_id;

  Device(this.token, this.device_id);
}

final String apiUrl = 'http://www.checkpm.tk';
var nowDate = DateTime.now();
