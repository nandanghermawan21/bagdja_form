import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/component/question_component.dart';
import 'package:suzuki/model/form_model.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/model/page_question_model.dart';
import 'package:suzuki/model/question_group_model.dart';
import 'package:suzuki/model/question_list_model.dart';
import 'package:suzuki/model/question_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view/add_question_group_view.dart';
import 'package:suzuki/view/add_question_view.dart';
import 'package:suzuki/view_model/form_designer_view_model.dart';
import 'package:suzuki/view/form_editor_view.dart';

class FormDesignerView extends StatefulWidget {
  const FormDesignerView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormDesignerViewState();
  }
}

class FormDesignerViewState extends State<FormDesignerView> {
  FormDesignerViewModel formDesignerViewModel = FormDesignerViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: System.data.color!.background,
      body: CircularLoaderComponent(
        controller: formDesignerViewModel.loadingController,
        child: ChangeNotifierProvider.value(
          value: formDesignerViewModel,
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: questions(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: questionGroup(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.transparent,
                    child: Consumer<FormDesignerViewModel>(
                      builder: (c, d, w) {
                        if (d.openedForm != null) {
                          return formEditor();
                        } else {
                          return forms();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget questions() {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          width: double.infinity,
          child: BasicComponent.panelHeader(title: "Question", actions: [
            MenuModel(
              iconData: Icons.add,
              onTap: () {
                editQuestion();
              },
            )
          ]),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: ListDataComponent<QuestionModel?>(
              showSearchBox: true,
              controller: formDesignerViewModel.questionController,
              enableGetMore: false,
              dataSource: (skip, search) {
                return QuestionModel.list(
                  token: System.data.global.token,
                ).then(
                  (value) {
                    return value
                        .where((e) =>
                            (e?.code ?? "")
                                .toLowerCase()
                                .contains((search ?? "").toLowerCase()) ||
                            (e?.name ?? "")
                                .toLowerCase()
                                .contains((search ?? "").toLowerCase()))
                        .toList();
                  },
                );
              },
              itemBuilder: (data, index) {
                return QuestionComponent.questionItem(data,
                    onTapDelete: (data) {
                  BasicComponent.confirmModal(
                    context,
                    message:
                        "Are you sure, will remove ${data?.name} from question?",
                  ).then((value) {
                    if (value == true) {
                      formDesignerViewModel.deleteQuestion(data);
                    }
                  });
                }, onTapEdit: editQuestion);
              },
              dragFeedbackBuilder: (data, index) {
                return Container(
                  width: 200,
                  color: Colors.transparent,
                  child: QuestionComponent.questionItem(
                    data,
                    showDelete: false,
                    showEdit: false,
                  ),
                );
              },
              dragDataBuilder: (data, index) {
                return QuestionListModel(
                  groupId: -1,
                  questionId: data?.id,
                  order: -1,
                  question: data,
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget questionGroup() {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          width: double.infinity,
          child: BasicComponent.panelHeader(title: "Question Group", actions: [
            MenuModel(
              iconData: Icons.add,
              onTap: () {
                edituestionGroup();
              },
            )
          ]),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: ListDataComponent<QuestionGroupModel?>(
              controller: formDesignerViewModel.questionGroupController,
              showSearchBox: true,
              enableGetMore: false,
              dataSource: (skip, search) {
                return QuestionGroupModel.list(
                  token: System.data.global.token,
                ).then((value) {
                  return value
                      .where((e) =>
                          (e?.code ?? "")
                              .toLowerCase()
                              .contains((search ?? "").toLowerCase()) ||
                          (e?.name ?? "")
                              .toLowerCase()
                              .contains((search ?? "").toLowerCase()))
                      .toList();
                });
              },
              itemBuilder: (data, index) {
                formDesignerViewModel.questionListOfGroup["${data?.id}"] =
                    ListDataComponentController<QuestionListModel?>();
                return Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Column(
                      children: [
                        QuestionComponent.questionGroupItem(
                          data,
                          onTapDelete: (data) {
                            BasicComponent.confirmModal(context,
                                    message:
                                        "Are you sure, will remove ${data?.name} from question group?")
                                .then(
                              (value) {
                                if (value == true) {
                                  formDesignerViewModel
                                      .deleteQuestionGroup(data);
                                }
                              },
                            );
                          },
                          onTapEdit: edituestionGroup,
                        ),
                        questionListOfGroup(data),
                      ],
                    ),
                  ),
                );
              },
              dragFeedbackBuilder: (data, index) {
                return Container(
                  color: Colors.transparent,
                  width: 200,
                  child: QuestionComponent.questionGroupItem(
                    data,
                    showDeleteButton: false,
                    showEditButton: false,
                  ),
                );
              },
              dragDataBuilder: (data, index) {
                return PageQuestionModel(
                  pageId: -1,
                  groupId: data?.id,
                  code: data?.code,
                  name: data?.name,
                  order: -1,
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget questionListOfGroup(QuestionGroupModel? data) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.black,
      )),
      child: ListDataComponent<QuestionListModel?>(
        controller: formDesignerViewModel.questionListOfGroup["${data?.id}"],
        listViewMode: ListDataComponentMode.column,
        enableGetMore: false,
        emptyWidget: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          child: Text(
            "Drag question here",
            style: System.data.textStyle!.basicLabel,
          ),
        ),
        dataSource: (skipList, search) {
          return QuestionListModel.list(
            token: System.data.global.token,
            questionGroupId: data?.id,
          );
        },
        itemBuilder: (dataList, index) {
          return QuestionComponent.questionItem(
            dataList?.question,
            showEdit: false,
            onTapDelete: (qs) {
              BasicComponent.confirmModal(
                context,
                message:
                    "Are you sure, will remove ${dataList?.question?.name} from ${data?.name} group?",
              ).then(
                (value) {
                  if (value == true) {
                    formDesignerViewModel
                        .deleteQuestionFromQuestionGroup(dataList);
                  }
                },
              );
            },
          );
        },
        onWillReceiveDropedData: (dropedData, index) {
          if (dropedData?.groupId == data?.id || dropedData?.groupId == -1) {
            return true;
          } else {
            return false;
          }
        },
        onReceiveDropedData: (dropedData, index) {
          dropedData?.groupId = data?.id;
          formDesignerViewModel.updateQuestionOnQuestionGroup(
            data: dropedData,
            controller:
                formDesignerViewModel.questionListOfGroup["${data?.id}"],
            index: index,
          );
        },
        dragFeedbackBuilder: (dataList, index) {
          return Container(
            width: 200,
            color: Colors.transparent,
            child: QuestionComponent.questionItem(
              dataList?.question,
              showEdit: false,
              onTapDelete: (qs) {
                formDesignerViewModel.deleteQuestionFromQuestionGroup(dataList);
              },
            ),
          );
        },
      ),
    );
  }

  Widget forms() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            height: 80,
            color: Colors.transparent,
            child: Row(
              children: [
                Container(
                  color: Colors.transparent,
                  width: 300,
                  child: FittedBox(
                    alignment: Alignment.bottomLeft,
                    fit: BoxFit.fitHeight,
                    child: Text(
                      "FORM",
                      style: System.data.textStyle!.basicLabel,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: ListDataComponent<FormModel?>(
                controller: ListDataComponentController<FormModel?>(),
                enableGetMore: false,
                dataSource: (skip, search) {
                  return FormModel.formOfApplication(
                    token: System.data.global.token,
                  );
                },
                header: Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 3, bottom: 3),
                  padding: const EdgeInsets.all(10),
                  color: System.data.color!.primaryColor,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.transparent,
                          child: Text(
                            "Code",
                            style:
                                System.data.textStyle!.boldTitleLabel.copyWith(
                              color: System.data.color!.lightTextColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: Colors.transparent,
                          child: Text(
                            "Name",
                            style:
                                System.data.textStyle!.boldTitleLabel.copyWith(
                              color: System.data.color!.lightTextColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.transparent,
                          child: Text(
                            "Action",
                            style:
                                System.data.textStyle!.boldTitleLabel.copyWith(
                              color: System.data.color!.lightTextColor,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (data, index) {
                  return Container(
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, top: 3, bottom: 3),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.black,
                    )),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.transparent,
                            child: Text(
                              data?.code ?? "-",
                              style: System.data.textStyle!.boldTitleLabel
                                  .copyWith(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: Colors.transparent,
                            child: Text(
                              data?.name ?? "-",
                              style: System.data.textStyle!.boldTitleLabel
                                  .copyWith(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                formDesignerViewModel.openFormEditor(data);
                              },
                              child: const Icon(
                                Icons.edit,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget formEditor() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.transparent,
      child: FormEditorView(
        formModel: formDesignerViewModel.openedForm,
        onTapClose: formDesignerViewModel.closeFormEditor,
      ),
    );
  }

  Future<void> editQuestion([QuestionModel? questionModel]) {
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contex) {
        return Align(
          alignment: Alignment.center,
          child: Card(
            elevation: 3,
            child: AddQuestionVew(
              width: (width * 30 / 100) > 500 ? (width * 30 / 100) : 500,
              questionModel: questionModel,
            ),
          ),
        );
      },
    ).then((value) {
      formDesignerViewModel.questionController.refresh();
    });
  }

  Future<void> edituestionGroup([QuestionGroupModel? questionGroupModel]) {
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contex) {
        return Align(
          alignment: Alignment.center,
          child: Card(
            elevation: 3,
            child: AddQuestionGroupView(
              width: (width * 30 / 100) > 500 ? (width * 30 / 100) : 500,
              questionGroupModel: questionGroupModel,
            ),
          ),
        );
      },
    ).then((value) {
      formDesignerViewModel.questionGroupController.refresh();
    });
  }
}
