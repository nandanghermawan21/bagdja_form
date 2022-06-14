import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suzuki/component/input_component.dart';
import 'package:suzuki/component/question_component.dart';
import 'package:suzuki/model/question_types_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view_model/add_question_view_model.dart';

class AddQuestionVew extends StatefulWidget {
  final double? width;

  const AddQuestionVew({Key? key, this.width}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddQuestionViewState();
  }
}

class AddQuestionViewState extends State<AddQuestionVew> {
  AddQuestionViewModel addQuestionViewModel = AddQuestionViewModel();

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
          child: Column(
            children: [
              Container(
                color: System.data.color!.primaryColor,
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Edit Question",
                      style: System.data.textStyle!.basicLightLabel,
                    ),
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
                            child: InputComponent.inputTextWithCap(
                              capTitle: "Code",
                              controller: TextEditingController(),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.transparent,
                              child: InputComponent.inputTextWithCap(
                                capTitle: "Name",
                                controller: TextEditingController(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.transparent,
                              child: InputComponent.inputTextWithCap(
                                capTitle: "Label",
                                controller: TextEditingController(),
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
                                return Container(
                                  color: Colors.transparent,
                                  child: InputComponent.dropDownPopupWithCap<
                                          QuestionTypesModel?>(
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
                                            data?.code ?? "");
                                      }),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: InputComponent.inputTextWithCap(
                              capTitle: "Hint",
                              controller: TextEditingController(),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.transparent,
                              child: InputComponent.inputTextWithCap(
                                capTitle: "Data Collection",
                                controller: TextEditingController(),
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
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
    );
  }
}
