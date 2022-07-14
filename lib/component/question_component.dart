import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/model/question_group_model.dart';
import 'package:suzuki/model/question_model.dart';
import 'package:suzuki/model/question_types_model.dart';
import 'package:suzuki/util/system.dart';

class QuestionComponent {
  static questionItem(
    QuestionModel? data, {
    bool showDelete = true,
    ValueChanged<QuestionModel?>? onTapDelete,
    bool showEdit = true,
    ValueChanged<QuestionModel?>? onTapEdit,
    bool showBorder = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 1),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: showBorder != true
            ? null
            : Border.all(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 0.5,
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.transparent,
            width: 50,
            child: Center(
              child: getIconWidget(data?.type ?? ""),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Text(
                "${data?.code ?? ""} ${data?.label ?? ""}",
                style: System.data.textStyle!.basicLabel,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              showDelete != true
                  ? const SizedBox()
                  : Container(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          onTapDelete!(data);
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ),
              showEdit != true
                  ? const SizedBox()
                  : Container(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          onTapEdit!(data);
                        },
                        child: const Icon(Icons.edit),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  static questionGroupItem(
    QuestionGroupModel? data, {
    bool showEditButton = true,
    bool showDeleteButton = true,
    bool showExpanButton = false,
    ValueChanged<QuestionGroupModel?>? onTapDelete,
    ValueChanged<QuestionGroupModel?>? onTapEdit,
    bool showBorder = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: showBorder != true
            ? null
            : Border.all(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 0.5,
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          showExpanButton == true
              ? Container(
                  width: 20,
                  color: Colors.transparent,
                  child: const Icon(
                    FontAwesomeIcons.chevronDown,
                    size: 10,
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Text(
                "${data?.code ?? ""} ${data?.name ?? ""}",
                style: System.data.textStyle!.basicLabel,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
            width: 50,
            height: 30,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                !showDeleteButton
                    ? const SizedBox()
                    : Container(
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () {
                            onTapDelete!(data);
                          },
                          child: const Icon(Icons.delete),
                        ),
                      ),
                !showEditButton
                    ? const SizedBox()
                    : Container(
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () {
                            onTapEdit!(data);
                          },
                          child: const Icon(Icons.edit),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static iconQuestionType({
    String? text,
    IconData? iconData,
    Color? color,
  }) {
    return Container(
      height: 25,
      width: 40,
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color ?? Colors.green,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: iconData != null
          ? Icon(
              iconData,
              color: Colors.white,
              size: 15,
            )
          : Text(
              text ?? "TXT",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  // static const String checkbox = "checkbox";
  // static const String decimal = "decimal";
  // static const String dropdown = "dropdown";
  // static const String foto = "foto";
  // static const String locationpicker = "locationpicker";
  // static const String number = "number";
  // static const String positiontag = "positiontag";
  // static const String text = "text";
  // static const String video = "video";

  static Widget getIconWidget(String types) {
    switch (types) {
      case QuestionTypes.checkbox:
        return iconQuestionType(
          text: "TXT",
          color: Colors.purple,
          iconData: Icons.check_box,
        );
      case QuestionTypes.decimal:
        return iconQuestionType(
          text: "DEC",
          color: Colors.cyan,
        );
      case QuestionTypes.number:
        return iconQuestionType(
          text: "NUM",
          color: Colors.blueGrey,
        );
      case QuestionTypes.dropdown:
        return iconQuestionType(
          color: Colors.orange,
          iconData: FontAwesomeIcons.caretDown,
        );
      case QuestionTypes.foto:
        return iconQuestionType(
          color: Colors.teal,
          iconData: FontAwesomeIcons.camera,
        );
      case QuestionTypes.locationpicker:
        return iconQuestionType(
          color: Colors.green,
          iconData: FontAwesomeIcons.mapMarkerAlt,
        );
      case QuestionTypes.positiontag:
        return iconQuestionType(
          color: Colors.purple,
          iconData: Icons.my_location,
        );
      case QuestionTypes.video:
        return iconQuestionType(
          color: Colors.deepPurple,
          iconData: Icons.video_camera_back,
        );
      case QuestionTypes.text:
        return iconQuestionType(
          text: "TXT",
          color: Colors.pink,
        );
      case QuestionTypes.phone:
        return iconQuestionType(
          text: "PHN",
          iconData: FontAwesomeIcons.phone,
          color: Colors.pink,
        );
      default:
        return iconQuestionType(
          text: "???",
          color: Colors.redAccent,
        );
    }
  }

  static Future<QuestionTypesModel?> questionTypeSelector({
    required BuildContext context,
    double? width,
    ValueChanged<QuestionTypesModel?>? onSelected,
  }) {
    ListDataComponentController<QuestionTypesModel?> listController =
        ListDataComponentController<QuestionTypesModel?>();
    return showDialog<QuestionTypesModel?>(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            color: Colors.white,
            width: width ??
                ((MediaQuery.of(context).size.width * 80 / 100) > 200
                    ? 200
                    : (MediaQuery.of(context).size.width * 80 / 100)),
            height: width ?? MediaQuery.of(context).size.height * 80 / 100,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: ListDataComponent<QuestionTypesModel?>(
                      controller: listController,
                      showSearchBox: false,
                      dataSource: (skiip, searchKey) {
                        return QuestionTypesModel.list(
                            token: System.data.global.token);
                      },
                      itemBuilder: (clientModel, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(clientModel);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 5, top: 5),
                            decoration: BoxDecoration(
                              color: System.data.color!.lightBackground,
                              border: const Border(
                                bottom: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 0.5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clientModel?.code ?? "-",
                                  style: System.data.textStyle!.boldTitleLabel,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  clientModel?.name ?? "-",
                                  style: System.data.textStyle!.boldTitleLabel,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (onSelected != null) {
        onSelected(value);
      }
      return value;
    });
  }

  static Future<QuestionTypesModel?> dropDownMenuQuestionType({
    required BuildContext context,
    required RelativeRect position,
    ValueChanged<QuestionTypesModel?>? onSelected,
  }) async {
    var data = await QuestionTypesModel.list(token: System.data.global.token);
    return showMenu<QuestionTypesModel?>(
      context: context,
      position: position,
      useRootNavigator: true,
      items: List.generate(data.length + 1, (index) {
        return PopupMenuItem(
          child: index == 0
              ? Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  width: double.infinity,
                  child: Text(
                    System.data.strings!.selectQuestionType,
                    style: System.data.textStyle!.boldTitleLabel,
                  ),
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 10, top: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: index == data.length
                            ? Colors.transparent
                            : Colors.grey,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[index - 1]?.code ?? "",
                        style: System.data.textStyle!.basicLabel,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        data[index - 1]?.name ?? "",
                        style: System.data.textStyle!.basicLabel,
                      ),
                    ],
                  ),
                ),
          value: index == 0 ? null : data[index - 1],
        );
      }),
    ).then((value) {
      if (onSelected != null) {
        onSelected(value);
      }
      return value;
    });
  }
}
