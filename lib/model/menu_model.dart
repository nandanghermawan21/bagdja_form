import 'package:flutter/material.dart';

class MenuModel {
  String? id;
  VoidCallback? ontap;
  String? title;
  String? iconImage;
  Widget? icon;
  IconData? iconData;
  ValueChanged? onTap;

  MenuModel({
    this.id,
    this.ontap,
    this.iconImage,
    this.icon,
    this.title,
    this.onTap,
    this.iconData,
  });
}
