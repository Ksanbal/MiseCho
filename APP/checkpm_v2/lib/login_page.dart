import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:convert'; // JSON Parsing 패키지
import 'package:http/http.dart' as http; // http 통신 패키지
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'main.dart' as main;
import 'signup_page.dart';
import 'index_page.dart';

class Login2 extends StatefulWidget {
  @override
  _Login2State createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  FirebaseMessaging _messaging = FirebaseMessaging.instance; // FCM 인스턴스
  bool isLoading = true;
  final id_Controller = TextEditingController();
  final pw_Controller = TextEditingController();

  @override
  void initState() {
    firebaseCloudMessaging_Listeners();
    readStorage();
    super.initState();
  }

  void firebaseCloudMessaging_Listeners() async {
    // 토큰값
    _messaging.getToken().then((String? token) {
      // 메인의 데이터에 토큰값 추가
      if (token != null) {
        main.myFCMToken = token;
        print("FCM Token : $token");
      }
    });

    await _messaging.setForegroundNotificationPresentationOptions(sound: true);
  }

  @override
  void dispose() {
    super.dispose();
    id_Controller.dispose();
    pw_Controller.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Main Text
                      space_mainText(),

                      // ID, PW TextField
                      SizedBox(height: 30),
                      space_login(),

                      // Login, Signup btns
                      SizedBox(height: 20),
                      space_btns(),
                      SizedBox(height: 80),
                    ],
                  ),
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
      'fcmToken': main.myFCMToken,
    };
    var jsonData = null;
    var response =
        await http.post('${main.apiUrl}/api/app/auth/signin/', body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(
        () {
          final user = main.User(jsonData['token']);
          writeStorage(username, password);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => IndexPage(user: user)),
          );
        },
      );
    } else {
      setState(() {
        isLoading = false;
      });
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
                child: Text("Close"),
              )
            ],
          );
        },
      );
      return false;
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
      // width: 300.0,
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "로그인 진행하기",
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
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: '아이디',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Password TextField
          TextField(
            controller: pw_Controller,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
              labelText: '비밀번호',
            ),
          ),
        ],
      ),
    );
  }

  space_btns() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: <Widget>[
          ButtonTheme(
            minWidth: 500.0,
            height: 50.0,
            child: RaisedButton(
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              color: Colors.lightBlue[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              onPressed: () {
                signIn(id_Controller.text, pw_Controller.text);
              },
            ),
          ),
          SizedBox(height: 20.0),
          ButtonTheme(
            minWidth: 500.0,
            height: 50,
            child: RaisedButton(
              child: Text(
                '회원가입',
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
          SizedBox(height: 5.0),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              child: Text("비밀번호 재설정"),
              onPressed: () {
                TextEditingController _username_ctrl = TextEditingController();
                TextEditingController _new_pwd_ctrl = TextEditingController();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "비밀번호 재설정",
                        textAlign: TextAlign.center,
                      ),
                      content: Container(
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _username_ctrl,
                              decoration: InputDecoration(
                                labelText: '아이디',
                              ),
                            ),
                            TextFormField(
                              controller: _new_pwd_ctrl,
                              decoration: InputDecoration(
                                labelText: '비밀번호',
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text("Ok"),
                          onPressed: () async {
                            var res = await http.post(
                              "${main.apiUrl}/api/app/auth/changePwd/",
                              headers: <String, String>{
                                'Content-Type': "application/json",
                              },
                              body: jsonEncode(
                                {
                                  'username': _username_ctrl.text,
                                  'new_pwd': _new_pwd_ctrl.text,
                                },
                              ),
                            );

                            if (res.statusCode == 200) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "${_username_ctrl.text}님의 비밀번호가 재설정되었습니다."),
                                ),
                              );
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "${utf8.decode(res.bodyBytes)}, 비밀번호 재설정을 실패하였습니다."),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  readStorage() async {
    var loginValue;
    final storage = new FlutterSecureStorage();
    await storage.read(key: "misecho_login").then((value) {
      if (value != null) {
        setState(() {
          isLoading = false;
        });
        loginValue = jsonDecode(value);
        signIn(loginValue['id'], loginValue['pw']);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }
}

writeStorage(String id, String pw) async {
  final storage = new FlutterSecureStorage();
  Map login = {"id": id, 'pw': pw};
  await storage.write(key: "misecho_login", value: jsonEncode(login));
}
