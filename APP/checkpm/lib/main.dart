import 'package:flutter/material.dart';

import 'login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(), // Login page로 연결
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
