import 'package:flutter/material.dart';
import 'dart:convert'; // JSON Parsing 패키지
import 'package:http/http.dart' as http; // http 통신 패키지

import 'main.dart';
import 'index_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final id_Controller = TextEditingController();
  final pw_Controller = TextEditingController();
  final name_Controller = TextEditingController();
  final cId_Controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    id_Controller.dispose();
    pw_Controller.dispose();
    name_Controller.dispose();
    cId_Controller.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Back Icon
              SizedBox(height: 20),
              space_BackIcon(),

              // Main Text
              SizedBox(height: 12),
              space_mainText(),

              // Info TextField
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
  signUp(username, password, name, cId) async {
    Map data = {
      'username': username,
      'password': password,
      'first_name': name,
      'c_id': cId
    };
    var jsonData = null;
    var response = await http.post('$apiUrl/api/app/auth/signup/', body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      print('회원가입');
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
  space_BackIcon() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.lightBlue[400],
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

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
              "Create your Account",
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
          // Password TextField
          TextField(
            controller: pw_Controller,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          // Name TextField
          TextField(
            controller: name_Controller,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          // Company ID TextField
          TextField(
            controller: cId_Controller,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Company ID',
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
              'Sign up',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            color: Colors.lightBlue[400],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            onPressed: () {
              signUp(id_Controller.text, pw_Controller.text,
                  name_Controller.text, cId_Controller.text);
              print('id = ' + id_Controller.text);
              print('pw = ' + pw_Controller.text);
              print('name = ' + name_Controller.text);
              print('cid = ' + cId_Controller.text);
            },
          ),
        ),
      ],
    );
  }
}
