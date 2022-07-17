import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/input_component.dart';
import 'package:suzuki/component/question_component.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/model/question_list_model.dart';
import 'package:suzuki/model/question_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view_model/add_question_item_view_model.dart';

class AddQuestionItemView extends StatefulWidget {
  final double? width;
  final QuestionListModel? questionListModel;
  final List<QuestionModel?>? questionModelRef;

  const AddQuestionItemView({
    Key? key,
    this.width,
    required this.questionListModel,
    required this.questionModelRef,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddQuestionItemState();
  }
}

class AddQuestionItemState extends State<AddQuestionItemView> {
  AddQuestionItemViewModel addQuestionItemViewModel =
      AddQuestionItemViewModel();

  @override
  void initState() {
    super.initState();
    widget.questionModelRef
        ?.insert(0, QuestionModel(id: 0, name: "None", label: "None"));
    addQuestionItemViewModel.questionListModel = widget.questionListModel;
    addQuestionItemViewModel.selectedQuestionModel = widget.questionModelRef
        ?.where((e) => e?.id == widget.questionListModel?.refQuestionId)
        .toList()
        .first;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: addQuestionItemViewModel,
      child: Container(
        width: widget.width,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: IntrinsicHeight(
          child: CircularLoaderComponent(
            controller: addQuestionItemViewModel.loadingController,
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  child: BasicComponent.panelHeader(
                    title: widget.questionListModel != null
                        ? "Edit Question Item"
                        : "Add Question",
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
                Consumer<AddQuestionItemViewModel>(
                  builder: (c, d, w) {
                    return Container(
                      color: Colors.transparent,
                      child: QuestionComponent.questionItem(
                        d.questionListModel?.question,
                        showEdit: false,
                        showDelete: false,
                        showBorder: false,
                      ),
                    );
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Consumer<AddQuestionItemViewModel>(
                        builder: (c, d, w) {
                          return Container(
                            color: Colors.transparent,
                            child: InputComponent.dropDownPopupWithCap<bool>(
                              capTitle: "Mandatory",
                              dataSource: Future.value().then(
                                (value) => [
                                  true,
                                  false,
                                ],
                              ),
                              value: d.questionListModel?.mandatory,
                              onSelected: (val) {
                                d.questionListModel?.mandatory = val;
                                d.commit();
                              },
                              itemBuilder: (data) {
                                return Container(
                                  color: Colors.transparent,
                                  child: Text(
                                    data.toString().toUpperCase(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      Consumer<AddQuestionItemViewModel>(
                        builder: (c, d, w) {
                          return Container(
                            color: Colors.transparent,
                            child: InputComponent.dropDownPopupWithCap<
                                QuestionModel>(
                              capTitle: "Question Reference",
                              dataSource: Future.value().then(
                                (value) {
                                  return widget.questionModelRef;
                                },
                              ),
                              onSelected: (val) {
                                d.questionListModel?.refQuestionId = val.id;
                                d.selectedQuestionModel = val;
                                d.commit();
                              },
                              itemBuilder: (data) {
                                return QuestionComponent.questionItem(
                                  data,
                                  showEdit: false,
                                  showDelete: false,
                                  showBorder: false,
                                );
                              },
                              value: d.selectedQuestionModel,
                            ),
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
                                addQuestionItemViewModel.save();
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
