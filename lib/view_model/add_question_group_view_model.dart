import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/model/question_group_model.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';

class AddQuestionGroupViewModel extends ChangeNotifier {
  CircularLoaderController loadingController = CircularLoaderController();
  QuestionGroupModel? questionGroupModel;
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool isValidCode = true;
  bool isValidName = true;

  void fill() {
    codeController.text = questionGroupModel?.code ?? "";
    nameController.text = questionGroupModel?.name ?? "";
  }

  void clear() {
    codeController.text = "";
    nameController.text = "";
  }

  bool? validateName() {
    if (nameController.text != "") {
      isValidName = true;
      return null;
    } else {
      isValidName = false;
      return false;
    }
  }

  bool? validateCode() {
    if (nameController.text != "") {
      isValidName = true;
      return null;
    } else {
      isValidName = false;
      return false;
    }
  }

  bool validate() {
    bool _valid = true;
    _valid = validateCode() ?? _valid;
    _valid = validateName() ?? _valid;
    commit();
    return _valid;
  }

  void save() {
    if (!validate()) return;
    if (questionGroupModel != null) {
      update();
    } else {
      add();
    }
  }

  void update() {
    loadingController.startLoading();
    QuestionGroupModel.update(
      token: System.data.global.token,
      id: questionGroupModel?.id,
      questionGroupModel: QuestionGroupModel(
        code: codeController.text,
        name: nameController.text,
      ),
    ).then((value) {
      loadingController.stopLoading(
          message: "Create Collection Success", onCloseCallBack: () {});
    }).catchError((onError) {
      loadingController.stopLoading(
        message: ErrorHandlingUtil.handleApiError(onError),
        isError: true,
      );
    });
  }

  void add() {
    loadingController.startLoading();
    QuestionGroupModel.create(
      token: System.data.global.token,
      questionGroupModel: QuestionGroupModel(
        code: codeController.text,
        name: nameController.text,
      ),
    ).then((value) {
      loadingController.stopLoading(
          message: "Create Collection Success",
          onCloseCallBack: () {
            clear();
          });
    }).catchError((onError) {
      loadingController.stopLoading(
        message: ErrorHandlingUtil.handleApiError(onError),
        isError: true,
      );
    });
  }

  void commit() {
    notifyListeners();
  }
}
