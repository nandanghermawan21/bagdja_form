import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/model/collection_model.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';

class AddCollectionVewModel extends ChangeNotifier {
  CircularLoaderController loadingController = CircularLoaderController();
  CollectionModel? collectionModel;
  TextEditingController nameController = TextEditingController();

  bool isValidName = true;

  void fill() {
    nameController.text = collectionModel?.name ?? "";
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

  void save() {
    if (!validate()) return;
    if (collectionModel != null) {
      update();
    } else {
      add();
    }
  }

  void commit() {
    notifyListeners();
  }

  void update() {
    loadingController.startLoading();
    CollectionModel.update(
      token: System.data.global.token,
      id: collectionModel?.id,
      collectionModel: CollectionModel(
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
    CollectionModel.create(
      token: System.data.global.token,
      collectionModel: CollectionModel(
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
}
