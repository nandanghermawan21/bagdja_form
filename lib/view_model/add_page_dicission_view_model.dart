import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/model/dicission_model.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';

class AddPageDicissionViewModel extends ChangeNotifier {
  CircularLoaderController loadingController = CircularLoaderController();
  int? group;
  ListDataComponentController<DicissionModel?> listDicissionController =
      ListDataComponentController<DicissionModel?>();
  List<TextEditingController?> valueDicissions = [];
  List<CircularLoaderController> dicissionLoading = [];
  List<EditStatusDicissions?> editStatusDicission = [];

  void addNewDicission() {
    listDicissionController.value.data.add(DicissionModel(newData: true));
    listDicissionController.commit();
  }

  void clearDicission() {
    valueDicissions = [];
    dicissionLoading = [];
    editStatusDicission = [];
  }

  void fillDicission(DicissionModel? data, int index) {
    if (index == 0) {
      clearDicission();
    }
    valueDicissions.add(TextEditingController());
    dicissionLoading.add(CircularLoaderController());
    editStatusDicission.add(
      data?.newData != true
          ? EditStatusDicissions.saved
          : EditStatusDicissions.newData,
    );
  }

  void removeDicission(DicissionModel? data, int index) {
    valueDicissions.removeAt(index);
    dicissionLoading.removeAt(index);
    editStatusDicission.removeAt(index);
  }

  void saveDicission(DicissionModel? data, int index) {
    if (editStatusDicission[index] == EditStatusDicissions.newData) {
      addDicission(data, index);
    } else {
      updateDicission(data, index);
    }
  }

  void addDicission(DicissionModel? data, int index) {
    dicissionLoading[index].startLoading();
    DicissionModel.add(
      token: System.data.global.token,
      dicissionModel: data,
    ).then(
      (value) {
        data?.newData = false;
        editStatusDicission[index] = EditStatusDicissions.saved;
        dicissionLoading[index].forceStop();
        listDicissionController.commit();
      },
    ).catchError(
      (onError) {
        dicissionLoading[index].stopLoading(
          isError: true,
          message: ErrorHandlingUtil.handleApiError(onError),
        );
      },
    );
  }

  void updateDicission(DicissionModel? data, int index) {
    dicissionLoading[index].startLoading();
    DicissionModel.update(
      token: System.data.global.token,
      dicissionModel: data,
    ).then(
      (value) {
        editStatusDicission[index] = EditStatusDicissions.saved;
        dicissionLoading[index].forceStop();
      },
    ).catchError(
      (onError) {
        dicissionLoading[index].stopLoading(
          isError: true,
          message: ErrorHandlingUtil.handleApiError(onError),
        );
      },
    );
  }

  void deleteDicission(DicissionModel? data, int index) {
    if (editStatusDicission[index] == EditStatusDicissions.newData) {
      removeDicission(data, index);
      listDicissionController.value.data.removeAt(index);
      listDicissionController.commit();
      return;
    }
    dicissionLoading[index].startLoading();
    DicissionModel.delete(
      token: System.data.global.token,
      dicissionModel: data,
    ).then(
      (value) {
        dicissionLoading[index].forceStop();
        removeDicission(data, index);
        listDicissionController.value.data.removeAt(index);
        listDicissionController.commit();
      },
    ).catchError(
      (onError) {
        dicissionLoading[index].stopLoading(
          isError: true,
          message: ErrorHandlingUtil.handleApiError(onError),
        );
      },
    );
  }

  void commit() {
    notifyListeners();
  }
}

enum EditStatusDicissions {
  newData,
  saved,
  onEdit,
}
