import 'dart:io';

import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class FormModel {
  int? id; //": 1,
  String? code; //": "FOOO1",
  String? name; //": "ORDER IN"

  FormModel({
    this.id,
    this.code,
    this.name,
  });

  static FormModel fromJson(Map<String, dynamic> json) {
    return FormModel(
      id: (json["id"] as num?)?.toInt(),
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

  static Future<List<FormModel?>> formOfApplication({
    required String? token,
    int? id = 201,
  }) {
    return Network.get(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.formOfApplications,
      ),
      querys: {
        "id": "$id",
      },
      otpRequired: null,
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
    ).then((value) {
      if (value == null) {
        return <FormModel>[];
      } else {
        return (value as List).map((e) => FormModel.fromJson(e)).toList();
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }
}
