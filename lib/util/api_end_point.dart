import 'package:suzuki/util/mode_util.dart';

class ApiEndPoint {
  String baseUrl = "https://form.bagdja.com/api//";
  String baseUrlDebug = "https://form.bagdja.com/api//";
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
