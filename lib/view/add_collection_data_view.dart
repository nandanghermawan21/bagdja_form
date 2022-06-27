import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/input_component.dart';
import 'package:suzuki/model/collection_data_model.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view_model/add_collection_data_view_model.dart';

class AddCollectionDataView extends StatefulWidget {
  final double? width;
  final int collectionId;
  final CollectionDataModel? collectionDataModel;

  const AddCollectionDataView({
    Key? key,
    required this.collectionId,
    this.width,
    this.collectionDataModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddCollectionDataState();
  }
}

class AddCollectionDataState extends State<AddCollectionDataView> {
  AddCollectionDataViewModel addCollectionDataViewModel =
      AddCollectionDataViewModel();

  @override
  void initState() {
    super.initState();
    addCollectionDataViewModel.collectionId = widget.collectionId;
    addCollectionDataViewModel.collectionDataModel = widget.collectionDataModel;
    if (widget.collectionDataModel != null) {
      addCollectionDataViewModel.fill();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: addCollectionDataViewModel,
      child: Container(
        width: widget.width,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: IntrinsicHeight(
          child: CircularLoaderComponent(
            controller: addCollectionDataViewModel.loadingController,
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  child: BasicComponent.panelHeader(
                    title: widget.collectionDataModel != null
                        ? "Edit Collection"
                        : "Add Collection",
                    actions: [
                      MenuModel(
                        iconData: Icons.close,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Consumer<AddCollectionDataViewModel>(
                        builder: (c, d, w) {
                          return InputComponent.inputTextWithCap(
                            capTitle: "Value",
                            controller: d.valueController,
                            isValid: d.isValidValue,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer<AddCollectionDataViewModel>(
                        builder: (c, d, w) {
                          return InputComponent.inputTextWithCap(
                            capTitle: "Label",
                            controller: d.labelController,
                            isValid: d.isValidLabel,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer<AddCollectionDataViewModel>(
                        builder: (c, d, w) {
                          return InputComponent.inputTextWithCap(
                            capTitle: "Group",
                            controller: d.groupController,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                addCollectionDataViewModel.save();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      System.data.color!.link)),
                              child: Text(
                                System.data.strings!.save,
                                style: TextStyle(
                                  color: System.data.color!.lightTextColor,
                                  fontSize: System.data.font!.xxxl,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
