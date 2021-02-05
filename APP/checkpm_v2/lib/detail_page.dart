import 'package:flutter/material.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

import './detail_spaces/space_chart.dart';
import 'main.dart';

class DetailPage extends StatefulWidget {
  // final Device device;
  // DetailPage({Key key, @required this.device}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[400],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            // AppBar
            SizedBox(height: 30),
            space_AppBar(context),

            // Chart
            space_Chart(),
            // Setting
            space_Setting(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

space_AppBar(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      // Back Icon Btn
      IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      // Text
      Text(
        "Device 1",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      SizedBox(width: 40),
      //   // Text
      //   Row(
      //     children: <Widget>[
      //       SizedBox(width: 15),
      //       Text(
      //         "MiseCho",
      //         style: TextStyle(
      //           fontSize: 20,
      //           fontFamily: "Pacifico",
      //           color: Colors.lightBlue[400],
      //         ),
      //       ),
      //     ],
      //   ),
      //   // Notice Icon
      //   Align(
      //     alignment: Alignment.topRight,
      //     child: IconButton(
      //       icon: Icon(Icons.notifications),
      //       color: Colors.lightBlue[400],
      //       onPressed: () {
      //         // 알림페이지로 push 설정
      //       },
      //     ),
      //   )
    ],
  );
}

space_Chart() {
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
                color: Colors.lightBlue[400],
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.calendar_today),
          color: Colors.lightBlue[400],
          onPressed: () {},
        ),
      ],
    );
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: <Widget>[
          // Date Picker
          space_date(),
          // Chart PageView
          Container(
            height: 300,
            color: Colors.white,
            child: space_pmChart(),
          ),
          SizedBox(height: 13),
        ],
      ),
    ),
  );
}

space_Setting() {
  return Expanded(
    child: Row(
      children: [
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 3,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "미세먼지 측정주기",
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: -1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "6분",
                    style: TextStyle(
                      color: Colors.lightBlue[400],
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 3,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "알림 미세먼지 농도",
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: -1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "상당히 나쁨",
                    style: TextStyle(
                      color: text_color("상당히 나쁨"),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

text_color(value) {
  Color return_color;

  if (value == "최고") {
    return_color = Colors.blue[600];
  } else if (value == "좋음") {
    return_color = Colors.blue[400];
  } else if (value == "양호") {
    return_color = Colors.blue[200];
  } else if (value == "보통") {
    return_color = Colors.green;
  } else if (value == "나쁨") {
    return_color = Colors.orange;
  } else if (value == "상당히 나쁨") {
    return_color = Colors.deepOrange;
  } else if (value == "매우 나쁨") {
    return_color = Colors.redAccent[700];
  } else if (value == "최악") {
    return_color = Colors.black;
  }
  return return_color;
}
