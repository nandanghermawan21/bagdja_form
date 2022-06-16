import 'package:flutter/material.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/collection_component.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/model/collection_model.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view/add_collection_view.dart';
import 'package:suzuki/view_model/data_collection_view_model.dart';

class DataCollectionView extends StatefulWidget {
  const DataCollectionView({Key? key})
      : super(
          key: key,
        );

  @override
  State<StatefulWidget> createState() {
    return DataCollectionState();
  }
}

class DataCollectionState extends State<DataCollectionView> {
  DataCollectionViewModel dataCollectionViewModel = DataCollectionViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: System.data.color!.background,
      body: CircularLoaderComponent(
        controller: dataCollectionViewModel.loadingController,
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.transparent,
                  child: collection(),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget collection() {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          child: BasicComponent.panelHeader(
            title: "Collections",
            actions: [
              MenuModel(
                iconData: Icons.add,
                onTap: editCollection,
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: ListDataComponent<CollectionModel?>(
              controller: dataCollectionViewModel.collectionListController,
              dataSource: (skip, search) {
                return CollectionModel.list(
                  token: System.data.global.token,
                );
              },
              itemBuilder: (data, index) {
                return CollectionComponent.collectionItem(data, action: [
                  MenuModel(
                    iconData: Icons.delete,
                    onTap: () {
                      dataCollectionViewModel.deleteCollection(data);
                    },
                  ),
                  MenuModel(
                    iconData: Icons.edit,
                    onTap: () {
                      editCollection(data);
                    },
                  ),
                ]);
              },
            ),
          ),
        )
      ],
    );
  }

  Future<void> editCollection([CollectionModel? collectionModel]) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contex) {
        return Align(
          alignment: Alignment.center,
          child: Card(
            elevation: 3,
            child: AddCollectionView(
              width: 300,
              collectionModel: collectionModel,
            ),
          ),
        );
      },
    ).then((value) {
      dataCollectionViewModel.collectionListController.refresh();
    });
  }
}
