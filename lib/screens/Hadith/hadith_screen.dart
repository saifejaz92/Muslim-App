import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/colors.dart';

// ignore: must_be_immutable
class HadithScreen extends StatefulWidget {
  var bookslug;
  var chapNum;
  HadithScreen(this.bookslug, this.chapNum, {super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  late Map rawDataMap = {};
  late List dataList = [];
  bool isLoading = true;
  void getHadiths() async {
    var bookSlug = widget.bookslug;
    var chapNum = widget.chapNum;
    var apiKey =
        "\$2y\$10\$BylaBcXs5Lw7ZOtYmQ3PXO1x15zpp26oc1FeGktdmF6YeYoRd88e";
    var res = await http.get(Uri.parse(
        "https://hadithapi.com/public/api/hadiths?apiKey=$apiKey&book=$bookSlug&chapter=$chapNum&paginate=100000"));
    if (res.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      rawDataMap = jsonDecode(res.body);
      dataList = rawDataMap["hadiths"]["data"];
    }
  }

  @override
  void initState() {
    super.initState();
    getHadiths();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBrown,
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor: darkBrown,
        title: Text(
          widget.bookslug.toString(),
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: !isLoading
          ? ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0XFFD9D9D9),
                  child: Column(
                    children: [
                      ListTile(
                          title: Text("Hadith Number #" +
                              dataList[index]["hadithNumber"].toString()),
                          trailing: Text("Status :" +
                              dataList[index]["status"].toString())),
                      Card(
                        color: Color(0XFFF2F2F2),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              dataList[index]["hadithArabic"].toString(),
                              style: TextStyle(
                                  height: 2, fontSize: 22, color: darkBrown),
                              textAlign: TextAlign.justify,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: const Color(0XFFF2F2F2),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              dataList[index]["hadithUrdu"].toString(),
                              style: const TextStyle(
                                height: 2,
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.justify,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: const Color(0XFFF2F2F2),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              dataList[index]["hadithEnglish"].toString(),
                              style: const TextStyle(
                                height: 2,
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.justify,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ),
                      ),
                    ],
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
