import 'dart:io';

import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class DicissionModel {
  int? pageId; //": 0,
  int? groupId; //": 0,
  int? dicissionGroupId; //": 0,
  int? dicissionQuestionId; //": 0,
  int? dicissionType; //": 0,
  String? dicissionValue; //": 0,
  String? groupCode; //": "string",
  String? groupName; //": "string",
  String? questionCode; //": "string",
  String? questionName; //": "string",
  String? questionLabel; //": "string",
  String? questionHint; //": "string",
  String? questionType; //": "string",
  int? questionCollectionId; //": 0
  bool? newData;

  DicissionModel({
    this.pageId,
    this.groupId,
    this.dicissionGroupId,
    this.dicissionQuestionId,
    this.dicissionType,
    this.dicissionValue,
    this.groupCode,
    this.groupName,
    this.questionCode,
    this.questionName,
    this.questionLabel,
    this.questionHint,
    this.questionType,
    this.questionCollectionId,
    this.newData = false,
  });

  static DicissionModel fromJson(Map<String, dynamic> json) {
    return DicissionModel(
      pageId: (json["page_id"] as num?)?.toInt(),
      groupId: (json["group_id"] as num?)?.toInt(),
      dicissionGroupId: (json["dicission_group_id"] as num?)?.toInt(),
      dicissionQuestionId: (json["dicission_question_id"] as num?)?.toInt(),
      dicissionType: (json["dicission_type"] as num?)?.toInt(),
      dicissionValue: (json["dicission_value"] as String?),
      groupCode: (json["group_code"] as String?),
      groupName: (json["group_name"] as String?),
      questionCode: (json["question_code"] as String?),
      questionName: (json["question_name"] as String?),
      questionLabel: (json["question_label"] as String?),
      questionHint: (json["question_hint"] as String?),
      questionType: (json["question_type"] as String?),
      questionCollectionId: (json["question_collection_id"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "page_id": pageId,
      "group_id": groupId,
      "dicission_group_id": dicissionGroupId,
      "dicission_question_id": dicissionQuestionId,
      "dicission_type": dicissionType,
      "dicission_value": dicissionValue,
      "group_code": groupCode,
      "group_name": groupName,
      "question_code": questionCode,
      "question_name": questionName,
      "question_label": questionLabel,
      "question_hint": questionHint,
      "question_type": questionType,
      "question_collection_id": questionCollectionId,
    };
  }

  Map<String, dynamic> toInputJson() {
    return {
      "page_id": pageId,
      "group_id": groupId,
      "dicission_group_id": dicissionGroupId,
      "dicission_question_id": dicissionQuestionId,
      "dicission_type": dicissionType,
      "dicission_value": dicissionValue,
    };
  }

  static Future<List<DicissionModel?>> pageDicission({
    required String? token,
    required int? pageId,
    required int? groupId,
  }) {
    return Network.get(
        url: Uri.parse(
          System.data.apiEndPoint.url + System.data.apiEndPoint.pageDicission,
        ),
        otpRequired: null,
        headers: {
          HttpHeaders.authorizationHeader: "$token",
        },
        querys: {
          "id": "${pageId ?? ""}",
          "groupId": "${groupId ?? ""}"
        }).then((value) {
      if (value == null) {
        return <DicissionModel>[];
      } else {
        return (value as List)
            .map((e) => DicissionModel.fromJson((e)))
            .toList();
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<DicissionModel?> add({
    required String? token,
    required DicissionModel? dicissionModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.pageAddDicission,
      ),
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (dicissionModel?.toInputJson() ?? {})..remove("id"),
    ).then((value) {
      return value == null ? null : DicissionModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<DicissionModel?> update({
    required String? token,
    required DicissionModel? dicissionModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.pageUpdateDicission,
      ),
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (dicissionModel?.toInputJson() ?? {})..remove("id"),
    ).then((value) {
      return value == null ? null : DicissionModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<DicissionModel?> delete({
    required String? token,
    required DicissionModel? dicissionModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.pageDeleteDicission,
      ),
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (dicissionModel?.toInputJson() ?? {})..remove("id"),
    ).then((value) {
      return value == null ? null : DicissionModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }
}
