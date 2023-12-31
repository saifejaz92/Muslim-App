import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/colors.dart';

// ignore: must_be_immutable
class SurahPage extends StatefulWidget {
  int surahIndex;
  SurahPage(this.surahIndex, {super.key});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  AudioPlayer audioPlayer = AudioPlayer();
  IconData playpauseButton = Icons.play_circle_fill_rounded;
  bool isplaying = true;
  bool isLoading = false;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void isPlay() async {
    setState(() {
      isplaying = false;
    });
  }

  Future<void> togglebutton() async {
    try {
      // ignore: await_only_futures
      final audiourl = await quran.getAudioURLBySurah(widget.surahIndex + 1);
      audioPlayer.setUrl(audiourl);

      if (isplaying) {
        await audioPlayer.play();
        audioPlayer.play().whenComplete(isPlay);
        setState(() {
          playpauseButton = Icons.pause_circle_rounded;
          isplaying = false;
        });
        // ignore: unrelated_type_equality_checks
      } else if (audioPlayer.pause() == true) {
        await audioPlayer.load();
      } else {
        audioPlayer.pause();
        setState(() {
          playpauseButton = Icons.play_circle_fill_rounded;
          isplaying = true;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: whiteColor),
          title: Text(
            quran.getSurahName(widget.surahIndex + 1),
            style: TextStyle(color: whiteColor),
          ),
          backgroundColor: darkBrown),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                child: Card(
                  margin: const EdgeInsets.all(10),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: whiteColor!)),
                  child: ListView.builder(
                    itemCount: quran.getVerseCount(widget.surahIndex + 1),
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: whiteColor!)),
                        child: ListTile(
                          title: Text(
                            quran.getVerse(widget.surahIndex + 1, index + 1,
                                verseEndSymbol: false),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 20, color: Colors.brown[600]),
                          ),
                          subtitle: Column(
                            children: [
                              const Divider(),
                              Text(
                                quran.getVerseTranslation(
                                    widget.surahIndex + 1, index + 1),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          leading: CircleAvatar(
                            backgroundColor: darkBrown,
                            child: Text("${index + 1}",
                                style: TextStyle(
                                  color: whiteColor,
                                )),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Card(
                elevation: 6,
                shadowColor: darkBrown,
                child: Center(
                  child: IconButton(
                      icon: !isLoading
                          ? Icon(
                              playpauseButton,
                              color: darkBrown,
                            )
                          : SizedBox(
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: darkBrown,
                              ),
                            ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await togglebutton();
                        setState(() {
                          isLoading = false;
                        });
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
