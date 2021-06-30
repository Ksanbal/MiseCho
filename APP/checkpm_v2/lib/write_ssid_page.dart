// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'dart:convert';

// class WriteSSIDPage extends StatefulWidget {
//   @override
//   _WriteSSIDPageState createState() => _WriteSSIDPageState();
// }

// class _WriteSSIDPageState extends State<WriteSSIDPage> {
//   TextEditingController ssid_Controller = TextEditingController();
//   TextEditingController pass_Controller = TextEditingController();

//   bool isLoading = true;
//   bool isExitSD = false;
//   bool isExitTxt = false;
//   Directory mySD;

//   @override
//   void initState() {
//     // SD카드 유무 확인
//     doinit();
//     super.initState();
//   }

//   doinit() async {
//     requestStoragePermissions();
//     mySD = await getExternalSdCardPath();
//     await readTXT(mySD);
//   }

//   void requestStoragePermissions() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       print("Not Granted!");
//       Map<Permission, PermissionStatus> statuses = await [
//         Permission.storage,
//       ].request();
//       print(statuses[Permission.storage]);
//     }
//   }

//   @override
//   void dispose() {
//     ssid_Controller.dispose();
//     pass_Controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: myAppBar(),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.only(top: 50, left: 30, right: 30),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Info TextField
//             check_SD_text(),
//             SizedBox(height: 50),

//             space_ssid(),
//             SizedBox(height: 20),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: space_writeBtn(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   myAppBar() {
//     return AppBar(
//       iconTheme: IconThemeData(color: Colors.lightBlue[400]),
//       title: Text(
//         "WiFi 정보 입력",
//         style: TextStyle(
//           color: Colors.lightBlue[400],
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.refresh),
//           onPressed: () async {
//             setState(() {
//               isLoading = true;
//             });
//             mySD = await getExternalSdCardPath();
//             await readTXT(mySD);
//           },
//         ),
//       ],
//       backgroundColor: Colors.white,
//     );
//   }

//   check_SD_text() {
//     return Row(
//       children: [
//         Text(
//           "SD카드 인식",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[600],
//           ),
//         ),
//         SizedBox(width: 20),
//         isLoading
//             ? SizedBox(
//                 width: 15,
//                 height: 15,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 3.0,
//                   valueColor:
//                       AlwaysStoppedAnimation<Color>(Colors.lightBlue[400]),
//                 ),
//               )
//             : isExitSD
//                 ? Icon(Icons.check_circle_outline, color: Colors.green)
//                 : Icon(Icons.sd_card_alert_outlined, color: Colors.red),
//       ],
//     );
//   }

//   space_ssid() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               "WiFi 정보를 입력해주세요!",
//               textAlign: TextAlign.left,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),

//           // ID TextField
//           TextField(
//             controller: ssid_Controller,
//             readOnly: !isExitSD,
//             decoration: InputDecoration(
//               labelText: 'WiFi SSID',
//               hintText: !isExitSD ? 'sd카드가 없어서 입력할 수 없습니다.' : '',
//             ),
//           ),
//           // Password TextField
//           TextField(
//             controller: pass_Controller,
//             readOnly: !isExitSD,
//             decoration: InputDecoration(
//               labelText: 'Password',
//               hintText: !isExitSD ? 'sd카드가 없어서 입력할 수 없습니다.' : '',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   space_writeBtn() {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         primary: Colors.lightBlue[400],
//         padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
//       ),
//       child: Text(
//         "저장하기",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       onPressed: () async {
//         // SD카드에 값 저장하기
//         await writeTXT(mySD, ssid_Controller.text, pass_Controller.text);
//       },
//     );
//   }

//   // SD카드 경로 얻기
//   Future<Directory> getExternalSdCardPath() async {
//     try {
//       List<Directory> extDirectories = await getExternalStorageDirectories();

//       List<String> dirs = extDirectories[1].toString().split('/');
//       String rebuiltPath = '/' + dirs[1] + '/' + dirs[2];
//       print("rebuild path : " + rebuiltPath);
//       setState(() {
//         isLoading = false;
//         isExitSD = true;
//       });
//       return new Directory(rebuiltPath);
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         isExitSD = false;
//       });
//     }
//   }

//   Future<void> readTXT(Directory _dir) async {
//     try {
//       final _myFile = File('${_dir.path}/Documents/misecho/ssid.txt');
//       final _data = await _myFile.readAsString(encoding: utf8);
//       print("Read txt");
//       print(_data);
//       _data.indexOf(',');
//       var split_data = _data.split(",");

//       setState(() {
//         isExitTxt = true;
//         ssid_Controller.text = split_data[0];
//         pass_Controller.text = split_data[1];
//       });
//     } catch (e) {
//       print("Not found txt, $e");
//       setState(() {
//         isExitTxt = false;
//       });
//     }
//   }

//   Future<void> writeTXT(Directory _dir, ssid, pass) async {
//     try {
//       if (!isExitTxt) {
//         Directory('${_dir.path}/Documents/misecho').create();
//       }
//       final _myFile = File('${_dir.path}/Documents/misecho/ssid.txt');
//       await _myFile.writeAsString('$ssid,$pass');
//     } catch (e) {
//       print("Faild to write TXT, $e");
//       setState(() {
//         isExitTxt = false;
//       });
//     }
//   }
// }
