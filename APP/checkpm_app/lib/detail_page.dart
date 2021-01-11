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

  // Chart
  bool isShowingMainData;
  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  // Picker's items
  // 설정 변경 확인
  bool isChanged = false;
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
                    content: Text('$DeviceName' + '의 설정을 변경하시겠습니까?'),
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
                              PMData(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
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
                      isChanged = true;
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
                      isChanged = true;
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
                      isChanged = true;
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
                          isChanged = true;
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

  LineChartData PMData() {
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
            fontSize: 14,
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
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(1, 114),
        FlSpot(2, 38),
        FlSpot(3, 21),
        FlSpot(4, 131),
        FlSpot(5, 64),
        FlSpot(6, 107),
        FlSpot(7, 69),
        FlSpot(8, 36),
        FlSpot(10, 109),
        FlSpot(12, 68),
        FlSpot(13, 67),
        FlSpot(15, 115),
        FlSpot(16, 74),
        FlSpot(17, 41),
        FlSpot(19, 16),
        FlSpot(20, 124),
        FlSpot(22, 54),
        FlSpot(24, 107),
      ],
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
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, 25),
        FlSpot(2, 73),
        FlSpot(3, 132),
        FlSpot(4, 32),
        FlSpot(5, 139),
        FlSpot(6, 76),
        FlSpot(7, 13),
        FlSpot(8, 37),
        FlSpot(9, 62),
        FlSpot(10, 143),
        FlSpot(11, 40),
        FlSpot(12, 102),
        FlSpot(14, 50),
        FlSpot(16, 123),
        FlSpot(18, 69),
        FlSpot(20, 95),
        FlSpot(21, 15),
        FlSpot(24, 41),
      ],
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );

    return [
      lineChartBarData1,
      lineChartBarData2,
    ];
  }
}
