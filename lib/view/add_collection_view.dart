import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/input_component.dart';
import 'package:suzuki/model/collection_model.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view_model/add_collection_view_model.dart';

class AddCollectionView extends StatefulWidget {
  final double? width;
  final CollectionModel? collectionModel;

  const AddCollectionView({
    Key? key,
    this.width,
    this.collectionModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddCollectionViewState();
  }
}

class AddCollectionViewState extends State<AddCollectionView> {
  AddCollectionVewModel addCollectionVewModel = AddCollectionVewModel();

  @override
  void initState() {
    super.initState();
    addCollectionVewModel.collectionModel = widget.collectionModel;
    if (widget.collectionModel != null) {
      addCollectionVewModel.fill();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: addCollectionVewModel,
      child: Container(
        width: widget.width,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: IntrinsicHeight(
          child: CircularLoaderComponent(
            controller: addCollectionVewModel.loadingController,
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  child: BasicComponent.panelHeader(
                    title: widget.collectionModel != null
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
                      Consumer<AddCollectionVewModel>(
                        builder: (c, d, w) {
                          return InputComponent.inputTextWithCap(
                            capTitle: "Name",
                            controller: d.nameController,
                            isValid: d.isValidName,
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
                                addCollectionVewModel.save();
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
