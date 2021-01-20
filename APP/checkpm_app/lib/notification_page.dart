import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';
import 'detail_page.dart';

class NotificationPage extends StatefulWidget {
  final User user;
  NotificationPage({Key key, @required this.user}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Future<List<Item>> getList;

  @override
  void initState() {
    super.initState();
    getList = LoadNoti(widget.user.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 20,
              child: FutureBuilder<List<Item>>(
                future: getList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        Item item = snapshot.data[index];
                        return _buildItemWidget(item);
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

// 리스트 타일 생성 위젯
  Widget _buildItemWidget(Item item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: ListTile(
        leading: Text(item.date),
        title: Text(item.name),
        subtitle: Text(item.content),
        onTap: () {
          final device = Device(widget.user.token, item.dId);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(device: device)),
          );
        },
      ),
    );
  }
}

// 알림 리스트 페이지 HTTP GET
Future<List<Item>> LoadNoti(token) async {
  var response = await http.get('$apiUrl/api/app/notice/',
      headers: <String, String>{'Authorization': "Token $token"});
  if (response.statusCode == 200) {
    List jsonList = jsonDecode(utf8.decode(response.bodyBytes));
    var getList = jsonList.map((element) => Item.fromJson(element)).toList();
    return getList;
  } else {
    throw Exception('Faild to load Get');
  }
}

// 알림 리스트 객체
class Item {
  final int id;
  final String name;
  final String date;
  final String content;
  final int dId;
  final int cId;

  Item({this.id, this.name, this.date, this.content, this.dId, this.cId});

  factory Item.fromJson(Map<String, dynamic> json) {
    String date = json['date'];
    var year = date.substring(2, 4);
    var month = date.substring(5, 7);
    var day = date.substring(8, 10);
    var hour = date.substring(11, 13);
    var minute = date.substring(14, 16);
    date = '${year}.${month}.${day}\n${hour}:${minute}';

    return Item(
      id: json['id'],
      name: json['name'],
      date: date,
      content: json['content'],
      dId: json['d_id'],
      cId: json['c_id'],
    );
  }
}
