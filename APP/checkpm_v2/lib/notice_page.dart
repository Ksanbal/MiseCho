import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
      backgroundColor: Colors.white,
      appBar: space_AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            // AppBar
            space_ListView(),
          ],
        ),
      ),
    );
  }

  space_AppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.lightBlue[400],
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "Notice",
        style: TextStyle(
          fontSize: 20,
          color: Colors.lightBlue[400],
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          color: Colors.lightBlue[400],
          onPressed: () {
            setState(() {
              getList = LoadNoti(widget.user.token);
            });
          },
        ),
      ],
    );
  }

  space_ListView() {
    return Expanded(
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
    );
  }

// 리스트 타일 생성 위젯
  Widget _buildItemWidget(Item item) {
    return Dismissible(
      key: Key("${item.id}"),
      background: Card(
        color: Colors.lightBlue[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          deleteNotice(item.id, widget.user.token);
          getList = LoadNoti(widget.user.token);
        });
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('$item dismissed'),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: ListTile(
          leading: Text(item.date),
          title: Text(item.name),
          subtitle: Text(item.content),
          onTap: () {
            final device = Device(widget.user.token, item.dId);
            Navigator.push(
              context,
              PageTransition(
                child: DetailPage(device: device),
                type: PageTransitionType.bottomToTop,
              ),
            );
          },
        ),
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

// 알림 객체 삭제 HTTP DELETE
Future<http.Response> deleteNotice(int id, token) async {
  final http.Response response = await http.delete(
    '$apiUrl/api/app/notice_delete/$id/',
    headers: <String, String>{'Authorization': 'Token $token'},
  );
  return response;
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
