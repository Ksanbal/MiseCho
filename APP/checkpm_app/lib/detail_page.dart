import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Device Name
  var DeviceName = '측정기 1';

  // Picker's items
  // 미세먼지 측정 주기
  var PMFre = 5;
  // 위험 미세먼지 정도
  var selectedPMNotice = '매우 나쁨';
  List<String> PMNotice = <String>['좋음', '보통', '나쁨', '매우 나쁨'];
  // 알림 데이터 누락 횟수
  var DataNotice = 5;
  // 기기 작동시간
  var startTime = TimeOfDay(hour: 9, minute: 0);
  var stopTime = TimeOfDay(hour: 18, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      appBar: AppBar(
        title: Text('$DeviceName'),
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
                    content: Text('$DeviceName' + '의 전원을 종료하시겠습니까?'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
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
            // 연결상태
            Expanded(
              child: Card(
                child: Center(
                  child: ListTile(
                    leading: Text(
                      '연결상태',
                      style: TextStyle(fontSize: 25, letterSpacing: -1),
                    ),
                    trailing: Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            // Chart

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
                      '$PMFre' + '분',
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
                        selectedNumber: PMFre,
                        onChanged: (value) => setState(() => PMFre = value),
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
                      '$selectedPMNotice',
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
                        selectedItem: selectedPMNotice,
                        onChanged: (value) =>
                            setState(() => selectedPMNotice = value),
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
                      '$DataNotice' + '회',
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
                        selectedNumber: DataNotice,
                        onChanged: (value) =>
                            setState(() => DataNotice = value),
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
                      '${startTime.format(context)}~${stopTime.format(context)}',
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
                        selectedTime: startTime,
                        onChanged: (value) => setState(() => startTime = value),
                        onConfirmed: () {
                          // StopTime
                          showMaterialTimePicker(
                            context: context,
                            title: '종료시간',
                            selectedTime: stopTime,
                            onChanged: (value) =>
                                setState(() => stopTime = value),
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
}
