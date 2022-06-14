import 'package:flutter/material.dart';
import 'package:suzuki/model/question_types_model.dart';

class AddQuestionViewModel extends ChangeNotifier {
  QuestionTypesModel? questionTypesModel;

  void commit() {
    notifyListeners();
  }
}
