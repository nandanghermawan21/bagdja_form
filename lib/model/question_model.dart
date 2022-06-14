import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class QuestionModel {
  final int? id; //": 1,
  final String? code; //": "0001",
  final String? name; //": null,
  final String? label; //": "Nama",
  final String? hint; //": "Nama",
  final String? type; //": "text",
  final int? collectionId; //": null

  QuestionModel({
    this.id,
    this.code,
    this.name,
    this.label,
    this.hint,
    this.type,
    this.collectionId,
  });

  static QuestionModel fronJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: (json["id"] as num?)?.toInt(),
      code: (json["code"] as String?),
      name: (json["name"] as String?),
      label: (json["label"] as String?),
      hint: (json["hint"] as String?),
      type: (json["type"] as String?),
      collectionId: (json["collection_id"] as num?)?.toInt(),
    );
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
        HttpHeaders.authorizationHeader: "bearer $token",
      },
      otpRequired: null,
      body: questionModel?.toJson() ?? {},
    ).then((value) {
      return value == null ? null : QuestionModel.fronJson(json.decode(value));
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
}
