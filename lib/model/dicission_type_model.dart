import 'dart:io';

import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class DicissionTypeModel {
  final int? id; //": 7,
  final String? name; //": "IN",
  final String? symbol; //": "{IN}"

  DicissionTypeModel({
    this.id,
    this.name,
    this.symbol,
  });

  static DicissionTypeModel fromJson(Map<String, dynamic> json) {
    return DicissionTypeModel(
      id: (json["id"] as num?)?.toInt(),
      name: (json["name"] as String?),
      symbol: (json["symbol"] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "symbol": symbol,
    };
  }

  static Future<List<DicissionTypeModel?>> list({
    required String? token,
  }) {
    return Network.get(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.dicissionTypes,
      ),
      otpRequired: null,
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
    ).then((value) {
      if (value == null) {
        return <DicissionTypeModel>[];
      } else {
        return (value as List)
            .map((e) => DicissionTypeModel.fromJson((e)))
            .toList();
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }
}
