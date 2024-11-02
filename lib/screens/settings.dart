// import 'package:flutter/material.dart';


// //widgets
// import 'package:demoparty_assistant/utils/widgets/navbar.dart';
// import 'package:demoparty_assistant/utils/widgets/table-cell.dart';

// import 'package:demoparty_assistant/utils/widgets/drawer.dart';

// class Settings extends StatefulWidget {
//   @override
//   _SettingsState createState() => _SettingsState();
// }

// class _SettingsState extends State<Settings> {
//   late bool switchValueOne;
//   late bool switchValueTwo;

//   void initState() {
//     setState(() {
//       switchValueOne = true;
//       switchValueTwo = false;
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: Navbar(
//           title: "Settings",
//         ),
//         drawer: AppDrawer(currentPage: "Settings"),
//         body: Container(
//             child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
//             child: Column(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text("Recommended Settings",
//                         style: TextStyle(
//                             color: AppColors.text,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18)),
//                   ),
//                 ),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text("These are the most important settings",
//                         style:
//                             TextStyle(color: AppColors.time, fontSize: 14)),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Use FaceID to signin",
//                         style: TextStyle(color: AppColors.text)),
//                     Switch.adaptive(
//                       value: switchValueOne,
//                       onChanged: (bool newValue) =>
//                           setState(() => switchValueOne = newValue),
//                       activeColor: AppColors.primary,
//                     )
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Auto-Lock security",
//                         style: TextStyle(color: AppColors.text)),
//                     Switch.adaptive(
//                       value: switchValueTwo,
//                       onChanged: (bool newValue) =>
//                           setState(() => switchValueTwo = newValue),
//                       activeColor: AppColors.primary,
//                     )
//                   ],
//                 ),
//                 TableCellSettings(
//                     title: "Notifications",
//                     onTap: () {
//                       Navigator.pushNamed(context, '/pro');
//                     }),
//                 SizedBox(height: 36.0),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 16.0),
//                     child: Text("Payment Settings",
//                         style: TextStyle(
//                             color: AppColors.text,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18)),
//                   ),
//                 ),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text("These are also important settings",
//                         style: TextStyle(color: AppColors.time)),
//                   ),
//                 ),
//                 TableCellSettings(title: "Manage Payment Options"),
//                 TableCellSettings(title: "Manage Gift Cards"),
//                 SizedBox(
//                   height: 36.0,
//                 ),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 16.0),
//                     child: Text("Privacy Settings",
//                         style: TextStyle(
//                             color: AppColors.text,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18)),
//                   ),
//                 ),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text("Third most important settings",
//                         style: TextStyle(color: AppColors.time)),
//                   ),
//                 ),
//                 TableCellSettings(
//                     title: "User Agreement",
//                     onTap: () {
//                       Navigator.pushNamed(context, '/pro');
//                     }),
//                 TableCellSettings(
//                     title: "Privacy",
//                     onTap: () {
//                       Navigator.pushNamed(context, '/pro');
//                     }),
//                 TableCellSettings(
//                     title: "About",
//                     onTap: () {
//                       Navigator.pushNamed(context, '/pro');
//                     }),
//               ],
//             ),
//           ),
//         )));
//   }
// }
