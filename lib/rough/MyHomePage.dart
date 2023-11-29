// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 200.0,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text('Your Header', style: TextStyle(color: Colors.black)),
//               background: Image.network(
//                 'https://www.holidify.com/images/bgImages/KATHMANDU.jpg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SliverPersistentHeader(
//             pinned: true,
//             delegate: MyHeader(),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (BuildContext context, int index) {
//                 if (index == 0) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.blue,
//                     child: Center(child: Text('Your First Container')),
//                   );
//                 } else if (index == 1) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.green,
//                     child: Center(child: Text('Your Second Container')),
//                   );
//                 } else if (index == 2) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.orange,
//                     child: Center(child: Text('Your Third Container')),
//                   );
//                 } else if (index == 3) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.red,
//                     child: Center(child: Text('Your Fourth Container')),
//                   );
//                 } else if (index == 4) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.pink,
//                     child: Center(child: Text('Your Fifth Container')),
//                   );
//                 } else if (index == 5) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.green,
//                     child: Center(child: Text('Your Sixth Container')),
//                   );
//                 } else if (index == 6) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.amber,
//                     child: Center(child: Text('Your Seventh Container')),
//                   );
//                 } else if (index == 7) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.greenAccent,
//                     child: Center(child: Text('Your Eighth Container')),
//                   );
//                 } else if (index == 8) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.blue,
//                     child: Center(child: Text('Your Ninth Container')),
//                   );
//                 }
//                 return null;
//               },
//               childCount:
//                   9, // Incremented the childCount to account for the additional container
//             ),
//           ),
//           SliverPersistentHeader(
//             pinned: true,
//             delegate: MyHeader(),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (BuildContext context, int index) {
//                 if (index == 0) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.blue,
//                     child: Center(child: Text('Your First Container')),
//                   );
//                 } else if (index == 1) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.green,
//                     child: Center(child: Text('Your Second Container')),
//                   );
//                 } else if (index == 2) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.orange,
//                     child: Center(child: Text('Your Third Container')),
//                   );
//                 } else if (index == 3) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.red,
//                     child: Center(child: Text('Your Fourth Container')),
//                   );
//                 } else if (index == 4) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.pink,
//                     child: Center(child: Text('Your Fifth Container')),
//                   );
//                 } else if (index == 5) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.green,
//                     child: Center(child: Text('Your Sixth Container')),
//                   );
//                 } else if (index == 6) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.amber,
//                     child: Center(child: Text('Your Seventh Container')),
//                   );
//                 } else if (index == 7) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.greenAccent,
//                     child: Center(child: Text('Your Eighth Container')),
//                   );
//                 } else if (index == 8) {
//                   return Container(
//                     height: 150.0, // Adjust as needed
//                     color: Colors.blue,
//                     child: Center(child: Text('Your Ninth Container')),
//                   );
//                 }
//                 return null;
//               },
//               childCount:
//                   9, // Incremented the childCount to account for the additional container
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
