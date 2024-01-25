import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:quran_app/screens/Hadith/hadith_screen.dart';
import 'package:quran_app/screens/Hadith/search_hadith.dart';
import 'package:quran_app/utils/ads.dart';
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
  List foundHadith = [];

  @override
  void initState() {
    super.initState();
    getChapters();
    foundHadith = dataList;
  }

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
    } else {
      Fluttertoast.showToast(msg: "Error Internet Required!");
    }
  }

  void runFilter(String keyword) {
    List results = [];
    if (keyword.isEmpty) {
      results = dataList;
    } else {
      results = foundHadith
          .where(
              (item) => item["chapterEnglish"].contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundHadith = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: darkBrown,
        appBar: AppBar(
          iconTheme: IconThemeData(color: whiteColor),
          backgroundColor: darkBrown,
          title: Text(
            widget.bookName.toString(),
            style: TextStyle(color: whiteColor),
          ),
          bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              tabs: [
                Tab(
                  text: "Hadith Chapters",
                  icon: Icon(FlutterIslamicIcons.mohammad),
                ),
                Tab(
                  text: "Search Hadith",
                  icon: Icon(Icons.search),
                ),
              ]),
        ),
        body: TabBarView(children: [
          !isLoading
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
          SizedBox(
            child: SearchHadith(widget.bookName),
          )
        ]),
        bottomNavigationBar: const SizedBox(
          height: 50,
          child: AdsScreen(),
        ),
      ),
    );
  }
}
