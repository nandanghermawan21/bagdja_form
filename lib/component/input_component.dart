import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/util/type.dart';

class InputComponent {
  static inputText({
    TextEditingController? controller,
    String? hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    bool isValid = true,
  }) {
    return TextField(
      controller: controller ?? TextEditingController(),
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: System.data.color!.unselected,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isValid == true
                ? const Color(0xFF000000)
                : System.data.color!.dangerColor,
          ),
        ),
      ),
    );
  }

  static inputTextWithCap({
    TextEditingController? controller,
    String? hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? capTitle,
    bool? isValid = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$capTitle",
              style: System.data.textStyle!.basicLabel,
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Container(
                child: InputComponent.inputText(
                  controller: controller,
                  hint: hint,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  isValid: isValid!,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static dropDownPopupWithCap<T>({
    String? capTitle,
    T? value,
    Function(T)? onSelected,
    WidgetFromDataBuilder<T?>? selectedBuilder,
    required Future<List<T?>?>? dataSource,
    required WidgetFromDataBuilder<T?>? itemBuilder,
    bool isValid = true,
  }) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(5),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$capTitle",
              style: System.data.textStyle!.basicLabel,
            ),
            const SizedBox(
              height: 5,
            ),
            FutureBuilder<List<T?>?>(
              future: dataSource,
              builder: (c, s) {
                if (s.hasData) {
                  return PopupMenuButton<T>(
                    onSelected: onSelected,
                    itemBuilder: (context) {
                      return List.generate((s.data?.length ?? 0), (index) {
                        return PopupMenuItem<T>(
                          value: s.data?[index],
                          child: itemBuilder!(s.data?[index]),
                        );
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: isValid == true
                                ? Colors.black
                                : System.data.color!.dangerColor,
                            width: 0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                                color: Colors.transparent,
                                alignment: Alignment.centerLeft,
                                child: selectedBuilder != null
                                    ? selectedBuilder(value)
                                    : itemBuilder!(value)),
                          ),
                          Container(
                            width: 25,
                            color: Colors.transparent,
                            child: const Center(
                              child: Icon(FontAwesomeIcons.caretDown),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return SkeletonAnimation(
                    child: Container(
                      color: Colors.grey.shade300,
                      height: 50,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
