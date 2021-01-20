import 'package:checkpm_app/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'main.dart';
import 'notification_page.dart';

class DeviceList {
  int no;
  String title;
  bool isconnect = false;
  int avgpm10;
  int avgpm25;

  DeviceList(this.title);
}

class IndexPage extends StatefulWidget {
  final User user;
  IndexPage({Key key, @required this.user}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool _isLoading = false;
  final _items = <DeviceList>[];

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  bool showPM10 = true;
  var date = DateTime.now();

  // @override
  // void initState() {
  //   super.initState();
  //   LoadMain('2021-01-14');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      appBar: AppBar(
        title: Text('CheckPM'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationPage(
                          user: widget.user,
                        )),
              );
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  // 날짜 변경 버튼
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          color: Color(0xffffce1f),
                          child: Text(
                            '${date.year}-${date.month}-${date.day}',
                            style: TextStyle(
                                color: showPM10 ? Colors.black : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            showMaterialDatePicker(
                              context: context,
                              selectedDate: date,
                              onChanged: (value) =>
                                  setState(() => date = value),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  // PM10, PM2.5 변경 버튼
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          color: Color(0xffffce1f),
                          child: Text(
                            showPM10 ? 'PM10' : 'PM2.5',
                            style: TextStyle(
                                color: showPM10 ? Colors.black : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            setState(() {
                              showPM10 = !showPM10;
                              print(showPM10);
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  // Chart
                  AspectRatio(
                    aspectRatio: 3 / 2,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: LineChart(
                          showPM10 ? PM10Chart() : PM25Chart(),
                        ),
                      ),
                    ),
                  ),
                  // ListView
                  Expanded(
                    child: ListView(
                      children: [
                        Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.circle,
                              color: Colors.green,
                              size: 36,
                            ),
                            title: Text('측정기 1'),
                            subtitle: Text('PM10 : 50          PM2.5: 20'),
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // LoadMain(String date) async {
  //   Map data = {'date': date};
  //   var jsonData = null;
  //   var response = await http.post('http://127.0.0.1:8000/api/app/main/',
  //       body: data,
  //       headers: <String, String>{'Authorization': "Token ${widget.user.token}"});
  //   if (response.statusCode == 200) {
  //     jsonData = json.decode(response.body);
  //     setState(() {
  //       _isLoading = false;
  //       print(jsonData);
  //     });
  //   } else {
  //     print(response.body);
  //   }
  // }

// List Item Widget
  Widget _buildItemWidget(DeviceList deviceList) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.circle,
          color: Colors.green,
          size: 36,
        ),
        title: Text('측정기 1'),
        subtitle: Text('PM10 : 50          PM2.5: 20'),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {},
      ),
    );
  }

// 미세먼지 차트 데이터
  LineChartData PM10Chart() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 3:
                return '3';
              case 6:
                return '6';
              case 9:
                return '9';
              case 12:
                return '12';
              case 15:
                return '15';
              case 18:
                return '18';
              case 21:
                return '21';
              case 24:
                return '24';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 10:
                return '좋음';
              case 30:
                return '보통';
              case 80:
                return '나쁨';
              case 150:
                return '매우 나쁨';
            }
            return '';
          },
          reservedSize: 45,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 24,
      minY: 0,
      maxY: 160,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 30),
            FlSpot(1, 50),
            FlSpot(2, 100),
            FlSpot(3, 141),
            FlSpot(4, 90),
            FlSpot(5, 75),
            FlSpot(6, 55),
            FlSpot(7, 47),
            FlSpot(8, 31),
            FlSpot(9, 29),
            FlSpot(10, 37),
            FlSpot(11, 46),
            FlSpot(12, 50),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

// 초미세먼지 차트 데이터
  LineChartData PM25Chart() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 3:
                return '3';
              case 6:
                return '6';
              case 9:
                return '9';
              case 12:
                return '12';
              case 15:
                return '15';
              case 18:
                return '18';
              case 21:
                return '21';
              case 24:
                return '24';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 10:
                return '좋음';
              case 30:
                return '보통';
              case 80:
                return '나쁨';
              case 150:
                return '매우 나쁨';
            }
            return '';
          },
          reservedSize: 45,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 24,
      minY: 0,
      maxY: 160,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 10),
            FlSpot(1, 30),
            FlSpot(2, 70),
            FlSpot(3, 35),
            FlSpot(4, 55),
            FlSpot(5, 32),
            FlSpot(6, 80),
            FlSpot(7, 90),
            FlSpot(8, 65),
            FlSpot(9, 60),
            FlSpot(10, 56),
            FlSpot(11, 42),
            FlSpot(12, 20),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
