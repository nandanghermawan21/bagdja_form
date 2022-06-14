import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/model/user_model.dart';
import 'package:suzuki/util/enum.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';

class LoginViewMOdel extends ChangeNotifier {
  CircularLoaderController loadingController = CircularLoaderController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login({
    VoidCallback? onLOginSuccess,
  }) {
    loadingController.startLoading();
    UserModel.login(
      username: usernameController.text,
      password: passwordController.text,
    ).then((value) {
      loadingController.forceStop();
      System.data.session!
          .setString(SessionKey.user, json.encode(value?.toJson()));
      System.data.global.user = value;
      System.data.global.token = value?.token ?? "";
      if (onLOginSuccess != null) {
        onLOginSuccess();
      }
    }).catchError((onError) {
      loadingController.stopLoading(
        isError: true,
        message: ErrorHandlingUtil.handleApiError(onError),
      );
    });
  }

  void chekLogedIn({
    VoidCallback? onLOginSuccess,
  }) {
    String userJson = System.data.session!.getString(SessionKey.user) ?? "";
    if (userJson != "") {
      System.data.global.user = UserModel.fromJson(json.decode(userJson));
      System.data.global.token = System.data.global.user?.token;
      if (onLOginSuccess != null) {
        onLOginSuccess();
      }
    }
  }
}
