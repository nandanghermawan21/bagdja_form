import 'dart:io';

import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class PageQuestionModel {
  int? pageId; //": 0,
  int? groupId; //": 0,
  int? order; //": 0,
  String? code; //": "string",
  String? name; //": "string"

  PageQuestionModel({
    this.pageId,
    this.groupId,
    this.order,
    this.code,
    this.name,
  });

  static PageQuestionModel fromJson(Map<String, dynamic> json) {
    return PageQuestionModel(
      pageId: (json["page_id"] as num?)?.toInt(),
      groupId: (json["group_id"] as num?)?.toInt(),
      order: (json["order"] as num?)?.toInt(),
      code: (json["code"] as String?),
      name: (json["name"] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "page_id": pageId,
      "group_id": groupId,
      "order": order,
      "code": code,
      "name": name,
    };
  }

  Map<String, dynamic> toJsonInput() {
    return {
      "page_id": pageId,
      "group_id": groupId,
      "order": order,
    };
  }

  static Future<List<PageQuestionModel?>> list({
    required String? token,
    int? pageId,
  }) {
    return Network.get(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.pageQuestions,
      ),
      querys: {
        "id": "${pageId ?? 0}",
      },
      otpRequired: null,
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
    ).then((value) {
      if (value == null) {
        return <PageQuestionModel>[];
      } else {
        return (value as List)
            .map((e) => PageQuestionModel.fromJson(e))
            .toList();
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<PageQuestionModel?> add({
    required String? token,
    required PageQuestionModel? pageQUestionModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.pageAddQuestion,
      ),
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (pageQUestionModel?.toJsonInput() ?? {})..remove("id"),
    ).then((value) {
      return value == null ? null : PageQuestionModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<PageQuestionModel?> update({
    required String? token,
    required int? id,
    required int? groupId,
    required PageQuestionModel? questionListModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.pageUpdateQuestion,
      ),
      querys: {
        "id": "${id ?? ""}",
        "groupId": "${groupId ?? ""}",
      },
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (questionListModel?.toJsonInput() ?? {}),
    ).then((value) {
      return value == null ? null : PageQuestionModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<PageQuestionModel?> delete({
    required String? token,
    int? pageId,
    int? groupId,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.pageDeleteQuestion,
      ),
      querys: {
        "id": "${pageId ?? 0}",
        "groupId": "${groupId ?? 0}",
      },
      otpRequired: null,
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
    ).then((value) {
      if (value == null) {
        return null;
      } else {
        return PageQuestionModel.fromJson(value);
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }
}
