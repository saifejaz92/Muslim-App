// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class BookMarkScreen extends StatefulWidget {
//   String verseData;
//   BookMarkScreen(this.verseData, {super.key});

//   @override
//   State<BookMarkScreen> createState() => _BookMarkScreenState();
// }

// class _BookMarkScreenState extends State<BookMarkScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//           future: SharedPreferences.getInstance(),
//           builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
//             return ListTile(
//               title:
//                   Text((snapshot.data!.getString(widget.verseData).toString())),
//             );
//           }),
//     );
//   }
// }
