import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
      print(data);
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
      backgroundColor: Colors.brown[900],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "حدیث شریف",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.brown[900],
      ),
      body: SafeArea(
        child: !isLoading
            ? ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.brown[500],
                    child: ListTile(
                      leading: Text(
                        "${index + 1}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      title: Text(
                        data[index]["bookName"].toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Chapters: ${data[index]["chapters_count"].toString()}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Total Hafdiths: ${data[index]["hadiths_count"].toString()}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
