import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/model/question_list_model.dart';
import 'package:suzuki/model/question_model.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';

class AddQuestionItemViewModel extends ChangeNotifier {
  CircularLoaderController loadingController = CircularLoaderController();
  QuestionListModel? questionListModel;
  QuestionModel? selectedQuestionModel;

  void save() {
    loadingController.startLoading();
    QuestionListModel.update(
      token: System.data.global.token,
      id: questionListModel?.groupId,
      questionId: questionListModel?.questionId,
      questionListModel: questionListModel,
    ).then(
      (value) {
        loadingController.stopLoading(
          message: "Update Success",
          duration: const Duration(seconds: 2),
        );
      },
    ).catchError((onError) {
      loadingController.stopLoading(
        isError: true,
        message: ErrorHandlingUtil.handleApiError(onError),
      );
    });
  }

  void commit() {
    notifyListeners();
  }
}
