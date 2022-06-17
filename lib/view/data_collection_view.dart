import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/collection_component.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/model/collection_data_model.dart';
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
        child: ChangeNotifierProvider.value(
          value: dataCollectionViewModel,
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
                    color: Colors.transparent,
                    child: coolectionData(),
                  ),
                ),
              ],
            ),
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
            color: Colors.white,
            child: ListDataComponent<CollectionModel?>(
              controller: dataCollectionViewModel.collectionListController,
              dataSource: (skip, search) {
                return CollectionModel.list(
                  token: System.data.global.token,
                );
              },
              itemBuilder: (data, index) {
                dataCollectionViewModel.sellectionSelected ??= data;
                dataCollectionViewModel.commit();
                return Consumer<DataCollectionViewModel>(
                  builder: (c, d, w) {
                    return GestureDetector(
                      onTap: () {
                        dataCollectionViewModel.sellectionSelected = data;
                        dataCollectionViewModel.commit();
                      },
                      child: CollectionComponent.collectionItem(
                        data,
                        backgroundColor:
                            data != dataCollectionViewModel.sellectionSelected
                                ? Colors.white
                                : System.data.color!.link,
                        textColor:
                            data == dataCollectionViewModel.sellectionSelected
                                ? System.data.color!.lightTextColor
                                : null,
                        action: [
                          MenuModel(
                            iconData: Icons.delete,
                            color: data ==
                                    dataCollectionViewModel.sellectionSelected
                                ? System.data.color!.lightTextColor
                                : null,
                            onTap: () {
                              dataCollectionViewModel.deleteCollection(data);
                            },
                          ),
                          MenuModel(
                            iconData: Icons.edit,
                            color: data ==
                                    dataCollectionViewModel.sellectionSelected
                                ? System.data.color!.lightTextColor
                                : null,
                            onTap: () {
                              editCollection(data);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget coolectionData() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            height: 80,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Consumer<DataCollectionViewModel>(
                    builder: (c, d, w) {
                      return Container(
                        color: Colors.transparent,
                        child: FittedBox(
                          alignment: Alignment.bottomLeft,
                          fit: BoxFit.fill,
                          child: Text(
                            d.sellectionSelected?.name ?? " ",
                            style: System.data.textStyle!.basicLabel,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.transparent,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // loginViewMOdel.login(
                            //     onLOginSuccess: widget.onLoginSuccess);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  System.data.color!.link)),
                          child: Text(
                            "Add Row",
                            style: TextStyle(
                              color: System.data.color!.lightTextColor,
                              fontSize: System.data.font!.xxxl,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Consumer<DataCollectionViewModel>(
              builder: (c, d, w) {
                return Container(
                  color: Colors.transparent,
                  child: ListDataComponent<CollectionDataModel?>(
                    controller:
                        ListDataComponentController<CollectionDataModel?>(),
                    header: Container(
                      padding: const EdgeInsets.all(0),
                      color: System.data.color!.primaryColor,
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              color: Colors.transparent,
                              child: Text(
                                "Value",
                                style: System.data.textStyle!.boldTitleLabel
                                    .copyWith(
                                  color: System.data.color!.lightTextColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              color: Colors.transparent,
                              child: Text(
                                "Label",
                                style: System.data.textStyle!.boldTitleLabel
                                    .copyWith(
                                  color: System.data.color!.lightTextColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              color: Colors.transparent,
                              child: Text(
                                "Action",
                                style: System.data.textStyle!.boldTitleLabel
                                    .copyWith(
                                  color: System.data.color!.lightTextColor,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    dataSource: (skip, index) {
                      return CollectionDataModel.list(
                          token: System.data.global.token,
                          collectionId:
                              dataCollectionViewModel.sellectionSelected?.id);
                    },
                    itemBuilder: (data, index) {
                      return Container(
                        padding: const EdgeInsets.all(0),
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                            )),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 5, bottom: 5),
                                color: Colors.transparent,
                                child: Text(
                                  data?.value ?? "",
                                  style: System.data.textStyle!.boldTitleLabel,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 5, bottom: 5),
                                color: Colors.transparent,
                                child: Text(
                                  data?.label ?? "",
                                  style: System.data.textStyle!.boldTitleLabel,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
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
