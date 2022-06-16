import 'dart:io';

import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class CollectionDataModel {
  int? collectionId; //": 0,
  String? value; //": "string",
  String? label; //": "string"

  CollectionDataModel({
    this.collectionId,
    this.value,
    this.label,
  });

  static CollectionDataModel fromJson(Map<String, dynamic> json) {
    return CollectionDataModel(
      collectionId: (json["collection_id"] as int?)?.toInt(),
      value: (json["value"] as String?),
      label: (json["label"] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "collection_id": collectionId,
      "value": value,
      "label": label,
    };
  }

  static Future<List<CollectionDataModel?>> list({
    required String? token,
    required int? collectionId,
  }) {
    return Network.get(
      url: Uri.parse(System.data.apiEndPoint.url +
          System.data.apiEndPoint.collectionDataUrl),
      querys: {
        "id": "${collectionId ?? ""}",
      },
      otpRequired: null,
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
    ).then((value) {
      if (value == null) {
        return <CollectionDataModel>[];
      } else {
        return (value as List)
            .map((e) => CollectionDataModel.fromJson(e))
            .toList();
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }
}
