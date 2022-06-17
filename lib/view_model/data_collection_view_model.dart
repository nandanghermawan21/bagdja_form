import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/model/collection_model.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';

class DataCollectionViewModel extends ChangeNotifier {
  CircularLoaderController loadingController = CircularLoaderController();
  ListDataComponentController<CollectionModel?> collectionListController =
      ListDataComponentController<CollectionModel?>();
  CollectionModel? sellectionSelected;

  void deleteCollection(CollectionModel? data) {
    loadingController.startLoading();
    CollectionModel.delete(
      token: System.data.global.token,
      id: data?.id,
    ).then(
      (value) {
        loadingController.stopLoading(
          message: "Delete Question Success",
          onCloseCallBack: () {
            collectionListController.refresh();
          },
        );
      },
    ).catchError((onError) {
      loadingController.stopLoading(
        message: ErrorHandlingUtil.handleApiError(onError),
        onCloseCallBack: () {
          collectionListController.refresh();
        },
      );
    });
  }

  void commit() {
    notifyListeners();
  }
}
