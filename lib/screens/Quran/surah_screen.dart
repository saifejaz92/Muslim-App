import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import '../../utils/colors.dart';
import 'surah_page.dart';

class SurahScreen extends StatefulWidget {
  const SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
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
      body: ListView.builder(
          itemCount: quran.totalSurahCount,
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
                              builder: (context) => SurahPage(index)));
                    },
                    title: Text(
                      quran.getSurahNameArabic(index + 1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Surah Name(English): ${quran.getSurahNameEnglish(index + 1)}"),
                    leading: CircleAvatar(
                      backgroundColor: darkBrown,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(color: whiteColor),
                      ),
                    ),
                    trailing: Text(
                      "${quran.getVerseCount(index + 1)}",
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
    );
  }
}
