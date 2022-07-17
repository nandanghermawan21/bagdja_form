import 'dart:io';

import 'package:suzuki/model/question_model.dart';
import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class QuestionListModel {
  int? groupId; //": 2,
  int? questionId; //": 8,
  int? order; //": 2
  bool? mandatory;
  int? refQuestionId;
  final QuestionModel? question;

  QuestionListModel({
    this.groupId,
    this.questionId,
    this.order,
    this.mandatory,
    this.refQuestionId,
    this.question,
  });

  static QuestionListModel fromJson(Map<String, dynamic> json) {
    return QuestionListModel(
        groupId: (json["group_id"] as num?)?.toInt(),
        questionId: (json["question_id"] as num?)?.toInt(),
        order: (json["order"] as num?)?.toInt(),
        mandatory: (json["mandatory"] as num?)?.toInt() == 1 ? true : false,
        refQuestionId: (json["ref_question_id"] as num?)?.toInt() ?? 0,
        question: QuestionModel.fronJson(
          json,
          id: (json["question_id"] as num?)?.toInt(),
        ));
  }

  Map<String, dynamic> toJson() {
    return {
      "group_id": groupId,
      "question_id": questionId,
      "order": order,
      "mandatory": mandatory,
      "ref_question_id": refQuestionId,
      "code": question?.code,
      "name": question?.name,
      "label": question?.label,
      "hint": question?.hint,
      "type": question?.type,
      "collection_id": question?.collectionId,
    };
  }

  Map<String, dynamic> toInserBody() {
    return {
      "group_id": groupId,
      "question_id": questionId,
      "order": order,
      "mandatory": mandatory == true ? "1" : "0",
      "ref_question_id": refQuestionId ?? 0,
    };
  }

  static Future<List<QuestionListModel?>> list({
    required String? token,
    required int? questionGroupId,
  }) {
    return Network.get(
      url: Uri.parse(System.data.apiEndPoint.url +
          System.data.apiEndPoint.questionGroupDataUrl),
      querys: {
        "id": "${questionGroupId ?? "0"}",
      },
      otpRequired: null,
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
    ).then((value) {
      if (value == null) {
        return <QuestionListModel>[];
      } else {
        return (value as List)
            .map((e) => QuestionListModel.fromJson(e))
            .toList();
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<QuestionListModel?> add({
    required String? token,
    required QuestionListModel? questionListModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.questionGroupAddDataUrl,
      ),
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (questionListModel?.toInserBody() ?? {}),
    ).then((value) {
      return value == null ? null : QuestionListModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<QuestionListModel?> update({
    required String? token,
    required int? id,
    required int? questionId,
    required QuestionListModel? questionListModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.questionGroupUpdateDataUrl,
      ),
      querys: {
        "id": "${id ?? ""}",
        "questionId": "${questionId ?? ""}",
      },
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (questionListModel?.toInserBody() ?? {}),
    ).then((value) {
      return value == null ? null : QuestionListModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<QuestionListModel?> delete({
    required String? token,
    required int? id,
    required int? questionId,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.questionGroupDeleteDataUrl,
      ),
      querys: {
        "id": "${id ?? ""}",
        "questionId": "${questionId ?? ""}",
      },
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
    ).then((value) {
      return value == null ? null : QuestionListModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }
}
