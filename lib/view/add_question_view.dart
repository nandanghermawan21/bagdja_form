import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/collection_component.dart';
import 'package:suzuki/component/input_component.dart';
import 'package:suzuki/component/question_component.dart';
import 'package:suzuki/model/image_resolution_model.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/model/question_model.dart';
import 'package:suzuki/model/question_types_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view_model/add_question_view_model.dart';

class AddQuestionVew extends StatefulWidget {
  final double? width;
  final QuestionModel? questionModel;

  const AddQuestionVew({
    Key? key,
    this.width,
    this.questionModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddQuestionViewState();
  }
}

class AddQuestionViewState extends State<AddQuestionVew> {
  AddQuestionViewModel addQuestionViewModel = AddQuestionViewModel();

  @override
  void initState() {
    super.initState();
    addQuestionViewModel.questionModel = widget.questionModel;
    if (widget.questionModel != null && mounted) {
      addQuestionViewModel.fill();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: addQuestionViewModel,
      child: Container(
        width: widget.width,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: IntrinsicHeight(
          child: CircularLoaderComponent(
            controller: addQuestionViewModel.loadingController,
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  child: BasicComponent.panelHeader(
                    title: widget.questionModel != null
                        ? "Edit Question"
                        : "Add Question",
                    actions: [
                      MenuModel(
                          iconData: Icons.close,
                          onTap: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Consumer<AddQuestionViewModel>(
                                builder: (c, d, w) {
                                  return InputComponent.inputTextWithCap(
                                    isValid: d.isValidCode,
                                    controller:
                                        addQuestionViewModel.codeController,
                                    capTitle: "Code",
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: Consumer<AddQuestionViewModel>(
                                builder: (c, d, w) {
                                  return InputComponent.inputTextWithCap(
                                    isValid: d.isValidName,
                                    controller:
                                        addQuestionViewModel.nameController,
                                    capTitle: "Name",
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: Colors.transparent,
                                child: Consumer<AddQuestionViewModel>(
                                  builder: (c, d, w) {
                                    return InputComponent.inputTextWithCap(
                                      isValid: d.isValidLabel,
                                      controller:
                                          addQuestionViewModel.labelController,
                                      capTitle: "Label",
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Consumer<AddQuestionViewModel>(
                                builder: (c, d, w) {
                                  return InputComponent.dropDownPopupWithCap<
                                      QuestionTypesModel?>(
                                    isValid: d.isValidType,
                                    capTitle: "Type",
                                    value: d.questionTypesModel,
                                    onSelected: (data) {
                                      d.questionTypesModel = data;
                                      d.commit();
                                    },
                                    dataSource: QuestionTypesModel.list(
                                      token: System.data.global.token,
                                    ),
                                    itemBuilder: (data) {
                                      return Row(
                                        children: [
                                          QuestionComponent.getIconWidget(
                                              data?.code ?? ""),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            data?.name ?? "",
                                            style: System
                                                .data.textStyle!.basicLabel,
                                          )
                                        ],
                                      );
                                    },
                                    selectedBuilder: (data) {
                                      return QuestionComponent.getIconWidget(
                                          d.questionTypesModel?.code ?? "");
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: Consumer<AddQuestionViewModel>(
                                builder: (c, d, w) {
                                  return InputComponent.inputTextWithCap(
                                    isValid: d.isValidHint,
                                    controller:
                                        addQuestionViewModel.hintController,
                                    capTitle: "Hint",
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  if (QuestionTypes.needCollectionData(
                                      addQuestionViewModel
                                              .questionTypesModel?.code ??
                                          "")) {
                                    CollectionComponent.collectionSelector(
                                      context: context,
                                      onSelected: (data) {
                                        if (data == null) return;
                                        addQuestionViewModel.collectionModel =
                                            data;
                                        addQuestionViewModel.commit();
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Data Collection",
                                        style:
                                            System.data.textStyle!.basicLabel,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Consumer<AddQuestionViewModel>(
                                          builder: (c, d, w) {
                                        return Container(
                                          height: 50,
                                          width: double.infinity,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                              color: d.isValidCollection
                                                  ? Colors.black
                                                  : System
                                                      .data.color!.dangerColor,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            QuestionTypes.needCollectionData(d
                                                        .questionTypesModel
                                                        ?.code ??
                                                    "")
                                                ? "${d.collectionModel?.id ?? ""} ${d.collectionModel?.name ?? ""}"
                                                : "",
                                            style: System
                                                .data.textStyle!.basicLabel,
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Consumer<AddQuestionViewModel>(
                                builder: (c, d, w) {
                                  return InputComponent.dropDownPopupWithCap<
                                      bool?>(
                                    isValid: true,
                                    capTitle: "Read Only",
                                    value: d.readOnly,
                                    onSelected: (data) {
                                      d.readOnly = data ?? false;
                                      d.commit();
                                    },
                                    dataSource: Future.value()
                                        .then((value) => [true, false]),
                                    itemBuilder: (data) {
                                      return Row(
                                        children: [
                                          Text(
                                            data == true ? "Yes" : "No",
                                            style: System
                                                .data.textStyle!.basicLabel,
                                          )
                                        ],
                                      );
                                    },
                                    selectedBuilder: (data) {
                                      return Text(
                                        data == true ? "Yes" : "No",
                                        style:
                                            System.data.textStyle!.basicLabel,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: Consumer<AddQuestionViewModel>(
                                builder: (c, d, w) {
                                  return swithAdditionalSetting1(d);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                addQuestionViewModel.save();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    System.data.color!.link),
                              ),
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

  Widget swithAdditionalSetting1(AddQuestionViewModel e) {
    switch (addQuestionViewModel.questionTypesModel?.code) {
      case QuestionTypes.foto:
        return imageResolutionInput(e);
      default:
        return const SizedBox();
    }
  }

  Widget imageResolutionInput(AddQuestionViewModel d) {
    return InputComponent.dropDownPopupWithCap<ImageResolutionModel?>(
      isValid: d.isValidImageResolution,
      capTitle: "Image Resolution",
      value: d.imageResolutionModel,
      onSelected: (data) {
        d.imageResolutionModel = data;
        d.commit();
      },
      dataSource: ImageResolutionModel.resolutions(),
      itemBuilder: (data) {
        return Row(
          children: [
            Text(
              data?.name ?? "",
              style: System.data.textStyle!.basicLabel,
            )
          ],
        );
      },
      selectedBuilder: (data) {
        return Text(
          data?.name ?? "",
          style: System.data.textStyle!.basicLabel,
        );
      },
    );
  }
}
