import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/model/page_model.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';

class AddPageViewModel extends ChangeNotifier {
  CircularLoaderController loadingController = CircularLoaderController();
  TextEditingController nameController = TextEditingController();
  PageModel? order;

  bool isValidName = true;
  bool isValidOrder = true;

  void savePage(BuildContext context, PageModel page) {
    if (page.id != null) {
      updatePage(context, page);
    } else {
      addNewPage(context, page);
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

  bool validate() {
    bool _valid = true;
    _valid = validateName() ?? _valid;
    commit();
    return _valid;
  }

  void updatePage(BuildContext context, PageModel page) {
    if (!validate()) return;
    page.name = nameController.text;
    page.order = order?.order ?? 1;
    loadingController.startLoading();
    PageModel.update(
      token: System.data.global.token,
      id: page.id,
      pageModel: page,
    ).then((value) {
      loadingController.stopLoading(
        message: "Update Page Success",
        onCloseCallBack: () {
          Navigator.of(context).pop();
        },
        duration: const Duration(
          seconds: 2,
        ),
      );
    }).catchError((onError) {
      loadingController.stopLoading(
        message: ErrorHandlingUtil.handleApiError(onError),
        isError: true,
      );
    });
  }

  void addNewPage(BuildContext context, PageModel page) {
    if (!validate()) return;
    page.name = nameController.text;
    page.order = order?.order ?? page.order;
    loadingController.startLoading();
    PageModel.add(
      token: System.data.global.token,
      pageModel: page,
    ).then((value) {
      loadingController.stopLoading(
          message: "Add new page Success",
          onCloseCallBack: () {
            Navigator.of(context).pop();
          },
          duration: const Duration(seconds: 2));
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
