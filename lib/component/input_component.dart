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
    bool? readOnly = false,
    String? value,
  }) {
    // controller?.text = controller.text == "" ? value ?? "" : "";
    if (controller?.text == "" && value != null) {
      controller?.text = value;
    }
    return TextField(
      controller: controller ?? TextEditingController(),
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly ?? false,
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
    bool? readOnly = false,
    String? value,
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
                  readOnly: readOnly,
                  value: value,
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
                      // height: 100,
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

  static dropDownPopup2withCap<T, T2>({
    String? capTitle,
    T2? value,
    Function(T2)? onSelected,
    required WidgetFromDataBuilder2Param<List<T?>?, T2?>? selectedBuilder,
    required Future<List<T?>?>? dataSource,
    required WidgetFromDataBuilder<T?>? itemBuilder,
    required ObjectBuilderWithParam<T2?, T?>? valueBuilder,
    bool readOnly = false,
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
                  return IntrinsicHeight(
                    child: Container(
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          PopupMenuButton<T2>(
                            onSelected: onSelected,
                            itemBuilder: (context) {
                              return List.generate((s.data?.length ?? 0),
                                  (index) {
                                return PopupMenuItem<T2>(
                                  value: valueBuilder!(s.data?[index]),
                                  child: itemBuilder!(s.data?[index]),
                                );
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              // height: 100,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                        color: Colors.transparent,
                                        alignment: Alignment.centerLeft,
                                        child: selectedBuilder!(
                                            s.data ?? <T>[], value)),
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
                          ),
                          readOnly
                              ? Container(
                                  color: Colors.grey.withOpacity(0.2),
                                )
                              : const SizedBox(),
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
