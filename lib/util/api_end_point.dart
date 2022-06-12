import 'package:suzuki/util/mode_util.dart';

class ApiEndPoint {
  String baseUrl = "https://apiform.bagdja.com/";
  String baseUrlDebug = "https://apiform.bagdja.com/";
  String loginUrl = "auth/login";

  String get url {
    if (ModeUtil.debugMode == true) {
      return baseUrlDebug;
    } else {
      return baseUrl;
    }
  }
}
