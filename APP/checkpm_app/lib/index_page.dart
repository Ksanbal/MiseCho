import 'package:checkpm_app/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'main.dart';
import 'notification_page.dart';

class IndexPage extends StatefulWidget {
  final User user;
  IndexPage({Key key, @required this.user}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  Future<List<ChartItem>> getData;
  Future<List<DeviceItem>> getList;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  bool showPM10 = true;

  @override
  void initState() {
    super.initState();
    var getDate = '${nowDate.year}-${nowDate.month}-${nowDate.day}';
    // getData = LoadChart(getDate, widget.user.token);
    getList = LoadDevice(getDate, widget.user.token);
  }

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
      body: Padding(
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
                      '${nowDate.year}-${nowDate.month}-${nowDate.day}',
                      style: TextStyle(
                          color: showPM10 ? Colors.black : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      showMaterialDatePicker(
                        context: context,
                        selectedDate: nowDate,
                        onChanged: (value) => setState(() => nowDate = value),
                        onConfirmed: () {
                          getList = LoadDevice(
                              '${nowDate.year}-${nowDate.month}-${nowDate.day}',
                              widget.user.token);
                        },
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
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: LineChart(
                    showPM10 ? PM10Chart() : PM25Chart(),
                  ),
                ),
              ),
            ),
            // ListView
            Expanded(
              child: FutureBuilder<List<DeviceItem>>(
                future: getList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        DeviceItem deviceItem = snapshot.data[index];
                        return _buildItemWidget(deviceItem);
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

// List Item Widget
  Widget _buildItemWidget(DeviceItem deviceitem) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.circle,
          color: deviceitem.connect ? Colors.green : Colors.grey,
          size: 36,
        ),
        title: Text(deviceitem.name),
        subtitle: Text(
            'PM10 : ${deviceitem.avgpm10}          PM2.5: ${deviceitem.avgpm25}'),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          final device = Device(widget.user.token, deviceitem.id);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                      device: device,
                    )),
          );
        },
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

// 메인페이지 Chart 데이터 HTTP GET
Future<List<ChartItem>> LoadChart(date, token) async {
  var response = await http.get('$apiUrl/api/app/main/chart/$date/',
      headers: <String, String>{'Authorization': "Token $token"});

  if (response.statusCode == 200) {
    List jsonList = jsonDecode(utf8.decode(response.bodyBytes));

    var getList =
        jsonList.map((element) => ChartItem.fromJson(element)).toList();
    return getList;
  } else {
    throw Exception('Faild to load Get');
  }
}

// 메인페이지 차트 데이터 class
class ChartItem {
  final int avgpm10;
  final int avgpm25;

  ChartItem({this.avgpm10, this.avgpm25});

  factory ChartItem.fromJson(Map<String, dynamic> json) {
    return ChartItem(
      avgpm10: json['avgpm10'],
      avgpm25: json['avgpm25'],
    );
  }
}

// 메인페이지 디바이스 리스트 HTTP GET
Future<List<DeviceItem>> LoadDevice(date, token) async {
  var response = await http.get('$apiUrl/api/app/main/device/$date/',
      headers: <String, String>{'Authorization': "Token $token"});

  if (response.statusCode == 200) {
    List jsonList = jsonDecode(utf8.decode(response.bodyBytes));

    var getList =
        jsonList.map((element) => DeviceItem.fromJson(element)).toList();

    return getList;
  } else {
    throw Exception('Faild to load Get');
  }
}

// 메인페이지 디바이스 리스트 class
class DeviceItem {
  final int id;
  final String name;
  final bool connect;
  final int avgpm10;
  final int avgpm25;

  DeviceItem({this.id, this.name, this.connect, this.avgpm10, this.avgpm25});

  factory DeviceItem.fromJson(Map<String, dynamic> json) {
    return DeviceItem(
      id: json['id'],
      name: json['name'],
      connect: json['connect'],
      avgpm10: json['avgpm10'],
      avgpm25: json['avgpm25'],
    );
  }
}
