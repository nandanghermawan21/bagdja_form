import 'package:suzuki/util/mode_util.dart';

class ApiEndPoint {
  String baseUrl = "https://apiform.bagdja.com/";
  String baseUrlDebug = "https://apiform.bagdja.com/";
  String loginUrl = "auth/login";

  //tag: question
  String questionListUrl = "question/list";
  String questionAddUrl = "question/add";
  String questionTypesUrl = "question/types";
  //end tag question

  String get url {
    if (ModeUtil.debugMode == true) {
      return baseUrlDebug;
    } else {
      return baseUrl;
    }
  }
}
