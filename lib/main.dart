import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suzuki/setting.dart';
import 'package:suzuki/util/data.dart';

Data data = Data();
void main() {
  setting();
  data.initialize().then((v) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: home(),
      ),
    );
  }
}

Widget home() {
  return ChangeNotifierProvider.value(
    value: data,
    builder: (c, w) {
      return MaterialApp(
        theme: ThemeData(),
        routes: data.route ?? const <String, WidgetBuilder>{},
        initialRoute: data.initialRouteName,
      );
    },
  );
}
