import 'package:flutter/material.dart';
import 'package:quran/surah_data.dart';
import 'package:quran_app/utils/ads.dart';
import '../../utils/colors.dart';
import 'surah_page.dart';

class SurahScreen extends StatefulWidget {
  SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  List foundSurah = [];

  @override
  void initState() {
    super.initState();
    foundSurah = surah;
  }

  void runFilter(String keyword) {
    List results = [];
    if (keyword.isEmpty) {
      results = surah;
    } else {
      results = foundSurah
          .where((item) =>
              item["name"].toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundSurah = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: whiteColor),
          centerTitle: true,
          backgroundColor: darkBrown,
          title: Text(
            "قرآن کریم",
            style: TextStyle(color: whiteColor),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => runFilter(value),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(width: 2)),
                  labelText: "Search..",
                  suffixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: foundSurah.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Card(
                            elevation: 3,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SurahPage(
                                            foundSurah[index]["id"])));
                              },
                              title: Text(
                                foundSurah[index]["name"].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  "Surah Name(English): ${foundSurah[index]["english"].toString()}"),
                              leading: CircleAvatar(
                                backgroundColor: darkBrown,
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(color: whiteColor),
                                ),
                              ),
                              trailing: Text(
                                foundSurah[index]["aya"].toString(),
                                style: TextStyle(
                                  color: darkBrown,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const SizedBox(
          height: 50,
          child: AdsScreen(),
        ));
  }
}
