import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/model/question_group_model.dart';
import 'package:suzuki/model/question_model.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';

class FormDesignerViewMOdel extends ChangeNotifier {
  CircularLoaderController loadingController = CircularLoaderController();
  ListDataComponentController<QuestionModel?> questionController =
      ListDataComponentController<QuestionModel?>();
  ListDataComponentController<QuestionGroupModel?> questionGroupController =
      ListDataComponentController<QuestionGroupModel?>();

  void deleteQuestion(QuestionModel? data) {
    loadingController.startLoading();
    QuestionModel.delete(
      token: System.data.global.token,
      id: data?.id,
    ).then(
      (value) {
        loadingController.stopLoading(
          message: "Delete Question Success",
          onCloseCallBack: () {
            questionController.refresh();
          },
        );
      },
    ).catchError((onError) {
      loadingController.stopLoading(
        message: ErrorHandlingUtil.handleApiError(onError),
        onCloseCallBack: () {
          questionController.refresh();
        },
      );
    });
  }

  void commit() {
    notifyListeners();
  }
}
