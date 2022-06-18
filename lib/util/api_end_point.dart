import 'package:suzuki/util/mode_util.dart';

class ApiEndPoint {
  String baseUrl = "https://form.bagdja.com/api/";
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

  String get url {
    if (ModeUtil.debugMode == true) {
      return baseUrlDebug;
    } else {
      return baseUrl;
    }
  }
}
