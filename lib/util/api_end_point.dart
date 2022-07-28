// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:suzuki/util/mode_util.dart';

class ApiEndPoint {
  String baseUrl = "/survey/api/";
  String baseUrlDebug = "https://form.bagdja.com/api/";
  String loginUrl = "auth/login";

  //tag: question
  String questionListUrl = "question/list";
  String questionAddUrl = "question/add";
  String questionTypesUrl = "question/types";
  String questionUpdateUrl = "/question/update";
  String questionDeleteUrl = "/question/delete";
  //end tag question

  //collection
  String collectionListUrl = "collection/list";
  String collectioCreateUrl = "collection/create";
  String collectioDeleteUrl = "collection/delete";
  String collectionupdateUrl = "collection/update";
  String collectionDataUrl = "collection/data";
  String collectionAddDataUrl = "collection/addData";
  String collectionUpdateDataUrl = "collection/updateData";
  String collectionDeleteDataUrl = "collection/deleteData";
  //collection

  //questiongroup
  String questionGroupListUrl = "questiongroup/list";
  String questionGroupCreateUrl = "questiongroup/create";
  String questionGroupUpdateUrl = "questiongroup/update";
  String questionGroupDeleteUrl = "questiongroup/delete";
  String questionGroupDataUrl = "questiongroup/data";
  String questionGroupAddDataUrl = "questiongroup/addData";
  String questionGroupUpdateDataUrl = "questiongroup/updateData";
  String questionGroupDeleteDataUrl = "questiongroup/deleteData";
  //questiongroup

  //form
  String formOfApplications = "form/application";
  String formPages = "/form/pages";
  //form

  //page
  String pageCreate = "page/create";
  String pageUpdate = "page/update";
  String pageDelete = "page/delete";
  String pageQuestions = "page/questions";
  String pageAddQuestion = "page/addQuestion";
  String pageUpdateQuestion = "page/updateQuestion";
  String pageDeleteQuestion = "page/deleteQuestion";
  String pageDicission = "page/dicission";
  String pageDicissionSummary = "page/dicissionSummary";
  String pageAddDicission = "page/addDicission";
  String pageUpdateDicission = "page/updateDicission";
  String pageDeleteDicission = "page/deleteDicission";
  //page

  //dicission
  String dicissionTypes = "dicission/types";
  //dicission

  String get url {
    var _url = window.location.host;
    if (ModeUtil.debugMode == true) {
      return baseUrlDebug;
    } else {
      return _url + baseUrl;
    }
  }
}
