import 'dart:io';

import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class PageModel {
  int? id; //": 1,
  int? formId; //": 1,
  String? name; //": "PAGE 1",
  int? order; //": 1

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

  Map<String, dynamic> toInputJson() {
    return {
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

  static Future<PageModel?> add({
    required String? token,
    required PageModel? pageModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.pageCreate,
      ),
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (pageModel?.toInputJson() ?? {})..remove("id"),
    ).then((value) {
      return value == null ? null : PageModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<PageModel?> update({
    required String? token,
    required int? id,
    required PageModel? pageModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.pageUpdate,
      ),
      querys: {
        "id": "$id",
      },
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (pageModel?.toInputJson() ?? {})..remove("id"),
    ).then((value) {
      return value == null ? null : PageModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<PageModel?> delete({
    required String? token,
    int? pageId,
  }) {
    return Network.get(
      url: Uri.parse(
          System.data.apiEndPoint.url + System.data.apiEndPoint.pageDelete),
      querys: {
        "id": "${pageId ?? 0}",
      },
      otpRequired: null,
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
    ).then((value) {
      if (value == null) {
        return null;
      } else {
        return PageModel.fromJson(value);
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }
}
