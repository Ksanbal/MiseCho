import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';
import 'package:circle_chart/circle_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:heatmap_calendar/time_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Messaging 패키지

import 'main.dart';
import 'notice_page.dart';
import 'detail_page.dart';

import './index_spaces/space_circleInfo.dart' as index_circle;
import './index_spaces/space_heatmap.dart' as index_heat;
import './index_spaces/space_chart.dart' as index_chart;
import 'write_ssid_page.dart' as write_ssid_page;
import 'write_ssid_ble_page.dart' as write_ssid_ble_page;

bool isEmptyDevice = false;

// Line Chart 데이터
List<FlSpot> index_pm10Spot = [];
List<FlSpot> index_pm25Spot = [];

// Circle Chart 데이터
double? index_current_pm10;
double? index_current_pm2p5;

// HeatMap Chart 데이터
Map<DateTime, int>? index_heat_pm10;
Map<DateTime, int>? index_heat_pm2p5;

class IndexPage extends StatefulWidget {
  final User? user;
  IndexPage({@required this.user});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool isLoading = true;

  final pageView_controller = new PageController();
  Future<List<DeviceItem>>? getList;

  @override
  void initState() {
    firebaseCloudMessaging_Listeners();
    doinit();
    super.initState();
  }

  doinit() async {
    var getDate = '${nowDate.year}-${nowDate.month}-${nowDate.day}';
    await LoadChart(
      '${nowDate.year}-${nowDate.month}-${nowDate.day}',
      widget.user!.token,
    );
    await LoadHeatmapChart(widget.user!.token);
    getList = LoadDevice(getDate, widget.user!.token);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: space_AppBar(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(backgroundColor: Colors.grey))
          : Column(
              children: <Widget>[
                // Chart
                space_Chart(),
                // device grid
                space_Devices(),
              ],
            ),
      floatingActionButton: myFloatActionBtn(),
    );
  }

// Widget
  space_AppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: InkWell(
        child: Text(
          "MiseCho",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Pacifico",
            color: Colors.lightBlue[400],
          ),
        ),
        onTap: () {
          // 로그아웃
          logout();
        },
      ),
      leading: IconButton(
        icon: Icon(Icons.refresh),
        color: Colors.lightBlue[400],
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          doinit();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notifications),
          color: Colors.lightBlue[400],
          onPressed: () {
            // 알림페이지로 push 설정
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: NotificationPage(
                  user: widget.user!,
                ),
              ),
            ).then((value) {
              setState(() {
                isLoading = true;
              });
              doinit();
            });
          },
        ),
      ],
    );
  }

  space_Chart() {
    List<Widget> items = [
      Container(
        color: Colors.lightBlue[400],
        child: index_circle.space_circle(
            index_current_pm10!, index_current_pm2p5!),
      ),
      Container(
        color: Colors.lightBlue[400],
        child: index_heat.space_heatmap(index_heat_pm10, index_heat_pm2p5),
      ),
      Container(
        color: Colors.lightBlue[400],
        child: index_chart.space_pmChart(index_pm10Spot, index_pm25Spot),
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
                height: 270,
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
              "${nowDate.year}-${nowDate.month}-${nowDate.day}",
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
          onPressed: () {
            showMaterialDatePicker(
              context: context,
              selectedDate: nowDate,
              firstDate: DateTime(2021),
              lastDate: DateTime.now(),
              onChanged: (value) => setState(
                () {
                  isLoading = true;
                  nowDate = value;
                  LoadChart('${nowDate.year}-${nowDate.month}-${nowDate.day}',
                      widget.user!.token);
                  getList = LoadDevice(
                      '${nowDate.year}-${nowDate.month}-${nowDate.day}',
                      widget.user!.token);
                  isLoading = false;
                },
              ),
            );
          },
        ),
      ],
    );
  }

  space_Devices() {
    Widget _buildItemWidget(DeviceItem deviceItem) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              SizedBox(height: 15),
              Text(
                deviceItem.name!,
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    // PM10
                    (deviceItem.avgpm10! > 0)
                        ? Expanded(
                            child: CircleChart(
                              progressColor:
                                  make_color('pm10', deviceItem.avgpm10),
                              progressNumber: (deviceItem.avgpm10! < 160)
                                  ? deviceItem.avgpm10!.roundToDouble()
                                  : 159.9,
                              maxNumber: 160,
                            ),
                          )
                        : Expanded(
                            child: Icon(
                              Icons.cloud_off,
                              color: Colors.lightBlue,
                            ),
                          ),

                    // PM2p5
                    (deviceItem.avgpm25! > 0)
                        ? Expanded(
                            child: CircleChart(
                              progressColor:
                                  make_color('pm2p5', deviceItem.avgpm25),
                              progressNumber: (deviceItem.avgpm25! < 80)
                                  ? deviceItem.avgpm25!.roundToDouble()
                                  : 79.9,
                              maxNumber: 80,
                            ),
                          )
                        : Expanded(
                            child: Icon(
                              Icons.cloud_off,
                              color: Colors.lightBlue,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
          onPressed: () {
            final device = Device(widget.user!.token, deviceItem.id!);
            Navigator.push(
              context,
              PageTransition(
                child: DetailPage(device: device),
                type: PageTransitionType.bottomToTop,
              ),
            ).then((value) {
              setState(() {
                isLoading = true;
              });
              doinit();
            });
          },
        ),
      );
    }

    return Expanded(
      child: isEmptyDevice
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<DeviceItem>>(
              future: getList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(5.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.2,
                      crossAxisCount: 2,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      DeviceItem deviceItem = snapshot.data![index];
                      return _buildItemWidget(deviceItem);
                    },
                  );
                } else
                  return ListView();
              },
            ),
    );
  }

  logout() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그아웃'),
          content: Text('로그아웃 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                // API 로그아웃
                var res = await http.post(
                  '$apiUrl/api/app/auth/logout/',
                  headers: <String, String>{
                    'Authorization': "Token ${widget.user!.token}"
                  },
                );

                if (res.statusCode == 200) {
                  final storage = new FlutterSecureStorage();
                  await storage.delete(key: "misecho_login");
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                } else {
                  Navigator.pop(context);
                }
              },
            )
          ],
        );
      },
    );
  }

  myFloatActionBtn() {
    TextEditingController _controller = TextEditingController();

    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.white),
      onPressed: () {
        bool _add_isLoading = false;
        // 다이알로그 팝업
        showDialog(
          context: context,
          barrierDismissible: !_add_isLoading,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('디바이스 추가하기', textAlign: TextAlign.center),
              content: (!_add_isLoading)
                  ? TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: "Device Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(width: 2),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(child: CircularProgressIndicator()),
                    ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              actions: <Widget>[
                (!_add_isLoading)
                    ? TextButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      )
                    : Container(),
                (!_add_isLoading)
                    ? TextButton(
                        child: Text('OK'),
                        onPressed: () async {
                          setState(() {
                            _add_isLoading = true;
                          });
                          // 디바이스 추가하기
                          var res = await http.post(
                            "$apiUrl/api/device/addDevice/",
                            headers: <String, String>{
                              'Content-Type': "application/json",
                              'Authorization': "Token ${widget.user!.token}"
                            },
                            body: jsonEncode({'device_name': _controller.text}),
                          );
                          setState(() {
                            _add_isLoading = false;
                          });

                          if (res.statusCode == 200) {
                            // 새로운 창
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("아래의 값으로 기기를 초기화해주세요.",
                                      textAlign: TextAlign.center),
                                  content: Text(
                                    res.body,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.lightBlue[400],
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        setState(() {
                                          isLoading = true;
                                        });
                                        doinit();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Navigator.pop(context);
                            // 새로운 창
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      Text("실패", textAlign: TextAlign.center),
                                  content: Text(
                                    "디바이스 추가를 실패하였습니다.\n${res.body}",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      )
                    : Container(),
              ],
            );
          },
        );
      },
    );
  }

  // 메인페이지 Chart 데이터 HTTP GET
  LoadChart(date, token) async {
    List<double> pmHour = [];
    List<double> pm10value = [];
    List<double> pm25value = [];

    var response = await http.get('$apiUrl/api/app/main/chart/$date/',
        headers: <String, String>{'Authorization': "Token $token"});

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      if (jsonList.isEmpty) {
        setState(() {
          index_pm10Spot.clear();
          index_pm25Spot.clear();
        });
      } else {
        // for 돌려서 리스트로 변환
        for (var i in jsonList) {
          pmHour.add(i['hour'].toDouble());
          pm10value.add(i['avgpm10']);
          pm25value.add(i['avgpm25']);
        }
        // 리스트를 FlSpot으로 변환
        setState(
          () {
            index_pm10Spot.clear();
            index_pm25Spot.clear();

            for (int i = 0; i < pmHour.length; i++) {
              index_pm10Spot
                  .add(FlSpot(pmHour[i], pm10value[i].roundToDouble()));
              index_pm25Spot
                  .add(FlSpot(pmHour[i], pm25value[i].roundToDouble()));
            }

            index_current_pm10 = pm10value[pm10value.length - 1];
            index_current_pm2p5 = pm25value[pm10value.length - 1];
          },
        );
      }
    } else {
      throw Exception('Faild to load Get');
    }
  }

  // HeatMap Chart 데이터 HTTP GET
  LoadHeatmapChart(token) async {
    List<DateTime> pmDateValue = [];
    List<int> pm10value = [];
    List<int> pm25value = [];
    var response = await http.get('$apiUrl/api/app/main/heatmap/',
        headers: <String, String>{'Authorization': "Token $token"});

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      if (jsonList.isEmpty) {
        setState(() {
          index_heat_pm10 = {};
          index_heat_pm2p5 = {};
        });
      } else {
        setState(() {
          for (var i in jsonList) {
            pmDateValue
                .add(TimeUtils.removeTime(DateTime.parse(i['datetime'])));
            pm10value.add(i['avgpm10'].toInt());
            pm25value.add(i['avgpm25'].toInt());
          }

          index_heat_pm10 = Map.fromIterables(pmDateValue, pm10value);
          index_heat_pm2p5 = Map.fromIterables(pmDateValue, pm25value);
        });
      }
    } else {
      throw Exception('Faild to load Get - Heatmap');
    }
  }

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
    return [];
  }

  // FCM 리스너
  void firebaseCloudMessaging_Listeners() async {
    // FCM 수신
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('log: Got a message whilst in the foreground!');
      print(
          'log: Message notification: ${message.notification!.title}, ${message.notification!.body}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message.notification!.body!),
      ));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('log: Got a message whilst in the background!');
      print(
          'log: Message notification: ${message.notification!.title}, ${message.notification!.body}');
    });
  }
}

// 메인페이지 디바이스 리스트 class
class DeviceItem {
  final int? id;
  final String? name;
  final bool? connect;
  final double? avgpm10;
  final double? avgpm25;

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
