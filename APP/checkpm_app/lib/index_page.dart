import 'package:checkpm_app/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'main.dart';
import 'notification_page.dart';

bool isEmptyChart = true;
bool isEmptyDevice = false;

List<FlSpot> pm10Spot = [];
List<FlSpot> pm25Spot = [];

class IndexPage extends StatefulWidget {
  final User user;
  IndexPage({Key key, @required this.user}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
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
    LoadChart(getDate, widget.user.token);
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
                          LoadChart(
                              '${nowDate.year}-${nowDate.month}-${nowDate.day}',
                              widget.user.token);
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
                  child: LineChart(isEmptyChart
                      ? EmptyChart()
                      : showPM10
                          ? PM10Chart()
                          : PM25Chart()),
                  // child: isEmptyChart
                  //     ? Center(
                  //         child: CircularProgressIndicator(),
                  //       )
                  //     : LineChart(
                  //         showPM10 ? PM10Chart() : PM25Chart(),
                  //       ),
                ),
              ),
            ),
            // ListView
            Expanded(
              child: isEmptyDevice
                  ? Center(child: CircularProgressIndicator())
                  : FutureBuilder<List<DeviceItem>>(
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
              ),
            ),
          );
        },
      ),
    );
  }

// 미세먼지 차트 데이터
  // 비어있는 차트
  LineChartData EmptyChart() {
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
          spots: [FlSpot(0, 0)],
          show: false,
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
          spots: pm10Spot,
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
          spots: pm25Spot, // 데이터 Spot 자리
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

  LoadChart(date, token) async {
    List<double> pm10value = List<double>();
    List<double> pm25value = List<double>();

    var response = await http.get('$apiUrl/api/app/main/chart/$date/',
        headers: <String, String>{'Authorization': "Token $token"});

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonList.isEmpty) {
        setState(() {
          isEmptyChart = true;
        });
      } else {
        // for 돌려서 리스트로 변환
        for (var i in jsonList) {
          pm10value.add(i['avgpm10']);
          pm25value.add(i['avgpm25']);
        }
        // 리스트를 FlSpot으로 변환
        setState(
          () {
            isEmptyChart = false;
            pm10Spot = pm10value.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value);
            }).toList();
            pm25Spot = pm25value.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value);
            }).toList();
          },
        );
      }
    } else {
      throw Exception('Faild to load Get');
    }
  }
}

// 메인페이지 Chart 데이터 HTTP GET
// LoadChart(date, token) async {
//   List<double> pm10value = List<double>();
//   List<double> pm25value = List<double>();

//   var response = await http.get('$apiUrl/api/app/main/chart/$date/',
//       headers: <String, String>{'Authorization': "Token $token"});

//   if (response.statusCode == 200) {
//     List jsonList = jsonDecode(utf8.decode(response.bodyBytes));
//     if (jsonList.isEmpty) {
//       isEmptyChart = true;
//     } else {
//       isEmptyChart = false;
//       // for 돌려서 리스트로 변환
//       for (var i in jsonList) {
//         pm10value.add(i['avgpm10']);
//         pm25value.add(i['avgpm25']);
//       }
//       // 리스트를 FlSpot으로 변환
//       pm10Spot = pm10value.asMap().entries.map((e) {
//         return FlSpot(e.key.toDouble(), e.value);
//       }).toList();
//       pm25Spot = pm25value.asMap().entries.map((e) {
//         return FlSpot(e.key.toDouble(), e.value);
//       }).toList();
//     }
//   } else {
//     throw Exception('Faild to load Get');
//   }
// }

// 메인페이지 디바이스 리스트 HTTP GET
Future<List<DeviceItem>> LoadDevice(date, token) async {
  var response = await http.get('$apiUrl/api/app/main/device/$date/',
      headers: <String, String>{'Authorization': "Token $token"});

  if (response.statusCode == 200) {
    List jsonList = jsonDecode(utf8.decode(response.bodyBytes));
    if (jsonList.isEmpty) {
      isEmptyDevice = true;
    } else {
      isEmptyDevice = false;
      var getList =
          jsonList.map((element) => DeviceItem.fromJson(element)).toList();

      return getList;
    }
  } else {
    throw Exception('Faild to load Get');
  }
}

// 메인페이지 디바이스 리스트 class
class DeviceItem {
  final int id;
  final String name;
  final bool connect;
  final double avgpm10;
  final double avgpm25;

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
