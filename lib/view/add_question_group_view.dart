import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/input_component.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/model/question_group_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view_model/add_question_group_view_model.dart';

class AddQuestionGroupView extends StatefulWidget {
  final double? width;
  final QuestionGroupModel? questionGroupModel;

  const AddQuestionGroupView({Key? key, this.width, this.questionGroupModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QuestionGroupState();
  }
}

class QuestionGroupState extends State<AddQuestionGroupView> {
  AddQuestionGroupViewModel addQuestionGroupViewModel =
      AddQuestionGroupViewModel();

  @override
  void initState() {
    super.initState();
    addQuestionGroupViewModel.questionGroupModel = widget.questionGroupModel;
    if (widget.questionGroupModel != null) {
      addQuestionGroupViewModel.fill();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: addQuestionGroupViewModel,
      child: Container(
        width: widget.width,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: IntrinsicHeight(
          child: CircularLoaderComponent(
            controller: addQuestionGroupViewModel.loadingController,
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  child: BasicComponent.panelHeader(
                    title: widget.questionGroupModel != null
                        ? "Edit Question Group"
                        : "Add Question Group",
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
                      Consumer<AddQuestionGroupViewModel>(
                        builder: (c, d, w) {
                          return InputComponent.inputTextWithCap(
                            capTitle: "Code",
                            controller: d.codeController,
                            isValid: d.isValidCode,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer<AddQuestionGroupViewModel>(
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
                                addQuestionGroupViewModel.save();
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
