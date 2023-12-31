import 'package:flutter/material.dart';
import 'package:quran_app/screens/Azkar/azkar_data.dart';
import '../../utils/colors.dart';

class ListOfAzkar extends StatefulWidget {
  const ListOfAzkar({super.key});

  @override
  State<ListOfAzkar> createState() => _ListOfAzkarState();
}

class _ListOfAzkarState extends State<ListOfAzkar> {
  var categoriesOfAzkar = [
    "أذكار الصباح",
    "أذكار المساء",
    "أذكار بعد السلام من الصلاة المفروضة",
    "تسابيح",
    "أذكار النوم",
    "أذكار الاستيقاظ",
    "أدعية قرآنية",
    "أدعية الأنبياء",
  ];
  List selectedCategory = [];
  @override
  Widget build(BuildContext context) {
    final filteredProduct = azkar.where(
      (element) {
        return selectedCategory.isEmpty ||
            selectedCategory.contains(element["category"]);
      },
    ).toList();
    return Scaffold(
      backgroundColor: darkBrown,
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        title: Text(
          "ازکار",
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: darkBrown,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, top: 05),
            alignment: Alignment.centerLeft,
            child: Text(
              "Categories",
              style: TextStyle(
                decorationColor: whiteColor,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid,
                color: whiteColor,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: categoriesOfAzkar
                    .map(
                      (category) => FilterChip(
                          side: const BorderSide(
                              width: 1, style: BorderStyle.solid),
                          backgroundColor: Colors.white,
                          selectedColor: lightBrown,
                          selected: selectedCategory.contains(category),
                          label: Text(category),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedCategory.add(category);
                              } else {
                                selectedCategory.remove(category);
                              }
                            });
                          }),
                    )
                    .toList(),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: filteredProduct.length,
                  itemBuilder: (context, index) {
                    final finalAzkars = filteredProduct[index];
                    return Card(
                      color: const Color(0XFFD9D9D9),
                      child: Column(
                        children: [
                          ListTile(
                            title: CircleAvatar(
                                backgroundColor: whiteColor,
                                child: Text("${index + 1}")),
                            leading: Text(
                              "Recite: ${finalAzkars["count"].toString()} time",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: darkBrown),
                            ),
                            trailing: SizedBox(
                              width: 130,
                              child: Text(
                                finalAzkars["category"].toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: darkBrown),
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
                                  finalAzkars["content"].toString(),
                                  style: TextStyle(
                                      height: 2,
                                      fontSize: 22,
                                      color: darkBrown),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
