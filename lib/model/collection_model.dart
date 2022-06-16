import 'dart:io';

import 'package:suzuki/util/network.dart';
import 'package:suzuki/util/system.dart';

class CollectionModel {
  int? id; // 0,
  String? name; // "string"

  CollectionModel({
    this.id,
    this.name,
  });

  static CollectionModel fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: (json["id"] as num?)?.toInt(),
      name: (json["name"] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }

  static Future<List<CollectionModel?>> list({
    required String? token,
    int? id,
  }) {
    return Network.get(
      url: Uri.parse(
        System.data.apiEndPoint.url + System.data.apiEndPoint.collectionListUrl,
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
        return <CollectionModel>[];
      } else {
        return (value as List).map((e) => CollectionModel.fromJson(e)).toList();
      }
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<CollectionModel?> create({
    required String? token,
    required CollectionModel? collectionModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.collectioCreateUrl,
      ),
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (collectionModel?.toJson() ?? {})..remove("id"),
    ).then((value) {
      return value == null ? null : CollectionModel.fromJson((value));
    }).catchError(
      (onError) {
        throw onError;
      },
    );
  }

  static Future<CollectionModel?> update({
    required String? token,
    required int? id,
    required CollectionModel? collectionModel,
  }) {
    return Network.post(
      url: Uri.parse(
        System.data.apiEndPoint.url +
            System.data.apiEndPoint.collectioupdateUrl,
      ),
      querys: {"id": "${id ?? ""}"},
      headers: {
        HttpHeaders.authorizationHeader: "$token",
      },
      otpRequired: null,
      body: (collectionModel?.toJson() ?? {})..remove("id"),
    ).then((value) {
      return value == null ? null : CollectionModel.fromJson((value));
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
            System.data.apiEndPoint.collectioDeleteUrl,
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
