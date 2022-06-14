import 'dart:io';

import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class QuestionTypesModel {
  final String? code; //": "checkbox",
  final String? name; //": "CHECKBOX"

  QuestionTypesModel({
    this.code,
    this.name,
  });

  static QuestionTypesModel fromJson(Map<String, dynamic> json) {
    return QuestionTypesModel(
      code: json["code"] as String?,
      name: json["name"] as String?,
    );
  }

  Map<String, dynamic> toJsom() {
    return {
      "code": code,
      "name": name,
    };
  }

  static Future<List<QuestionTypesModel?>> list({
    required String? token,
  }) {
    return Network.get(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.questionTypesUrl,
      ),
      otpRequired: null,
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
    ).then((value) {
      if (value == null) {
        return <QuestionTypesModel>[];
      } else {
        return (value as List)
            .map((e) => QuestionTypesModel.fromJson((e)))
            .toList();
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }
}
