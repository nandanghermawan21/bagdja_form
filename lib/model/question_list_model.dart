import 'dart:io';

import 'package:suzuki/model/question_model.dart';
import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class QuestionListModel {
  int? groupId; //": 2,
  int? questionId; //": 8,
  int? order; //": 2
  final QuestionModel? question;

  QuestionListModel({
    this.groupId,
    this.questionId,
    this.order,
    this.question,
  });

  static QuestionListModel fromJson(Map<String, dynamic> json) {
    return QuestionListModel(
        groupId: (json["groupId"] as num?)?.toInt(),
        questionId: (json["questionId"] as num?)?.toInt(),
        order: (json["order"] as num?)?.toInt(),
        question: QuestionModel.fronJson(
          json,
          id: (json["groupId"] as num?)?.toInt(),
        ));
  }

  Map<String, dynamic> toJson() {
    return {
      "group_id": groupId,
      "question_id": questionId,
      "order": order,
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
      body: (questionListModel?.toJson() ?? {}),
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
    required String? value,
    required QuestionListModel? questionListModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.questionGroupUpdateDataUrl,
      ),
      querys: {
        "id": "${id ?? ""}",
        "question_id": value ?? "",
      },
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (questionListModel?.toJson() ?? {}),
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
    required String? value,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.questionGroupUpdateDataUrl,
      ),
      querys: {
        "id": "${id ?? ""}",
        "question_id": value ?? "",
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
