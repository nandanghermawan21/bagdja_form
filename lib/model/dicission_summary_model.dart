import 'dart:io';

import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class DicissionSummaryModel {
  final int? pageId; //": 0,
  final int? groupId; //": 0,
  final String? code; //": "string",
  final String? name; //": "string",
  final int? total; ////": 0

  DicissionSummaryModel({
    this.pageId,
    this.groupId,
    this.code,
    this.name,
    this.total,
  });

  static DicissionSummaryModel fromJson(Map<String, dynamic> json) {
    return DicissionSummaryModel(
      pageId: (json["page_id"] as num?)?.toInt(),
      groupId: (json["group_id"] as num?)?.toInt(),
      code: (json["code"] as String?),
      name: (json["name"] as String?),
      total: (json["total"] as num?)?.toInt(),
    );
  }

  static Future<List<DicissionSummaryModel?>> pageDicission({
    required String? token,
    required int? pageId,
  }) {
    return Network.get(
        url: Uri.parse(
          System.data.apiEndPoint.url +
              System.data.apiEndPoint.pageDicissionSummary,
        ),
        otpRequired: null,
        headers: {
          HttpHeaders.authorizationHeader: "$token",
        },
        querys: {
          "id": "${pageId ?? ""}",
        }).then((value) {
      if (value == null) {
        return <DicissionSummaryModel>[];
      } else {
        return (value as List)
            .map((e) => DicissionSummaryModel.fromJson((e)))
            .toList();
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }
}
