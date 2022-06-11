import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suzuki/util/colour.dart';
import 'package:suzuki/util/font.dart';
import 'package:suzuki/util/global.dart';
import 'package:suzuki/util/strings.dart';
import 'package:suzuki/util/text_style.dart';

class Data extends ChangeNotifier {
  Global global = Global();
  Map<String, Widget Function(BuildContext)>? route;
  String initialRouteName = "";
  Colour? color;
  Strings? strings;
  SharedPreferences? session;
  Font? font;
  TextStyles? textStyle = TextStyles();

  Data();

  Future<void> initialize() async {
    await _initSharedPreference();
  }

  Future<bool> _initSharedPreference() async {
    session = await SharedPreferences.getInstance();
    return true;
  }

  void commit() {
    notifyListeners();
  }
}
