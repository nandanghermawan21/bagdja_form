import 'package:flutter/material.dart';
import 'package:suzuki/model/menu_model.dart';

class MainMenuViewModel extends ChangeNotifier {
  bool menuIsOpen = false;
  MenuModel? selectedMenu;

  void setSelectedMenu(MenuModel menu) {
    selectedMenu = menu;
    commit();
  }

  void commit() {
    notifyListeners();
  }
}
