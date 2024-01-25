import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quran_app/utils/ads.dart';

import '../../utils/colors.dart';
import 'hadith_chapters_screen.dart';

class HadithBookScreen extends StatefulWidget {
  const HadithBookScreen({super.key});

  @override
  State<HadithBookScreen> createState() => _HadithBookScreenState();
}

class _HadithBookScreenState extends State<HadithBookScreen> {
  late Map rawData = {};
  late List data = [];
  bool isLoading = true;
  getBooks() async {
    var apiKey =
        "\$2y\$10\$BylaBcXs5Lw7ZOtYmQ3PXO1x15zpp26oc1FeGktdmF6YeYoRd88e";
    var res = await http
        .get(Uri.parse("https://hadithapi.com/api/books?apiKey=$apiKey"));

    if (res.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      rawData = jsonDecode(res.body);
      data = rawData["books"];
    } else {
      Fluttertoast.showToast(msg: "Error Internet Required!");
    }
  }

  @override
  void initState() {
    super.initState();
    getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBrown,
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        title: Text(
          "حدیث شریف",
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: darkBrown,
      ),
      body: SafeArea(
        child: !isLoading
            ? ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var bookSlug = data[index]["bookSlug"];
                  return Card(
                    color: lightBrown,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HadithChapterScreen(bookSlug),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Text(
                          "${index + 1}",
                          style: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        title: Text(
                          data[index]["bookName"].toString(),
                          style: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 26),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Chapters: ${data[index]["chapters_count"].toString()}",
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            Text(
                              "Total Hafdiths: ${data[index]["hadiths_count"].toString()}",
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: CircularProgressIndicator(
                color: whiteColor,
              )),
      ),
      bottomNavigationBar: const SizedBox(
        height: 50,
        child: AdsScreen(),
      ),
    );
  }
}
