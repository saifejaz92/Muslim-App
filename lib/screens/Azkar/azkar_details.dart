import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AzkarDetails extends StatefulWidget {
  final Map id;
  AzkarDetails(this.id, {super.key});

  @override
  State<AzkarDetails> createState() => _AzkarDetailsState();
}

class _AzkarDetailsState extends State<AzkarDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id!["category"].toString(),
        ),
      ),
    );
  }
}
