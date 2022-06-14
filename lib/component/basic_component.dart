import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suzuki/util/system.dart';

class BasicComponent {
  static AppBar appBar({
    BuildContext? context,
    List<Widget>? actions,
    String? title,
  }) {
    return AppBar(
      backgroundColor: System.data.color!.primaryColor,
      title: Text(
        title ?? "Title",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: System.data.font!.xxxl,
          fontFamily: System.data.font!.primary,
        ),
      ),
      actions: actions,
      centerTitle: true,
      leading: Builder(
        builder: (BuildContext context) {
          if (Scaffold.of(context).hasDrawer) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          } else if (Navigator.of(context).canPop()) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  static Widget avatar({
    double? size,
    VoidCallback? onTap,
    String? imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: System.data.color!.link,
          border: Border.all(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(50))),
      height: size ?? 80,
      width: size ?? 80,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          child: Image.network(
            imageUrl ?? "",
            fit: BoxFit.fitHeight,
            errorBuilder: (bb, o, st) => Container(
              color: Colors.transparent,
              child: Image.asset("assets/avatar.png"),
            ),
          ),
        ),
      ),
    );
  }

  static Widget logoHorizontal() {
    return SvgPicture.asset(
      "assets/kogo_suzuki_mobile_survey_horizontal.svg",
    );
  }
}