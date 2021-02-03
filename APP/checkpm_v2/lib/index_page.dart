import 'package:flutter/material.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_material_pickers/flutter_material_pickers.dart';
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
  final pageView_controller = new PageController();

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
          space_AppBar(),
          // Chart
          space_Chart(),
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
      Container(
        color: Colors.amber[600],
        child: const Center(child: Text('Entry A')),
      ),
      Container(
        color: Colors.amber[500],
        child: const Center(child: Text('Entry B')),
      ),
      Container(
        color: Colors.amber[100],
        child: const Center(child: Text('Entry C')),
      ),
      // circle chart
      // Hitmap calender
      // Bar chart
    ];

    return Card(
      color: Colors.lightBlue[100],
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            // Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: <Widget>[
                    SizedBox(width: 10),
                    Text(
                      "2021-02-02",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ],
            ),

            // Chart PageView
            Container(
              height: 200,
              child: PageView(
                controller: pageView_controller,
                children: items,
              ),
            ),

            // Page View Indicator
            Container(
              height: 20,
              child: ScrollingPageIndicator(
                dotColor: Colors.grey,
                dotSelectedColor: Colors.white,
                dotSize: 6,
                dotSelectedSize: 8,
                dotSpacing: 12,
                controller: pageView_controller,
                itemCount: items.length,
                orientation: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  space_Devices() {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 2,
        // Item 나열
        children: [
          Card(
            color: Colors.red,
            child: Text('1'),
          ),
          Card(
            color: Colors.blue,
            child: Text('2'),
          ),
          Card(
            color: Colors.green,
            child: Text('3'),
          ),
          Card(
            color: Colors.yellow,
            child: Text('4'),
          ),
          Card(
            color: Colors.cyan,
            child: Text('5'),
          ),
        ],
      ),
    );
  }
}
