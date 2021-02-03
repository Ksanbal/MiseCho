import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'main.dart';
// import 'notification_page.dart';
// import 'detail_page.dart';

bool isEmptyChart = true;
bool isEmptyDevice = false;

List<FlSpot> pm10Spot = [];
List<FlSpot> pm25Spot = [];

class IndexPage extends StatefulWidget {
  // final User user;
  // IndexPage({Key key, @required this.user}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  void initStae() {
    super.initState();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // App bar
          SizedBox(height: 30),
          // space_AppBar(),
          // Chart
          // space_Chart(),
          // device grid
          space_Devices(),
        ],
      ),
    );
  }
// HTTP

// Widget
  space_AppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Text
        Row(
          children: <Widget>[
            SizedBox(width: 15),
            Text(
              "MiseCho",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Pacifico",
                color: Colors.lightBlue[400],
              ),
            ),
          ],
        ),
        // Notice Icon
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.lightBlue[400],
            onPressed: () {
              // 알림페이지로 push 설정
            },
          ),
        )
      ],
    );
  }

  space_Chart() {
    List<Widget> items = [
      Container(color: Colors.red, width: 100, height: 100),
      Container(color: Colors.blue, width: 100, height: 100),
      Container(color: Colors.green, width: 100, height: 100),
    ];

    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            // Date Picker
            FlatButton(
              child: Text('2021-2-2'),
              onPressed: null,
            ),

            // Page View
            PageView(
              children: items,
            ),

            // Page View Indicator
          ],
        ),
      ),
    );
  }

  space_Devices() {
    return GridView.count(
      crossAxisCount: 2,
      // Item 나열
    );
  }
}
