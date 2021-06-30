import 'package:flutter/material.dart';
import 'package:heatmap_calendar/heatmap_calendar.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';

space_heatmap(_pm10, _pm2p5) {
  final _controller = new PageController();

  List<Widget> items = [
    // pm10 HeatMap
    Column(
      children: [
        Text(
          '미세',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 5),
        Expanded(
          child: HeatMapCalendar(
            input: _pm10,
            colorThresholds: {
              0: Colors.white,
              1: Colors.blue[600]!,
              16: Colors.blue[400]!,
              31: Colors.blue[200]!,
              41: Colors.green,
              51: Colors.orange,
              76: Colors.deepOrange,
              101: Colors.redAccent[700]!,
              151: Colors.black,
            },
            weekDaysLabels: ['일', '월', '화', '수', '목', '금', '토'],
            monthsLabels: [
              "",
              "1월",
              "2월",
              "3월",
              "4월",
              "5월",
              "6월",
              "7월",
              "8월",
              "9월",
              "10월",
              "1월",
              "12월",
            ],
            squareSize: 25.0,
            textOpacity: 0.3,
            labelTextColor: Colors.white,
            dayTextColor: Colors.black,
          ),
        ),
      ],
    ),
    // pm2p5 HeatMap
    Column(
      children: [
        Text(
          '초미세',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 5),
        Expanded(
          child: HeatMapCalendar(
            input: _pm2p5,
            colorThresholds: {
              0: Colors.white,
              1: Colors.blue[600]!,
              9: Colors.blue[400]!,
              16: Colors.blue[200]!,
              21: Colors.green,
              26: Colors.orange,
              38: Colors.deepOrange,
              51: Colors.redAccent[700]!,
              76: Colors.black,
            },
            weekDaysLabels: ['일', '월', '화', '수', '목', '금', '토'],
            monthsLabels: [
              "",
              "1월",
              "2월",
              "3월",
              "4월",
              "5월",
              "6월",
              "7월",
              "8월",
              "9월",
              "10월",
              "1월",
              "12월",
            ],
            squareSize: 25.0,
            textOpacity: 0.3,
            labelTextColor: Colors.white,
            dayTextColor: Colors.grey,
          ),
        ),
      ],
    ),
  ];

  return Row(
    children: [
      Expanded(
        child: PageView(
          controller: _controller,
          scrollDirection: Axis.vertical,
          children: items,
        ),
      ),
      Container(
        width: 10,
        child: ScrollingPageIndicator(
          dotColor: Colors.grey[400],
          dotSelectedColor: Colors.white,
          dotSize: 6,
          dotSelectedSize: 8,
          dotSpacing: 12,
          controller: _controller,
          itemCount: items.length,
          orientation: Axis.vertical,
        ),
      ),
    ],
  );
}
