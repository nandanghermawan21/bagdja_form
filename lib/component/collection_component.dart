import 'package:flutter/material.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/model/collection_model.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/util/system.dart';

class CollectionComponent {
  static Future<CollectionModel?> collectionSelector({
    required BuildContext context,
    double? width,
    ValueChanged<CollectionModel?>? onSelected,
  }) {
    ListDataComponentController<CollectionModel?> listController =
        ListDataComponentController<CollectionModel?>();
    return showDialog<CollectionModel?>(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            color: Colors.white,
            width: width ??
                ((MediaQuery.of(context).size.width * 80 / 100) > 400
                    ? 400
                    : (MediaQuery.of(context).size.width * 80 / 100)),
            height: width ?? MediaQuery.of(context).size.height * 80 / 100,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: ListDataComponent<CollectionModel?>(
                      controller: listController,
                      showSearchBox: true,
                      seachHist: "Search Collection",
                      dataSource: (skiip, searchKey) {
                        return CollectionModel.list(
                            token: System.data.global.token);
                      },
                      itemBuilder: (data, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(data);
                          },
                          child: collectionItem(data),
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

  static Widget collectionItem(
    CollectionModel? data, {
    List<MenuModel> action = const [],
  }) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${data?.id ?? ""} ${data?.name ?? ""}",
            style: System.data.textStyle!.boldTitleLabel,
          ),
          Row(
            children: List.generate(action.length, (index) {
              return Container(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: action[index].onTap,
                  child: Icon(action[index].iconData),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
