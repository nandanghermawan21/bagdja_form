import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/model/question_group_model.dart';
import 'package:suzuki/model/question_list_model.dart';
import 'package:suzuki/model/question_model.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';

class FormDesignerViewMOdel extends ChangeNotifier {
  CircularLoaderController loadingController = CircularLoaderController();
  ListDataComponentController<QuestionModel?> questionController =
      ListDataComponentController<QuestionModel?>();
  ListDataComponentController<QuestionGroupModel?> questionGroupController =
      ListDataComponentController<QuestionGroupModel?>();
  Map<String, ListDataComponentController<QuestionListModel?>>
      questionListOfGroup = {};

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

  void deleteQuestionFromQuestionGroup(QuestionListModel? data) {
    loadingController.startLoading();
    QuestionListModel.delete(
            token: System.data.global.token,
            id: data?.groupId,
            questionId: data?.questionId)
        .then(
      (value) {
        loadingController.stopLoading(
          message: "Delete Question Success",
          onCloseCallBack: () {
            questionListOfGroup["${data?.groupId}"]?.refresh();
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

  void updateQuestionOnQuestionGroup({
    QuestionListModel? data,
    ListDataComponentController<QuestionListModel?>? controller,
    int? index,
  }) {
    var newData = QuestionListModel.fromJson(data?.toJson() ?? {});
    if (data?.order == -1) {
      addQuestionToQuestionGroup(
        data: newData,
        controller: controller,
        index: index,
      );
    } else {
      updateQuestionToQuestionGroup(
        data: newData,
        controller: controller,
        index: index,
      );
    }
  }

  void addQuestionToQuestionGroup({
    QuestionListModel? data,
    ListDataComponentController<QuestionListModel?>? controller,
    int? index,
  }) {
    if (index == 0) {
      data?.order = 0;
    } else if ((index ?? 0) > (controller?.value.data.length ?? 0) - 1) {
      data?.order = (controller?.value.data[(index ?? 1) - 1]?.order ?? 0) + 1;
    } else {
      data?.order = (controller?.value.data[index ?? 0]?.order ?? 0);
    }

    controller?.startLoading();
    QuestionListModel.add(
      token: System.data.global.token,
      questionListModel: data,
    ).then((value) {
      controller?.value.data.insert(index ?? 0, data);
      controller?.stopLoading();
    }).catchError(
      (onError) {
        controller?.stopLoading();
        loadingController.stopLoading(
          message: ErrorHandlingUtil.handleApiError(onError),
          onCloseCallBack: () {
            questionController.refresh();
          },
        );
      },
    );
  }

  void updateQuestionToQuestionGroup({
    QuestionListModel? data,
    ListDataComponentController<QuestionListModel?>? controller,
    int? index,
  }) {
    if (index == 0) {
      data?.order = 0;
    } else if ((index ?? 0) > (controller?.value.data.length ?? 0) - 1) {
      data?.order = (controller?.value.data[(index ?? 1) - 1]?.order ?? 0) + 1;
    } else {
      data?.order = (controller?.value.data[index ?? 0]?.order ?? 0);
    }
    controller?.startLoading();
    QuestionListModel.update(
      token: System.data.global.token,
      id: data?.groupId,
      questionId: data?.questionId,
      questionListModel: data,
    ).then((value) {
      controller?.value.data
          .removeWhere((e) => e?.questionId == data?.questionId);
      controller?.value.data.insert((index ?? 1) - 1, data);
      controller?.stopLoading();
    }).catchError(
      (onError) {
        controller?.stopLoading();
        loadingController.stopLoading(
          message: ErrorHandlingUtil.handleApiError(onError),
          onCloseCallBack: () {
            questionController.refresh();
          },
        );
      },
    );
  }

  void commit() {
    notifyListeners();
  }
}
