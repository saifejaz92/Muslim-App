import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:quran_app/screens/Hadith/hadith_screen.dart';
import 'package:quran_app/utils/colors.dart';

// ignore: must_be_immutable
class HadithChapterScreen extends StatefulWidget {
  var bookName;
  HadithChapterScreen(this.bookName, {super.key});

  @override
  State<HadithChapterScreen> createState() => _HadithChapterScreenState();
}

class _HadithChapterScreenState extends State<HadithChapterScreen> {
  late Map rawDataMap = {};
  late List dataList = [];
  bool isLoading = true;
  getChapters() async {
    var bookName = widget.bookName;
    var apiKey =
        "\$2y\$10\$BylaBcXs5Lw7ZOtYmQ3PXO1x15zpp26oc1FeGktdmF6YeYoRd88e";
    var url = await http.get(Uri.parse(
        "https://hadithapi.com/api/$bookName/chapters?apiKey=$apiKey"));

    if (url.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      rawDataMap = jsonDecode(url.body);
      dataList = rawDataMap["chapters"];
      print(dataList);
    } else {
      Fluttertoast.showToast(msg: "Error Internet Required!");
    }
  }

  @override
  void initState() {
    super.initState();
    getChapters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBrown,
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor: darkBrown,
        title: Text(
          widget.bookName.toString(),
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: !isLoading
          ? ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                var chapNum = dataList[index]["chapterNumber"];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            HadithScreen(widget.bookName, chapNum),
                      ),
                    );
                  },
                  child: Card(
                    color: lightBrown,
                    child: ListTile(
                      leading: Text(
                        "${index + 1}",
                        style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      title: Text(
                        dataList[index]["chapterUrdu"].toString(),
                        style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: CircularProgressIndicator(
                color: whiteColor,
              ),
            ),
    );
  }
}
