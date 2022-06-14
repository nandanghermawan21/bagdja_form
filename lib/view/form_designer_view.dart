import 'package:flutter/material.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/component/question_component.dart';
import 'package:suzuki/model/question_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view/add_question_view.dart';

class FormDesignerView extends StatefulWidget {
  const FormDesignerView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormDesignerViewState();
  }
}

class FormDesignerViewState extends State<FormDesignerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: System.data.color!.background,
      body: Container(
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
                color: Colors.green,
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget questions() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
          color: System.data.color!.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Question",
                style: System.data.textStyle!.boldTitleLabel.copyWith(
                  color: System.data.color!.lightTextColor,
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 20,
                alignment: Alignment.topCenter,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      addQuestions();
                    },
                    child: Icon(
                      Icons.add,
                      color: System.data.color!.lightTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: ListDataComponent<QuestionModel?>(
              controller: ListDataComponentController<QuestionModel?>(),
              dataSource: (skip, search) {
                return QuestionModel.list(
                  token: System.data.global.token,
                );
              },
              itemBuilder: (data, index) {
                return QuestionComponent.questionItem(data);
              },
            ),
          ),
        )
      ],
    );
  }

  Future<void> addQuestions() {
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (contex) {
        return Align(
          alignment: Alignment.center,
          child: Card(
            elevation: 3,
            child: AddQuestionVew(
              width: (width * 30 / 100) > 500 ? (width * 30 / 100) : 500,
            ),
          ),
        );
      },
    );
  }
}
