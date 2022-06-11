import 'package:flutter/material.dart';
import 'package:suzuki/util/system.dart';

// ignore: use_key_in_widget_constructors
class UnderConstructionView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UnderConstructionViewState();
  }
}

class UnderConstructionViewState extends State<UnderConstructionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: System.data.color!.background,
      body: Center(
        child: Text(
          System.data.strings!.underConstruction,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
