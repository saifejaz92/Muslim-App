import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

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
        centerTitle: true,
        backgroundColor: Colors.brown[900],
        title: const Text("قرآن کریم"),
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
                      backgroundColor: Colors.brown[900],
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    trailing: Text(
                      "${quran.getVerseCount(index + 1)}",
                      style: TextStyle(
                        color: Colors.brown[900],
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
