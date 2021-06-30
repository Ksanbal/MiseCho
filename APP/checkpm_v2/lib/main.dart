import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'login_page.dart';

// 백그라운드 FCM
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message : ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: LoginPage(), // Login page로 연결
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
        SizedBox(
          width: 200.0,
          height: 200.0,
          child: RotateAnimatedTextKit(
            text: ["Call me", "MiseCho"],
            textStyle: TextStyle(
              fontSize: 40.0,
              fontFamily: "Pacifico",
              color: Colors.white,
            ),
            textAlign: TextAlign.start,
            totalRepeatCount: 1,
            duration: Duration(milliseconds: 900),
            onFinished: () {
              Navigator.pushReplacement(
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

final String apiUrl =
    'http://ec2-18-237-137-101.us-west-2.compute.amazonaws.com/';
var nowDate = DateTime.now();

String myFCMToken = "";

// 미세먼지 단계별 컬러
make_color(type, value) {
  Color? return_color;
  if (type == 'pm10') {
    if (value <= 15) {
      return_color = Colors.blue[600];
    } else if (value <= 30) {
      return_color = Colors.blue[400];
    } else if (value <= 40) {
      return_color = Colors.blue[200];
    } else if (value <= 50) {
      return_color = Colors.green;
    } else if (value <= 75) {
      return_color = Colors.orange;
    } else if (value <= 100) {
      return_color = Colors.deepOrange;
    } else if (value <= 150) {
      return_color = Colors.redAccent[700];
    } else if (value > 150) {
      return_color = Colors.black;
    }
  } else if (type == 'pm2p5') {
    if (value <= 8) {
      return_color = Colors.blue[600];
    } else if (value <= 15) {
      return_color = Colors.blue[400];
    } else if (value <= 20) {
      return_color = Colors.blue[200];
    } else if (value <= 25) {
      return_color = Colors.green;
    } else if (value <= 37) {
      return_color = Colors.orange;
    } else if (value <= 50) {
      return_color = Colors.deepOrange;
    } else if (value <= 75) {
      return_color = Colors.redAccent[700];
    } else if (value > 76) {
      return_color = Colors.black;
    }
  }
  return return_color;
}
