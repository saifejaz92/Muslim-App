import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;
import 'package:fluttertoast/fluttertoast.dart';

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

  Future<void> togglebutton() async {
    try {
      // ignore: await_only_futures
      final audiourl = await quran.getAudioURLBySurah(widget.surahIndex + 1);
      audioPlayer.setUrl(audiourl);

      if (isplaying) {
        await audioPlayer.play();

        setState(() {
          playpauseButton = Icons.pause_circle_rounded;
          isplaying = false;
        });
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
          title: Text(
            quran.getSurahName(widget.surahIndex + 1),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.brown[900]),
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
                      borderSide: const BorderSide(color: Colors.white)),
                  child: ListView.builder(
                    itemCount: quran.getVerseCount(widget.surahIndex + 1),
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white)),
                        child: ListTile(
                          title: Text(
                            quran.getVerse(widget.surahIndex + 1, index + 1,
                                verseEndSymbol: false),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 20, color: Colors.brown[600]),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.brown[900],
                            child: Text("${index + 1}",
                                style: const TextStyle(
                                  color: Colors.white,
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
                shadowColor: Colors.brown[900],
                child: Center(
                  child: IconButton(
                      icon: !isLoading
                          ? Icon(
                              playpauseButton,
                              color: Colors.brown[900],
                            )
                          : SizedBox(
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: Colors.brown[900],
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
