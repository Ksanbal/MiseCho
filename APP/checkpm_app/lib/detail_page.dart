import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';

bool isEmptyChart = true;

List<FlSpot> pm10Spot = [];
List<FlSpot> pm25Spot = [];
NowSetting nowSetting;

class DetailPage extends StatefulWidget {
  final Device device;
  DetailPage({Key key, @required this.device}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    LoadChart(widget.device.device_id,
        '${nowDate.year}-${nowDate.month}-${nowDate.day}', widget.device.token);
    LoadSetting(widget.device.device_id, widget.device.token);
  }

  // 표시할 그래프
  bool showpm10 = true;

  // 설정 변경 확인
  bool isChanged = false;

  // Picker's items
  // 위험 미세먼지 정도
  List<String> PMNotice = <String>[
    '최고',
    '좋음',
    '양호',
    '보통',
    '나쁨',
    '상당히 나쁨',
    '매우 나쁨',
    '최악'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      appBar: AppBar(
        title: Text('${nowSetting.name}'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            if (isChanged) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('변경사항'),
                    content: Text('${nowSetting.name}' + '의 설정을 변경하시겠습니까?'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            // 변경사항 적용 코드 자리
                            // (){}
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text('Yes')),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text('No')),
                    ],
                  );
                },
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new_rounded),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('전원'),
                    content: Text('${nowSetting.name}' + '의 전원을 종료하시겠습니까?'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () async {
                            // HTTP PATCH
                            var response = await http.patch(
                                '${apiUrl}/api/app/device/value/${widget.device.device_id}/',
                                headers: <String, String>{
                                  'Authorization':
                                      "Token ${widget.device.token}"
                                });
                            if (response.statusCode == 200) {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('전원'),
                                      content: Text('곧 전원이 종료됩니다.'),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('전원'),
                                      content: Text('전원 종료에 실패했습니다.'),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        )
                                      ],
                                    );
                                  });
                            }
                          },
                          child: Text('OK')),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel')),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            // 현재 날짜 및 연결상태
            Expanded(
              child: Card(
                child: Center(
                  child: ListTile(
                    title: Text(
                      '${nowDate.year}-${nowDate.month}-${nowDate.day}',
                      style: TextStyle(
                        fontSize: 25,
                        letterSpacing: -1,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    trailing: Icon(
                      Icons.circle,
                      color: nowSetting.connect ? Colors.green : Colors.grey,
                      size: 40,
                    ),
                    onTap: () {
                      showMaterialDatePicker(
                        context: context,
                        selectedDate: nowDate,
                        onChanged: (value) => setState(() {
                          nowDate = value;
                          LoadChart(
                              widget.device.device_id,
                              '${nowDate.year}-${nowDate.month}-${nowDate.day}',
                              widget.device.token);
                        }),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Chart
            AspectRatio(
              aspectRatio: 1.23,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(
                          height: 37,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 16.0, left: 6.0),
                            child: LineChart(
                              showpm10 ? PM10Data() : PM25Data(),
                              swapAnimationDuration:
                                  const Duration(milliseconds: 250),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: FloatingActionButton(
                        child: Text(
                          showpm10 ? 'PM\n10' : 'PM\n2.5',
                          style: TextStyle(
                            color: showpm10
                                ? Color(0xffaa4cfc)
                                : Color(0xffffce1f),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        mini: true,
                        backgroundColor:
                            showpm10 ? Color(0xffffce1f) : Color(0xffaa4cfc),
                        onPressed: () {
                          setState(() {
                            showpm10 = !showpm10;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            // 미세먼지 측정주기
            Expanded(
              child: Card(
                child: Center(
                  child: ListTile(
                    leading: Text(
                      '미세먼지 측정주기',
                      style: TextStyle(fontSize: 25, letterSpacing: -1),
                    ),
                    trailing: Text(
                      '${nowSetting.freq}' + '분',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    onTap: () {
                      showMaterialNumberPicker(
                        context: context,
                        title: '미세먼지 측정주기',
                        minNumber: 1,
                        maxNumber: 60,
                        selectedNumber: nowSetting.freq,
                        onChanged: (value) => setState(() {
                          nowSetting.freq = value;
                          isChanged = true;
                        }),
                      );
                    },
                  ),
                ),
              ),
            ),
            // 위험 미세먼지 정도
            Expanded(
              child: Card(
                child: Center(
                  child: ListTile(
                    leading: Text(
                      '위험 미세먼지 정도',
                      style: TextStyle(fontSize: 25, letterSpacing: -1),
                    ),
                    trailing: Text(
                      '${PMNotice[nowSetting.pmhigh]}',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    onTap: () {
                      showMaterialScrollPicker(
                        context: context,
                        title: '위험 미세먼지 정도',
                        items: PMNotice,
                        selectedItem: PMNotice[nowSetting.pmhigh],
                        onChanged: (value) => setState(() {
                          nowSetting.pmhigh = PMNotice.indexOf(value);
                          isChanged = true;
                        }),
                      );
                    },
                  ),
                ),
              ),
            ),
            // 알림 데이터 누락 횟수
            Expanded(
              child: Card(
                child: Center(
                  child: ListTile(
                    leading: Text(
                      '알림 데이터 누락 횟수',
                      style: TextStyle(fontSize: 25, letterSpacing: -1),
                    ),
                    trailing: Text(
                      '${nowSetting.null_freq}' + '회',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    onTap: () {
                      showMaterialNumberPicker(
                        context: context,
                        title: '알림 데이터 누락 횟수',
                        minNumber: 1,
                        maxNumber: 100,
                        selectedNumber: nowSetting.null_freq,
                        onChanged: (value) => setState(() {
                          nowSetting.null_freq = value;
                          isChanged = true;
                        }),
                      );
                    },
                  ),
                ),
              ),
            ),
            // 기기 작동시간
            Expanded(
              child: Card(
                child: Center(
                  child: ListTile(
                    leading: Text(
                      '기기 작동시간',
                      style: TextStyle(fontSize: 25, letterSpacing: -1),
                    ),
                    trailing: Text(
                      '${nowSetting.works_s.format(context)}~${nowSetting.works_e.format(context)}',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          letterSpacing: -2),
                    ),
                    onTap: () {
                      // StartTime
                      showMaterialTimePicker(
                        context: context,
                        title: '시작시간',
                        selectedTime: nowSetting.works_s,
                        onChanged: (value) => setState(() {
                          nowSetting.works_s = value;
                          isChanged = true;
                        }),
                        onConfirmed: () {
                          // StopTime
                          showMaterialTimePicker(
                            context: context,
                            title: '종료시간',
                            selectedTime: nowSetting.works_e,
                            onChanged: (value) => setState(() {
                              nowSetting.works_e = value;
                              isChanged = true;
                            }),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// 차트 위젯
  LineChartData PM10Data() {
    return LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          ),
          touchCallback: (LineTouchResponse touchResponse) {},
          handleBuiltInTouches: true,
        ),
        gridData: FlGridData(
          show: false,
        ),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTextStyles: (value) => const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            margin: 10,
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
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 0:
                  return '최고';
                case 15:
                  return '좋음';
                case 30:
                  return '양호';
                case 40:
                  return '보통';
                case 50:
                  return '나쁨';
                case 75:
                  return '상당히\n나쁨';
                case 100:
                  return '매우\n나쁨';
                case 150:
                  return '최악';
              }
              return '';
            },
            margin: 8,
            reservedSize: 30,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
        minX: 0,
        maxX: 24,
        maxY: 160,
        minY: 0,
        lineBarsData: isEmptyChart ? EmptyLinesBarData() : linesBarData1());
  }

  LineChartData PM25Data() {
    return LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
        ),
        gridData: FlGridData(
          show: false,
        ),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTextStyles: (value) => const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            margin: 10,
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
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 0:
                  return '최고';
                case 10:
                  return '좋음';
                case 15:
                  return '양호';
                case 20:
                  return '보통';
                case 25:
                  return '나쁨';
                case 35:
                  return '상당히\n나쁨';
                case 50:
                  return '매우\n나쁨';
                case 75:
                  return '최악';
              }
              return '';
            },
            margin: 8,
            reservedSize: 30,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
        minX: 0,
        maxX: 24,
        maxY: 80,
        minY: 0,
        lineBarsData: isEmptyChart ? EmptyLinesBarData() : linesBarData2());
  }

// 빈 차트 데이터
  List<LineChartBarData> EmptyLinesBarData() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: [FlSpot(1, 114)],
      show: false,
      isCurved: true,
      colors: [
        const Color(0xffffce1f),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    return [
      lineChartBarData1,
    ];
  }

// 실제 차트 데이터
  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: pm10Spot,
      isCurved: true,
      colors: [
        const Color(0xffffce1f),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: true, colors: [
        const Color(0x33ffce1f),
      ]),
    );

    return [lineChartBarData1];
  }

  List<LineChartBarData> linesBarData2() {
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: pm25Spot,
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: [
          const Color(0x33aa4cfc),
        ],
      ),
    );

    return [lineChartBarData2];
  }

// 디바이스 Chart 데이터 HTTP GET
  LoadChart(device_id, date, token) async {
    List<double> pm10value = List<double>();
    List<double> pm25value = List<double>();

    var response = await http.get(
        '$apiUrl/api/app/device/chart/$device_id/$date/',
        headers: <String, String>{'Authorization': "Token $token"});
    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
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

// 디바이스 세팅 GET
LoadSetting(device_id, token) async {
  var response = await http.get('$apiUrl/api/app/device/value/$device_id/',
      headers: <String, String>{'Authorization': "Token $token"});

  var jsonData = json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    nowSetting = NowSetting.fromJson(jsonData);
  } else {
    throw Exception('Faild to load Get');
  }
}

class NowSetting {
  int id;
  String name;
  bool connect;
  int freq;
  int pmhigh;
  int null_freq;
  TimeOfDay works_s;
  TimeOfDay works_e;

  NowSetting({
    this.id,
    this.name,
    this.connect,
    this.freq,
    this.pmhigh,
    this.null_freq,
    this.works_s,
    this.works_e,
  });

  factory NowSetting.fromJson(Map<String, dynamic> json) {
    // nowSetting에 저장된 String 시간값을 표시가능한 TimeOfDay로 변경
    int s_hour = int.parse(json['work_s'].substring(0, 2));
    int s_min = int.parse(json['work_s'].substring(2, 4));
    int e_hour = int.parse(json['work_e'].substring(0, 2));
    int e_min = int.parse(json['work_e'].substring(2, 4));

    TimeOfDay start_time = TimeOfDay(hour: s_hour, minute: s_min);
    TimeOfDay stop_time = TimeOfDay(hour: e_hour, minute: e_min);

    return NowSetting(
      id: json['id'],
      name: json['name'],
      connect: json['connect'],
      freq: json['freq'],
      pmhigh: json['pmhigh'],
      null_freq: json['null_freq'],
      works_s: start_time,
      works_e: stop_time,
    );
  }
}

// 디바이스 세팅 PUT
