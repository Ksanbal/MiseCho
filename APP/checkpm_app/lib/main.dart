import 'package:checkpm_app/index_page.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'index_page.dart';
import 'notification_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // home: LoginPage(), // Login page로 연결
      home: IndexPage(),
      // home: NotificationPage(),
    );
  }
}