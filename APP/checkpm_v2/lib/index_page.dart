import 'package:checkpm_v2/detail_page.dart';
import 'package:checkpm_v2/notice_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';
import 'package:circle_chart/circle_chart.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'main.dart';
// import 'notification_page.dart';
// import 'detail_page.dart';

import './index_spaces/space_circleInfo.dart';
import './index_spaces/space_heatmap.dart';
import './index_spaces/space_chart.dart';

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
              Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: NotificationPage(),
                  )
                  // MaterialPageRoute(
                  //   builder: (context) => NotificationPage(),
                  // ),
                  );
            },
          ),
        )
      ],
    );
  }

  space_Chart() {
    List<Widget> items = [
      Container(
        color: Colors.lightBlue[400],
        child: space_circle(),
      ),
      Container(
        color: Colors.lightBlue[400],
        child: space_heatmap(),
      ),
      Container(
        color: Colors.lightBlue[400],
        child: space_pmChart(),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: Colors.lightBlue[400],
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              // Date Picker
              space_date(),

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
                  dotColor: Colors.grey[400],
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
      ),
    );
  }

  space_date() {
    return Row(
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
    );
  }

  space_Devices() {
    return Expanded(
      child: GridView.count(
        childAspectRatio: 1.3,
        padding: const EdgeInsets.all(5.0),
        crossAxisCount: 2,
        // Item 나열
        children: [
          tmp_card(context),
          tmp_card(context),
          tmp_card(context),
          tmp_card(context),
          tmp_card(context),
          tmp_card(context),
        ],
      ),
    );
  }
}

tmp_card(context) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    color: Colors.white,
    child: FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          SizedBox(height: 15),
          Text(
            'Device 1',
            style: TextStyle(
              color: Colors.lightBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: CircleChart(
                  progressColor: make_color('pm10', 20),
                  progressNumber: 20,
                  maxNumber: 160,
                ),
              ),
              Expanded(
                child: CircleChart(
                  progressColor: make_color('pm2p5', 49),
                  progressNumber: 31,
                  maxNumber: 80,
                ),
              ),
            ],
          ),
        ],
      ),
      onPressed: () {
        //
        Navigator.push(
          context,
          PageTransition(
            child: DetailPage(),
            type: PageTransitionType.bottomToTop,
            // duration: Duration(seconds: 1),
          ),
        );
      },
    ),
  );
}
