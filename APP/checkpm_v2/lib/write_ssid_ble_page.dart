// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'dart:convert';

// class WriteSSIDBLE extends StatefulWidget {
//   @override
//   _WriteSSIDBLEState createState() => _WriteSSIDBLEState();
// }

// class _WriteSSIDBLEState extends State<WriteSSIDBLE> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Find Devices")),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: StreamBuilder<List<ScanResult>>(
//           stream: FlutterBlue.instance.scanResults,
//           initialData: [],
//           builder: (c, snapshot) {
//             return ListView.builder(
//               itemCount: snapshot.data.length,
//               itemBuilder: (c, index) {
//                 if (snapshot.data[index].device.name != ' ') {
//                   return ListTile(
//                     title: Text(snapshot.data[index].device.name),
//                     subtitle: Text(snapshot.data[index].rssi.toString()),
//                     onTap: () {
//                       print(snapshot.data[index].device.name);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               Page2(device: snapshot.data[index].device),
//                         ),
//                       );
//                       // if(snapshot.data[index].device.state)
//                       // await snapshot.data[index].device.connect();
//                     },
//                   );
//                 }
//                 return null;
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: StreamBuilder<bool>(
//         stream: FlutterBlue.instance.isScanning,
//         initialData: false,
//         builder: (c, snapshot) {
//           if (snapshot.data) {
//             return FloatingActionButton(
//                 child: Icon(Icons.stop),
//                 onPressed: () => FlutterBlue.instance.stopScan());
//           } else {
//             return FloatingActionButton(
//               child: Icon(Icons.search),
//               onPressed: () => FlutterBlue.instance
//                   .startScan(timeout: Duration(seconds: 10)),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class Page2 extends StatefulWidget {
//   BluetoothDevice device;
//   Page2({@required this.device});

//   @override
//   _Page2State createState() => _Page2State();
// }

// class _Page2State extends State<Page2> {
//   final String SERVICE_UUID = "19b10000-e8f2-537e-4f6c-d104768a1214";
//   final String CHARACTERISTIC_UUID = "19B10000-E8F2-537E-4F6C-D104768A1214";
//   BluetoothCharacteristic targetCharacteristic;

//   TextEditingController ssid_c = TextEditingController();
//   TextEditingController pass_c = TextEditingController();

//   @override
//   void initState() {
//     print(widget.device);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.device.name),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // 연결버튼
//           TextButton(
//             child: Text("Connect"),
//             onPressed: () {
//               widget.device.connect();
//             },
//           ),
//           // ssid
//           TextFormField(controller: ssid_c),
//           // pass
//           TextFormField(controller: pass_c),
//           // send
//           TextButton(
//             child: Text("Send"),
//             onPressed: () async {
//               print("1 무야호");
//               List<BluetoothService> services =
//                   await widget.device.discoverServices();
//               services.forEach((service) {
//                 if (service.uuid.toString() ==
//                     "19b10000-e8f2-537e-4f6c-d104768a1214") {
//                   print("2 무야호");
//                   service.characteristics.forEach((c) {
//                     if (c.uuid.toString() ==
//                         "19b10001-e8f2-537e-4f6c-d104768a1214") {
//                       print("3 무야호");
//                       List<int> bytes = utf8.encode("openbus,openwifi");
//                       print(bytes);
//                       c.write(bytes);
//                     }
//                   });
//                 }
//               });
//             },
//           ),
//           // disconnect
//           TextButton(
//             child: Text("Disconnect"),
//             onPressed: () {
//               widget.device.disconnect();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
