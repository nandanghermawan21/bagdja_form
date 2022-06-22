// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/input_component.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/component/question_component.dart';
import 'package:suzuki/model/form_model.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/model/page_model.dart';
import 'package:suzuki/model/page_question_model.dart';
import 'package:suzuki/model/question_group_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view_model/form_editor_view_model.dart';
import 'package:suzuki/view/add_page_view.dart';

class FormEditorView extends StatefulWidget {
  final FormModel? formModel;
  final VoidCallback? onTapClose;

  const FormEditorView({
    Key? key,
    this.formModel,
    this.onTapClose,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormEditorViewState();
  }
}

class FormEditorViewState extends State<FormEditorView> {
  FormEditorViewModel formEditorViewModel = FormEditorViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CircularLoaderComponent(
        controller: formEditorViewModel.loadingController,
        child: Container(
          padding: const EdgeInsets.all(0),
          color: Colors.transparent,
          child: Column(
            children: [
              IntrinsicHeight(
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Colors.transparent,
                                      child: InputComponent.inputTextWithCap(
                                        controller: TextEditingController(),
                                        capTitle: "Form Code",
                                        hint: "Form Code",
                                        readOnly: true,
                                        value: widget.formModel?.code,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      color: Colors.transparent,
                                      child: InputComponent.inputTextWithCap(
                                        controller: TextEditingController(),
                                        capTitle: "Form Name",
                                        hint: "Form Name",
                                        readOnly: true,
                                        value: widget.formModel?.name,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        editPage().then(
                                          (value) {
                                            formEditorViewModel
                                                .listPageController
                                                ?.refresh();
                                          },
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          System.data.color!.primaryColor,
                                        ),
                                      ),
                                      child: Text(
                                        "Add New Page",
                                        style: System.data.textStyle!
                                            .boldTitleLightLabel,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        color: Colors.transparent,
                        height: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: widget.onTapClose,
                              child: Icon(
                                Icons.close,
                                color: System.data.color!.darkTextColor,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  child: pageEditor(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget pageEditor() {
    return ListDataComponent<PageModel?>(
      controller: formEditorViewModel.listPageController,
      enableGetMore: false,
      listViewMode: ListDataComponentMode.tile,
      dataSource: (skip, search) {
        return PageModel.formPages(
          token: System.data.global.token,
          id: widget.formModel?.id,
        );
      },
      itemBuilder: (data, index) {
        return pageItem(data);
      },
      dragFeedbackBuilder: (data, index) {
        return pageItem(data);
      },
    );
  }

  Widget pageItem(PageModel? page, {bool isForDragFeedBack = false}) {
    formEditorViewModel.pageQuestionControllers["${page?.id}"] =
        ListDataComponentController<PageQuestionModel?>();
    return Container(
      margin: const EdgeInsets.all(10),
      color: Colors.transparent,
      width: 300,
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: BasicComponent.panelHeader(
              title: "${page?.name ?? "-"}",
              backgroundColor: Colors.white,
              color: System.data.color!.darkTextColor,
              actions: [
                MenuModel(
                    iconData: Icons.edit,
                    onTap: () {
                      editPage(page: page).then((value) {
                        formEditorViewModel.listPageController?.refresh();
                      });
                    }),
                MenuModel(
                  iconData: Icons.delete,
                  onTap: () {
                    BasicComponent.confirmModal(context,
                            message:
                                "Are you sure, will remove this ${page?.name} page?,")
                        .then(
                      (value) {
                        if (value == true) {
                          formEditorViewModel.deletePage(context, page);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Column(
              children: [
                BasicComponent.panelHeader(
                  title: "Question Group",
                ),
                isForDragFeedBack
                    ? Container(
                        height: 50,
                        color: Colors.white,
                      )
                    : pageQuestion(page),
                BasicComponent.panelHeader(
                  title: "Dicission",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget pageQuestion(PageModel? page) {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      color: Colors.transparent,
      child: ListDataComponent<PageQuestionModel?>(
        controller: formEditorViewModel.pageQuestionControllers["${page?.id}"],
        enableGetMore: false,
        listViewMode: ListDataComponentMode.column,
        emptyWidget: Container(
          height: 50,
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Text(
            "Drag question group here",
            style: System.data.textStyle!.basicLabel,
          ),
        ),
        dataSource: (skip, search) {
          return PageQuestionModel.list(
            token: System.data.global.token,
            pageId: page?.id,
          );
        },
        itemBuilder: (data, index) {
          return QuestionComponent.questionGroupItem(
            QuestionGroupModel(
              id: data?.groupId,
              code: data?.code,
              name: data?.name,
            ),
            showEditButton: false,
            onTapDelete: (question) {
              BasicComponent.confirmModal(
                context,
                message:
                    "Are you sure, will remove ${data?.name} from page ${page?.name}?",
              ).then(
                (value) {
                  if (value == true) {
                    formEditorViewModel.deleteQuestionOnPage(
                      data,
                      formEditorViewModel
                          .pageQuestionControllers["${page?.id}"],
                    );
                  }
                },
              );
            },
          );
        },
        dragFeedbackBuilder: (data, index) {
          return Container(
            width: 200,
            color: Colors.transparent,
            child: QuestionComponent.questionGroupItem(
              QuestionGroupModel(
                id: data?.groupId,
                code: data?.code,
                name: data?.name,
              ),
              showEditButton: false,
              showDeleteButton: false,
            ),
          );
        },
        onWillReceiveDropedData: (data, index) {
          if (data?.pageId == page?.id || data?.pageId == -1) {
            return true;
          } else {
            return false;
          }
        },
        onReceiveDropedData: (data, index) {
          data?.pageId = page?.id;
          formEditorViewModel.updateQuestionOnPage(
            data: data,
            controller:
                formEditorViewModel.pageQuestionControllers["${page?.id}"],
            index: index,
          );
        },
      ),
    );
  }

  Future<void> editPage({PageModel? page}) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AddPageView(
          listPageModel: formEditorViewModel.listPageController?.value.data ??
              <PageModel>[],
          pageModel: page ??
              PageModel(
                formId: widget.formModel?.id,
                order: (formEditorViewModel
                            .listPageController?.value.data.last?.order ??
                        0) +
                    1,
              ),
        );
      },
    );
  }
}
