import 'dart:io';

import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class PageModel {
  final int? id; //": 1,
  final int? formId; //": 1,
  final String? name; //": "PAGE 1",
  final int? order; //": 1

  PageModel({
    this.id,
    this.formId,
    this.name,
    this.order,
  });

  static PageModel fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: (json["id"] as num?)?.toInt(),
      formId: (json["form_id"] as num?)?.toInt(),
      name: (json["name"] as String?),
      order: (json["order"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "form_id": formId,
      "name": name,
      "order": order,
    };
  }

  static Future<List<PageModel?>> formPages({
    required String? token,
    int? id = 1,
  }) {
    return Network.get(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.formPages,
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
        return <PageModel>[];
      } else {
        return (value as List).map((e) => PageModel.fromJson(e)).toList();
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }
}
