import 'package:flutter/material.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/component/question_component.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/model/question_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view/add_question_view.dart';
import 'package:suzuki/view_model/form_designer_view_model.dart';

class FormDesignerView extends StatefulWidget {
  const FormDesignerView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormDesignerViewState();
  }
}

class FormDesignerViewState extends State<FormDesignerView> {
  FormDesignerViewMOdel formDesignerViewModel = FormDesignerViewMOdel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: System.data.color!.background,
      body: CircularLoaderComponent(
        controller: formDesignerViewModel.loadingController,
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
                  color: Colors.green,
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.blue,
                ),
              ),
            ],
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
                edituestions();
              },
            )
          ]),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: ListDataComponent<QuestionModel?>(
              controller: formDesignerViewModel.questionController,
              dataSource: (skip, search) {
                return QuestionModel.list(
                  token: System.data.global.token,
                );
              },
              itemBuilder: (data, index) {
                return QuestionComponent.questionItem(data,
                    onTapDelete: formDesignerViewModel.deleteQuestion,
                    onTapEdit: edituestions);
              },
            ),
          ),
        )
      ],
    );
  }

  Future<void> edituestions([QuestionModel? questionModel]) {
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
}
