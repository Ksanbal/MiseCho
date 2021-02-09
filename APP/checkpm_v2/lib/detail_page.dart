import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './detail_spaces/space_chart.dart' as detail_chart;
import 'main.dart';

Setting nowSetting;

List<FlSpot> detail_pm10Spot = [];
List<FlSpot> detail_pm25Spot = [];

class DetailPage extends StatefulWidget {
  final Device device;
  DetailPage({Key key, @required this.device}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // 설정 변경 확인
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    LoadChart(widget.device.device_id,
        '${nowDate.year}-${nowDate.month}-${nowDate.day}', widget.device.token);
    LoadSetting(widget.device.device_id, widget.device.token);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[400],
      appBar: space_AppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
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

  space_AppBar(context) {
    space_dialog() {
      return AlertDialog(
        title: Text('변경사항'),
        content: Text('${nowSetting.name}' + '의 설정을 변경하시겠습니까?'),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                // 변경사항 적용 코드 자리
                var data = GetSaveData(); // PUT할 데이터 값
                final response = await http.put(
                  '$apiUrl/api/app/device/value/${widget.device.device_id}/',
                  headers: <String, String>{
                    'Authorization': "Token ${widget.device.token}"
                  },
                  body: data,
                );

                Navigator.of(context).pop();
                if (response.statusCode == 200) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('변경사항'),
                          content: Text('변경사항이 저장되었습니다.'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
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
                          title: Text('변경사항'),
                          content: Text('변경사항이 저장되지 않았습니다.'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            )
                          ],
                        );
                      });
                }
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
    }

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          if (isChanged) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => space_dialog(),
            );
          } else {
            Navigator.pop(context);
          }
        },
      ),
      title: Text(
        "Device 1",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.lightBlue[400],
      elevation: 0,
    );
  }

  space_Chart() {
    // 날짜 부분
    space_date() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: <Widget>[
              SizedBox(width: 10),
              Text(
                "${nowDate.year}-${nowDate.month}-${nowDate.day}",
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
            onPressed: () {
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
        ],
      );
    }

    // chart
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
              child:
                  detail_chart.space_pmChart(detail_pm10Spot, detail_pm25Spot),
            ),
            SizedBox(height: 13),
          ],
        ),
      ),
    );
  }

  space_Setting() {
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

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
                      "${nowSetting.freq}분",
                      style: TextStyle(
                        color: Colors.lightBlue[400],
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  showMaterialNumberPicker(
                    context: context,
                    title: '미세먼지 측정주기',
                    minNumber: 1,
                    maxNumber: 60,
                    selectedNumber: nowSetting.freq,
                    onChanged: (value) => setState(
                      () {
                        nowSetting.freq = value;
                        isChanged = true;
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
                      "${PMNotice[nowSetting.pmhigh]}",
                      style: TextStyle(
                        color: text_color("${PMNotice[nowSetting.pmhigh]}"),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
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
        ],
      ),
    );
  }

  // 디바이스 Chart 데이터 HTTP GET
  LoadChart(device_id, date, token) async {
    List<double> pmHour = List<double>();
    List<double> pm10value = List<double>();
    List<double> pm25value = List<double>();

    var response = await http.get(
        '$apiUrl/api/app/device/chart/$device_id/$date/',
        headers: <String, String>{'Authorization': "Token $token"});

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      if (jsonList.isEmpty) {
        setState(() {
          detail_pm10Spot.clear();
          detail_pm25Spot.clear();
        });
      } else {
        // for 돌려서 리스트로 변환
        for (var i in jsonList) {
          pmHour.add(i['hour'].toDouble());
          pm10value.add(i['avgpm10'].roundToDouble());
          pm25value.add(i['avgpm25'].roundToDouble());
        }
        // 리스트를 FlSpot으로 변환
        setState(
          () {
            detail_pm10Spot.clear();
            detail_pm25Spot.clear();

            for (int i = 0; i < pmHour.length; i++) {
              detail_pm10Spot.add(FlSpot(pmHour[i], pm10value[i]));
              detail_pm25Spot.add(FlSpot(pmHour[i], pm25value[i]));
            }
          },
        );
      }
    } else {
      throw Exception('Faild to load Get');
    }
  }
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

// 디바이스 세팅 GET
LoadSetting(device_id, token) async {
  var response = await http.get('$apiUrl/api/app/device/value/$device_id/',
      headers: <String, String>{'Authorization': "Token $token"});

  var jsonData = json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    nowSetting = Setting.fromJson(jsonData);
  } else {
    throw Exception('Faild to load Get');
  }
}

class Setting {
  int id;
  String name;
  bool connect;
  int freq;
  int pmhigh;
  int c_id;

  Setting(
      {this.id, this.name, this.connect, this.freq, this.pmhigh, this.c_id});

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      id: json['id'],
      name: json['name'],
      connect: json['connect'],
      freq: json['freq'],
      pmhigh: json['pmhigh'],
      c_id: json['c_id'],
    );
  }
}

// 디바이스 세팅 PUT
GetSaveData() {
  Map data = {
    'name': nowSetting.name,
    'connect': nowSetting.connect.toString(),
    'freq': nowSetting.freq.toString(),
    'pmhigh': nowSetting.pmhigh.toString(),
    'c_id': nowSetting.c_id.toString(),
  };

  return data;
}
