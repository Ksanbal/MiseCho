import 'package:flutter/material.dart';
import 'dart:convert'; // JSON Parsing 패키지
import 'package:http/http.dart' as http; // http 통신 패키지

import 'index_page.dart';

class User {
  String token;

  User(this.token);
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final id_Controller = TextEditingController();
  final pw_Controller = TextEditingController();

  bool _isLoading = false;

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
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
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
                        _isLoading = true;
                        signIn(id_Controller.text, pw_Controller.text);
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

  signIn(String username, password) async {
    Map data = {
      'username': username,
      'password': password,
    };
    var jsonData = null;
    var response = await http.post('http://127.0.0.1:8000/api/app/auth/signin/',
        body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        _isLoading = false;
        final user = User(jsonData['token']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IndexPage(user: user)),
        );
      });
    } else {
      print(response.body);
    }
  }
}
