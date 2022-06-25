import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/input_component.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/model/dicission_model.dart';
import 'package:suzuki/model/dicission_type_model.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/model/page_question_model.dart';
import 'package:suzuki/model/question_list_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view_model/add_page_dicission_view_model.dart';

class AddPageDicissionView extends StatefulWidget {
  final int pageId;
  final int? groupId;

  const AddPageDicissionView({
    Key? key,
    required this.pageId,
    this.groupId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddPageDiciisionViewState();
  }
}

class AddPageDiciisionViewState extends State<AddPageDicissionView> {
  AddPageDicissionViewModel addPageDicissionViewModel =
      AddPageDicissionViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CircularLoaderComponent(
        controller: addPageDicissionViewModel.loadingController,
        child: ChangeNotifierProvider.value(
          value: addPageDicissionViewModel,
          child: Center(
            child: Container(
              width: 500,
              color: Colors.white,
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BasicComponent.panelHeader(
                      title: "Edit Dicission",
                      actions: [
                        MenuModel(
                          iconData: Icons.close,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              groupSelector(),
                              ElevatedButton(
                                onPressed:
                                    addPageDicissionViewModel.addNewDicission,
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                  System.data.color!.primaryColor,
                                )),
                                child: Text(
                                  "Add New Dicission",
                                  style: System
                                      .data.textStyle!.boldTitleLightLabel,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Colors.white,
                            child: listDicission(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget groupSelector() {
    return Container(
        width: 150,
        color: Colors.transparent,
        child: Consumer<AddPageDicissionViewModel>(
          builder: (c, d, w) {
            return InputComponent.dropDownPopup2withCap<PageQuestionModel,
                int?>(
              capTitle: "Question Group",
              value: d.group,
              dataSource: PageQuestionModel.list(
                token: System.data.global.token,
                pageId: widget.pageId,
              ),
              itemBuilder: (item) {
                return Container(
                  color: Colors.transparent,
                  child: Text(
                    "${item?.code} - ${item?.name}",
                    style: System.data.textStyle!.boldTitleLabel.copyWith(
                      color: d.group == item?.groupId
                          ? System.data.color!.link
                          : null,
                    ),
                  ),
                );
              },
              onSelected: (value) {
                d.group = value;
                d.commit();
                d.listDicissionController.refresh();
              },
              valueBuilder: (data) {
                return data?.groupId;
              },
              selectedBuilder: (data, value) {
                List<PageQuestionModel?>? _result =
                    data?.where((e) => e?.groupId == value).toList();
                PageQuestionModel? _selected =
                    (_result ?? []).isNotEmpty ? (_result ?? []).first : null;
                return Container(
                  color: Colors.transparent,
                  child: Text(
                    _selected?.code ?? "",
                    style: System.data.textStyle!.boldTitleLabel,
                  ),
                );
              },
            );
          },
        ));
  }

  Widget listDicission() {
    return ListDataComponent<DicissionModel?>(
      controller: addPageDicissionViewModel.listDicissionController,
      listViewMode: ListDataComponentMode.column,
      enableGetMore: false,
      dataSource: (skip, search) {
        return DicissionModel.pageDicission(
          token: System.data.global.token,
          pageId: widget.pageId,
          groupId: addPageDicissionViewModel.group ?? 0,
        );
      },
      itemBuilder: (data, index) {
        addPageDicissionViewModel.fillDicission(data, index);
        return IntrinsicHeight(
          child: CircularLoaderComponent(
            controller: addPageDicissionViewModel.dicissionLoading[index],
            loadingBuilder: SkeletonAnimation(
              child: Container(
                color: Colors.grey.shade300.withOpacity(0.7),
              ),
            ),
            child: dicissionEditor(data, index),
          ),
        );
      },
    );
  }

  Widget dicissionEditor(DicissionModel? data, int index) {
    data?.pageId = widget.pageId;
    data?.groupId = addPageDicissionViewModel.group;
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: groupDicission(data, index),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              width: 150,
              child: questionDicission(data, index),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: typeDicission(data, index),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: valueDiccion(data, index),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      data?.dicissionValue = addPageDicissionViewModel
                          .valueDicissions[index]?.text;
                      addPageDicissionViewModel.saveDicission(data, index);
                    },
                    child: Icon(
                      Icons.save,
                      color: System.data.color!.primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      data?.dicissionValue = addPageDicissionViewModel
                          .valueDicissions[index]?.text;
                      addPageDicissionViewModel.deleteDicission(data, index);
                    },
                    child: Icon(
                      Icons.close,
                      color: System.data.color!.primaryColor,
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget groupDicission(DicissionModel? data, int index) {
    return InputComponent.dropDownPopup2withCap<PageQuestionModel, int?>(
      capTitle: "Question Group",
      value: data?.dicissionGroupId,
      readOnly: addPageDicissionViewModel.editStatusDicission[index] !=
              EditStatusDicissions.newData
          ? true
          : false,
      dataSource: PageQuestionModel.list(
        token: System.data.global.token,
        pageId: widget.pageId,
      ),
      itemBuilder: (item) {
        return Container(
          color: Colors.transparent,
          child: Text(
            "${item?.code} - ${item?.name}",
            style: System.data.textStyle!.boldTitleLabel.copyWith(
              color: data?.dicissionGroupId == item?.groupId
                  ? System.data.color!.link
                  : null,
            ),
          ),
        );
      },
      onSelected: (value) {
        data?.dicissionGroupId = value;
        data?.dicissionQuestionId = null;
        addPageDicissionViewModel.listDicissionController.commit();
      },
      valueBuilder: (data) {
        return data?.groupId;
      },
      selectedBuilder: (data, value) {
        List<PageQuestionModel?>? _result =
            data?.where((e) => e?.groupId == value).toList();
        PageQuestionModel? _selected =
            (_result ?? []).isNotEmpty ? (_result ?? []).first : null;
        return Container(
          color: Colors.transparent,
          child: Text(
            _selected?.code ?? "",
            style: System.data.textStyle!.boldTitleLabel,
          ),
        );
      },
    );
  }

  Widget questionDicission(DicissionModel? data, int index) {
    return InputComponent.dropDownPopup2withCap<QuestionListModel, int?>(
      capTitle: "Question",
      value: data?.dicissionQuestionId,
      readOnly: addPageDicissionViewModel.editStatusDicission[index] !=
              EditStatusDicissions.newData
          ? true
          : false,
      dataSource: QuestionListModel.list(
        token: System.data.global.token,
        questionGroupId: data?.dicissionGroupId,
      ),
      itemBuilder: (item) {
        return Container(
          color: Colors.transparent,
          child: Text(
            "${item?.question?.code} - ${item?.question?.name}",
            style: System.data.textStyle!.boldTitleLabel.copyWith(
              color: data?.dicissionQuestionId == item?.questionId
                  ? System.data.color!.link
                  : null,
            ),
          ),
        );
      },
      onSelected: (value) {
        data?.dicissionQuestionId = value;
        addPageDicissionViewModel.listDicissionController.commit();
      },
      valueBuilder: (data) {
        return data?.questionId;
      },
      selectedBuilder: (data, value) {
        List<QuestionListModel?>? _result =
            data?.where((e) => e?.questionId == value).toList();
        QuestionListModel? _selected =
            (_result ?? []).isNotEmpty ? (_result ?? []).first : null;
        return Container(
          color: Colors.transparent,
          child: Text(
            _selected?.question?.code ?? "",
            style: System.data.textStyle!.boldTitleLabel,
          ),
        );
      },
    );
  }

  Widget typeDicission(DicissionModel? data, int index) {
    return InputComponent.dropDownPopup2withCap<DicissionTypeModel, int?>(
      capTitle: "Dicission Type",
      value: data?.dicissionType,
      dataSource: DicissionTypeModel.list(
        token: System.data.global.token,
      ),
      itemBuilder: (item) {
        return Container(
          color: Colors.transparent,
          child: Text(
            "${item?.symbol} - ${item?.name}",
            style: System.data.textStyle!.boldTitleLabel.copyWith(
              color: data?.dicissionType == item?.id
                  ? System.data.color!.link
                  : null,
            ),
          ),
        );
      },
      onSelected: (value) {
        data?.dicissionType = value;
        addPageDicissionViewModel.listDicissionController.commit();
      },
      valueBuilder: (data) {
        return data?.id;
      },
      selectedBuilder: (data, value) {
        List<DicissionTypeModel?>? _result =
            data?.where((e) => e?.id == value).toList();
        DicissionTypeModel? _selected =
            (_result ?? []).isNotEmpty ? (_result ?? []).first : null;
        return Container(
          color: Colors.transparent,
          child: Text(
            _selected?.symbol ?? "",
            style: System.data.textStyle!.boldTitleLabel,
          ),
        );
      },
    );
  }

  Widget valueDiccion(DicissionModel? data, int index) {
    return Consumer<AddPageDicissionViewModel>(
      builder: (c, d, w) {
        return InputComponent.inputTextWithCap(
          capTitle: "Value",
          controller: d.valueDicissions[index],
          value: data?.dicissionValue,
        );
      },
    );
  }
}
