import 'package:flutter/material.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view/login_view.dart';
import 'package:suzuki/view/main_menu.dart';
import 'package:unicons/unicons.dart';
import 'package:suzuki/view/under_construction_view.dart';

String initialRouteName = RouteName.login;

class RouteName {
  static const String login = "login";
  static const String mainMenu = "mainmenu";
  static const String dashboard = "dashboard";
  static const String form = "form";
  static const String datacollection = "datacollection";
  static const String user = "user";
}

enum ParamName {
  newsModel,
  customerModel,
}

Map<String, WidgetBuilder> route = {
  RouteName.login: (BuildContext context) {
    return LoginView(
      urlPlayStore: "https://form.bagdja.com/apk-release/",
      onLoginSuccess: () {
        Navigator.of(context).pushReplacementNamed(RouteName.mainMenu);
      },
    );
  },
  RouteName.mainMenu: (BuildContext context) {
    return MainMenuView(
      drawerMenus: [
        MenuModel(
          id: RouteName.dashboard,
          iconData: UniconsLine.dashboard,
          title: System.data.strings!.dashboard,
        ),
        MenuModel(
          id: RouteName.form,
          iconData: UniconsLine.file,
          title: System.data.strings!.form,
        ),
        MenuModel(
          id: RouteName.datacollection,
          iconData: UniconsLine.database,
          title: System.data.strings!.dataCollection,
        ),
        MenuModel(
          id: RouteName.user,
          iconData: UniconsLine.user,
          title: System.data.strings!.user,
        ),
      ],
      onCreateBody: (menu) {
        return UnderConstructionView();
      },
    );
  }
};
