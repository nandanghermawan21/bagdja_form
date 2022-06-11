import 'package:suzuki/recource/color_default.dart';
import 'package:suzuki/recource/strings_en_us.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/recource/font_default.dart';
import 'package:suzuki/route.dart' as route;

void setting() {
  System.data.route = route.route;
  System.data.initialRouteName = route.initialRouteName;
  System.data.color = ColorDefault();
  System.data.strings = StringsEnUs();
  System.data.font = FontDefault();
}
