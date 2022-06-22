import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/model/page_model.dart';
import 'package:suzuki/model/page_question_model.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';

class FormEditorViewModel extends ChangeNotifier {
  CircularLoaderController loadingController = CircularLoaderController();
  ListDataComponentController<PageModel?>? listPageController =
      ListDataComponentController<PageModel?>();

  Map<String, ListDataComponentController<PageQuestionModel?>>
      pageQuestionControllers = {};

  void deletePage(BuildContext context, PageModel? data) {
    loadingController.startLoading();
    PageModel.delete(
      token: System.data.global.token,
      pageId: data?.id,
    ).then(
      (value) {
        loadingController.stopLoading(
            message: "Page has been deleted!",
            onCloseCallBack: () {
              listPageController?.refresh();
            },
            duration: const Duration(seconds: 2));
      },
    ).catchError((onError) {
      loadingController.stopLoading(
        message: ErrorHandlingUtil.handleApiError(onError),
        onCloseCallBack: () {
          listPageController?.refresh();
        },
      );
    });
  }

  void deleteQuestionOnPage(PageQuestionModel? data,
      ListDataComponentController<PageQuestionModel?>? controller) {
    loadingController.startLoading();
    PageQuestionModel.delete(
      token: System.data.global.token,
      pageId: data?.pageId,
      groupId: data?.groupId,
    ).then(
      (value) {
        loadingController.stopLoading(
          message: "Delete Question Group Success",
          onCloseCallBack: () {
            controller?.refresh();
          },
        );
      },
    ).catchError((onError) {
      loadingController.stopLoading(
        message: ErrorHandlingUtil.handleApiError(onError),
        onCloseCallBack: () {
          controller?.refresh();
        },
      );
    });
  }

  void updateQuestionOnPage({
    PageQuestionModel? data,
    ListDataComponentController<PageQuestionModel?>? controller,
    int? index,
  }) {
    var newData = PageQuestionModel.fromJson(data?.toJson() ?? {});
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
    PageQuestionModel? data,
    ListDataComponentController<PageQuestionModel?>? controller,
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
    PageQuestionModel.add(
      token: System.data.global.token,
      pageQUestionModel: data,
    ).then((value) {
      controller?.value.data.insert(index ?? 0, data);
      controller?.stopLoading();
    }).catchError(
      (onError) {
        controller?.stopLoading();
        loadingController.stopLoading(
          message: ErrorHandlingUtil.handleApiError(onError),
          onCloseCallBack: () {
            controller?.refresh();
          },
        );
      },
    );
  }

  void updateQuestionToQuestionGroup({
    PageQuestionModel? data,
    ListDataComponentController<PageQuestionModel?>? controller,
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
    PageQuestionModel.update(
      token: System.data.global.token,
      id: data?.pageId,
      groupId: data?.groupId,
      questionListModel: data,
    ).then((value) {
      controller?.value.data.removeWhere((e) => e?.groupId == data?.groupId);
      controller?.value.data.insert((index ?? 1) - 1, data);
      controller?.stopLoading();
    }).catchError(
      (onError) {
        controller?.stopLoading();
        loadingController.stopLoading(
          message: ErrorHandlingUtil.handleApiError(onError),
          onCloseCallBack: () {
            controller?.refresh();
          },
        );
      },
    );
  }
}
