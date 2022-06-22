import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/model/collection_model.dart';
import 'package:suzuki/model/question_model.dart';
import 'package:suzuki/model/question_types_model.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';

class AddQuestionViewModel extends ChangeNotifier {
  CircularLoaderController loadingController = CircularLoaderController();
  QuestionModel? questionModel;
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  TextEditingController hintController = TextEditingController();
  QuestionTypesModel? questionTypesModel;
  CollectionModel? collectionModel;

  List<QuestionTypesModel?> listQuestionType = [];

  bool isValidCode = true;
  bool isValidName = true;
  bool isValidLabel = true;
  bool isValidHint = true;
  bool isValidType = true;
  bool isValidCollection = true;

  void fill() {
    loadingController.startLoading();
    codeController.text = questionModel?.code ?? "";
    nameController.text = questionModel?.name ?? "";
    labelController.text = questionModel?.label ?? "";
    hintController.text = questionModel?.hint ?? "";
    questionTypesModel = QuestionTypesModel(
      code: questionModel?.type,
    );
    CollectionModel.list(
            token: System.data.global.token, id: questionModel?.collectionId)
        .then(
      (value) {
        loadingController.forceStop();
        collectionModel = value.first;
        commit();
      },
    ).catchError(
      (onError) {
        loadingController.stopLoading(
          isError: true,
          message: ErrorHandlingUtil.handleApiError(onError),
        );
      },
    );
    commit();
  }

  bool? validateCode() {
    if (codeController.text != "") {
      isValidCode = true;
      return null;
    } else {
      isValidCode = false;
      return false;
    }
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

  bool? validateLabel() {
    if (labelController.text != "") {
      isValidLabel = true;
      return null;
    } else {
      isValidLabel = false;
      return false;
    }
  }

  bool? validateHint() {
    if (hintController.text != "") {
      isValidHint = true;
      return null;
    } else {
      isValidHint = false;
      return false;
    }
  }

  bool? validateType() {
    if (questionTypesModel != null) {
      isValidType = true;
      return null;
    } else {
      isValidType = false;
      return false;
    }
  }

  bool? validateCollection() {
    if (collectionModel != null ||
        !QuestionTypes.needCollectionData(questionTypesModel?.code ?? "")) {
      isValidCollection = true;
      return null;
    } else {
      isValidCollection = false;
      return false;
    }
  }

  bool validate() {
    bool _valid = true;
    _valid = validateCode() ?? _valid;
    _valid = validateName() ?? _valid;
    _valid = validateLabel() ?? _valid;
    _valid = validateHint() ?? _valid;
    _valid = validateType() ?? _valid;
    _valid = validateCollection() ?? _valid;
    commit();
    return _valid;
  }

  void save() {
    if (!validate()) return;
    if (questionModel != null) {
      update();
    } else {
      add();
    }
  }

  void update() {
    loadingController.startLoading();
    QuestionModel.update(
      token: System.data.global.token,
      id: questionModel?.id,
      questionModel: QuestionModel(
        code: codeController.text,
        name: nameController.text,
        hint: hintController.text,
        label: labelController.text,
        type: questionTypesModel?.code,
        collectionId: collectionModel?.id,
      ),
    ).then((value) {
      loadingController.stopLoading(
        message: "Update Question Success",
        onCloseCallBack: () {},
        duration: const Duration(seconds: 2),
      );
    }).catchError((onError) {
      loadingController.stopLoading(
        message: ErrorHandlingUtil.handleApiError(onError),
        isError: true,
      );
    });
  }

  void add() {
    loadingController.startLoading();
    QuestionModel.add(
      token: System.data.global.token,
      questionModel: QuestionModel(
        code: codeController.text,
        name: nameController.text,
        hint: hintController.text,
        label: labelController.text,
        type: questionTypesModel?.code,
        collectionId: collectionModel?.id,
      ),
    ).then((value) {
      loadingController.stopLoading(
          message: "Add Question Success",
          onCloseCallBack: () {
            clear();
          },
          duration: const Duration(seconds: 2));
    }).catchError((onError) {
      loadingController.stopLoading(
        message: ErrorHandlingUtil.handleApiError(onError),
        isError: true,
      );
    });
  }

  void clear() {
    codeController.text = "";
    nameController.text = "";
    hintController.text = "";
    labelController.text = "";
    questionTypesModel = null;
    collectionModel = null;
    commit();
  }

  void commit() {
    notifyListeners();
  }
}
