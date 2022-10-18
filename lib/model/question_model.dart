import 'dart:io';

import 'package:flutter/material.dart';
import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class QuestionModel {
  int? id; //": 1,
  String? code; //": "0001",
  String? name; //": null,
  String? label; //": "Nama",
  String? hint; //": "Nama",
  String? type; //": "text",
  int? collectionId; //": null
  String? imageResolution;
  bool? readObly;

  QuestionModel({
    this.id,
    this.code,
    this.name,
    this.label,
    this.hint,
    this.type,
    this.collectionId,
    this.imageResolution,
    this.readObly,
  });

  static QuestionModel fronJson(
    Map<String, dynamic> json, {
    int? id,
  }) {
    var data = QuestionModel(
      id: (json["id"] as num?)?.toInt(),
      code: (json["code"] as String?),
      name: (json["name"] as String?),
      label: (json["label"] as String?),
      hint: (json["hint"] as String?),
      type: (json["type"] as String?),
      collectionId: (json["collection_id"] as num?)?.toInt(),
      imageResolution: (json["image_resolution"] as String?),
      readObly: ((json["read_only"] as num?)?.toInt() ?? 0) == 0 ? false : true,
    );

    if (id != null) {
      data.id = id;
    }

    return data;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "code": code,
      "name": name,
      "label": label,
      "hint": hint,
      "type": type,
      "collection_id": collectionId,
      'image_resolution': imageResolution,
      'read_only': readObly == true ? 1 : 0,
    };
  }

  static Future<List<QuestionModel?>> list({
    required String? token,
  }) {
    debugPrint("token $token");
    return Network.get(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.questionListUrl,
      ),
      otpRequired: null,
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
    ).then((value) {
      if (value == null) {
        return <QuestionModel>[];
      } else {
        return (value as List).map((e) => QuestionModel.fronJson(e)).toList();
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<QuestionModel?> add({
    required String? token,
    required QuestionModel? questionModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.questionAddUrl,
      ),
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (questionModel?.toJson() ?? {})..remove("id"),
    ).then((value) {
      return value == null ? null : QuestionModel.fronJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<QuestionModel?> delete({
    required String? token,
    required int? id,
  }) {
    return Network.get(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.questionDeleteUrl,
      ),
      querys: {
        "id": "${id ?? ""}",
      },
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
    ).then((value) {
      return value == null ? null : QuestionModel.fronJson(value);
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<QuestionModel?> update({
    required String? token,
    required int? id,
    required QuestionModel? questionModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.questionUpdateUrl,
      ),
      querys: {"id": "${id ?? ""}"},
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (questionModel?.toJson() ?? {})..remove("id"),
    ).then((value) {
      return value == null ? null : QuestionModel.fronJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }
}

class QuestionTypes {
  static const String checkbox = "checkbox";
  static const String decimal = "decimal";
  static const String dropdown = "dropdown";
  static const String foto = "foto";
  static const String locationpicker = "locationpicker";
  static const String number = "number";
  static const String positiontag = "positiontag";
  static const String text = "text";
  static const String video = "video";
  static const String phone = "phone";
  static const String date = "date";
  static const String digit = "digit";

  static bool needCollectionData(String code) {
    switch (code) {
      case QuestionTypes.dropdown:
      case QuestionTypes.checkbox:
        return true;
      default:
        return false;
    }
  }
}
