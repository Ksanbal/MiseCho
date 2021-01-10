import 'package:flutter/material.dart';

class NotiList {
  String date;
  String device;
  String context;

  NotiList(this.context);
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _items = <NotiList>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 20,
              child: ListView(
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: ListTile(
                      leading: Text('20.01.10\n14:49'),
                      title: Text('측정기 1'),
                      subtitle: Text('초미세먼지가 80을 초과했습니다.'),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemWidget(NotiList notiList) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: ListTile(
        leading: Text('20.01.10\n14:49'),
        title: Text('측정기 1'),
        subtitle: Text('초미세먼지가 80을 초과했습니다.'),
        onTap: () {},
      ),
    );
  }
}
