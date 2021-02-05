import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:convert'; // JSON Parsing 패키지
import 'package:http/http.dart' as http; // http 통신 패키지

import 'main.dart';
import 'signup_page.dart';
import 'index_page.dart';

class Login2 extends StatefulWidget {
  @override
  _Login2State createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  final id_Controller = TextEditingController();
  final pw_Controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    id_Controller.dispose();
    pw_Controller.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              // Main Text
              SizedBox(height: 80),
              space_mainText(),

              // ID, PW TextField
              SizedBox(height: 30),
              space_login(),

              // Login, Signup btns
              SizedBox(height: 20),
              space_btns(),
            ],
          ),
        ),
      ),
    );
  }

// Http
  signIn(username, password) async {
    Map data = {
      'username': username,
      'password': password,
    };
    var jsonData = null;
    var response = await http.post('$apiUrl/api/app/auth/signin/', body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      print('로그인');
      setState(() {
        final user = User(jsonData['token']);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => IndexPage(user: user)),
        // );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IndexPage()),
        );
      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('${response.statusCode}'),
              content: Text(utf8.decode(response.bodyBytes)),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Close"))
              ],
            );
          });
    }
  }

// Widget
  space_mainText() {
    return Text(
      'MiseCho',
      style: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue[400],
        letterSpacing: 2,
        fontFamily: 'Pacifico',
      ),
    );
  }

  space_login() {
    return Container(
      width: 300.0,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Login to your Account",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),

          // ID TextField
          TextField(
            controller: id_Controller,
            decoration: InputDecoration(
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
              labelText: 'Password',
            ),
          ),
        ],
      ),
    );
  }

  space_btns() {
    return Column(
      children: <Widget>[
        ButtonTheme(
          minWidth: 300.0,
          height: 50.0,
          child: RaisedButton(
            child: Text(
              'Sign in',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            color: Colors.lightBlue[400],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            onPressed: () {
              signIn(id_Controller.text, pw_Controller.text);
              print('id = ' + id_Controller.text);
              print('pw = ' + pw_Controller.text);
            },
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        ButtonTheme(
          minWidth: 300.0,
          height: 50,
          child: RaisedButton(
            child: Text(
              'Sign up',
              style: TextStyle(fontSize: 20, color: Colors.lightBlue),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: SignupPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
