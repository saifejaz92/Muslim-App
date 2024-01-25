import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/colors.dart';

// ignore: must_be_immutable
class SearchHadith extends StatefulWidget {
  var bookslug;
  SearchHadith(this.bookslug, {super.key});

  @override
  State<SearchHadith> createState() => _SearchHadithState();
}

class _SearchHadithState extends State<SearchHadith> {
  late Map rawDataMap = {};
  late List dataList = [];
  bool isLoading = true;
  List foundHadith = [];

  void getHadiths() async {
    var bookSlug = widget.bookslug;
    var apiKey =
        "\$2y\$10\$BylaBcXs5Lw7ZOtYmQ3PXO1x15zpp26oc1FeGktdmF6YeYoRd88e";
    var res = await http.get(Uri.parse(
        "https://hadithapi.com/public/api/hadiths?apiKey=$apiKey&book=$bookSlug&paginate=100000"));
    if (res.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      rawDataMap = jsonDecode(res.body);
      dataList = rawDataMap["hadiths"]["data"];
    }
  }

  void runFilter(String keyword) {
    List results = [];
    if (keyword.isEmpty) {
      results = dataList;
    } else {
      results = foundHadith
          .where((item) => item["hadithNumber"].contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundHadith = results;
    });
  }

  @override
  void initState() {
    super.initState();
    getHadiths();
    foundHadith = dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBrown,
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
            child: Column(
              children: [
                Text(
                  "Search Hadith with numbers",
                  style: TextStyle(color: whiteColor, fontSize: 20),
                ),
                Text(
                  "Have Patience! Loading may take sometime",
                  style: TextStyle(color: whiteColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(color: whiteColor),
            onChanged: (value) => runFilter(value),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(width: 2, color: Colors.white)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(width: 2, color: Colors.white)),
              labelText: "Search..",
              labelStyle: TextStyle(color: whiteColor),
              suffixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: !isLoading
                ? ListView.builder(
                    itemCount: foundHadith.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color(0XFFD9D9D9),
                        child: Column(
                          children: [
                            ListTile(
                                title: Text("Hadith Number #" +
                                    foundHadith[index]["hadithNumber"]
                                        .toString()),
                                trailing: Text("Status :" +
                                    foundHadith[index]["status"].toString())),
                            Card(
                              color: const Color(0XFFF2F2F2),
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    foundHadith[index]["hadithArabic"]
                                        .toString(),
                                    style: TextStyle(
                                        height: 2,
                                        fontSize: 22,
                                        color: darkBrown),
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
                                    foundHadith[index]["hadithUrdu"].toString(),
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
                                    foundHadith[index]["hadithEnglish"]
                                        .toString(),
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
          ),
        ),
      ]),
    );
  }
}
