import 'package:flutter/material.dart';

class MenuModel {
  String? id;
  VoidCallback? onTap;
  String? title;
  String? iconImage;
  Widget? icon;
  IconData? iconData;
  Color? color;

  MenuModel({
    this.id,
    this.onTap,
    this.iconImage,
    this.icon,
    this.title,
    this.iconData,
    this.color,
  });
}
