import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/model/collection_data_model.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';

class AddCollectionDataViewModel extends ChangeNotifier {
  CircularLoaderController loadingController = CircularLoaderController();
  int? collectionId;
  CollectionDataModel? collectionDataModel;
  TextEditingController valueController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  TextEditingController groupController = TextEditingController();

  bool isValidValue = true;
  bool isValidLabel = true;

  void fill() {
    valueController.text = collectionDataModel?.value ?? "";
    labelController.text = collectionDataModel?.label ?? "";
    groupController.text = collectionDataModel?.group ?? "";
  }

  void clear() {
    valueController.text = "";
    labelController.text = "";
  }

  bool? validateValue() {
    if (valueController.text != "") {
      isValidValue = true;
      return null;
    } else {
      isValidValue = false;
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

  bool validate() {
    bool _valid = true;
    _valid = validateValue() ?? _valid;
    _valid = validateLabel() ?? _valid;
    commit();
    return _valid;
  }

  void save() {
    if (!validate()) return;
    if (collectionDataModel != null) {
      update();
    } else {
      add();
    }
  }

  void update() {
    loadingController.startLoading();
    CollectionDataModel.update(
      token: System.data.global.token,
      id: collectionDataModel?.collectionId,
      value: collectionDataModel?.value,
      collectionDataModel: CollectionDataModel(
        collectionId: collectionDataModel?.collectionId,
        value: valueController.text,
        label: labelController.text,
        group: groupController.text,
      ),
    ).then((value) {
      loadingController.stopLoading(
          duration: const Duration(seconds: 2),
          message: "Create Collection Success",
          onCloseCallBack: () {});
    }).catchError((onError) {
      loadingController.stopLoading(
        message: ErrorHandlingUtil.handleApiError(onError),
        isError: true,
      );
    });
  }

  void add() {
    loadingController.startLoading();
    CollectionDataModel.add(
      token: System.data.global.token,
      collectionDataModel: CollectionDataModel(
        collectionId: collectionId,
        value: valueController.text,
        label: labelController.text,
      ),
    ).then((value) {
      loadingController.stopLoading(
          duration: const Duration(seconds: 2),
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
