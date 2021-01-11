import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http 통신 패키지
import 'dart:convert'; // JSON Parsing 패키지

import 'index_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final id_Controller = TextEditingController();
  final pw_Controller = TextEditingController();

  @override
  void dispose() {
    id_Controller.dispose();
    pw_Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Main Text
              Text(
                'Check PM',
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: 70,
              ),
              // ID TextField
              TextField(
                controller: id_Controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ID',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Password TextField
              TextField(
                controller: pw_Controller,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'PassWord',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Login btn
              RaisedButton(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => IndexPage()),
                  );
                  print('id = ' + id_Controller.text);
                  print('pw = ' + pw_Controller.text);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
