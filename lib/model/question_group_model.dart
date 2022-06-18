import 'dart:io';

import 'package:suzuki/model/collection_model.dart';
import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class QuestionGroupModel {
  final int? id; //": 2,
  final String? code; //": "G0001",
  final String? name;

  QuestionGroupModel({
    this.id,
    this.code,
    this.name,
  }); //": "Informas Pemohon"

  static QuestionGroupModel fromJson(Map<String, dynamic> json) {
    return QuestionGroupModel(
      id: (json["id"] as int?)?.toInt(),
      code: (json["code"] as String?),
      name: (json["name"] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "code": code,
      "name": name,
    };
  }

  static Future<List<QuestionGroupModel?>> list({
    required String? token,
    int? id,
  }) {
    return Network.get(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.questionGroupListUrl,
      ),
      querys: {
        "id": "${id ?? ""}",
      },
      otpRequired: null,
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
    ).then((value) {
      if (value == null) {
        return <QuestionGroupModel>[];
      } else {
        return (value as List)
            .map((e) => QuestionGroupModel.fromJson(e))
            .toList();
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<QuestionGroupModel?> create({
    required String? token,
    required QuestionGroupModel? questionGroupModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.questionGroupCreateUrl,
      ),
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (questionGroupModel?.toJson() ?? {})..remove("id"),
    ).then((value) {
      return value == null ? null : QuestionGroupModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<QuestionGroupModel?> update({
    required String? token,
    required int? id,
    required QuestionGroupModel? questionGroupModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.questionGroupUpdateUrl,
      ),
      querys: {"id": "${id ?? ""}"},
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (questionGroupModel?.toJson() ?? {})..remove("id"),
    ).then((value) {
      return value == null ? null : QuestionGroupModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<CollectionModel?> delete({
    required String? token,
    int? id,
  }) {
    return Network.get(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.questionGroupDeleteUrl,
      ),
      querys: {
        "id": "${id ?? ""}",
      },
      otpRequired: null,
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
    ).then((value) {
      return value == null ? null : CollectionModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }
}
