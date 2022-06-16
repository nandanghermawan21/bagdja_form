import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/util/type.dart';

class ListDataComponent<T> extends StatelessWidget {
  final ListDataComponentController<T>? controller;
  final WidgetFromDataBuilder2Param<T?, int>? itemBuilder;
  final FutureObjectBuilderWith2Param<List<T>, int, String?>? dataSource;
  final ValueChanged2Param<List<T>, String?>? onDateReceived;
  final bool showSearchBox;
  final String? seachHist;
  final ListDataComponentMode listViewMOde;

  const ListDataComponent(
      {Key? key,
      this.controller,
      this.itemBuilder,
      this.dataSource,
      this.onDateReceived,
      this.showSearchBox = false,
      this.seachHist,
      this.listViewMOde = ListDataComponentMode.listView})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    if (controller?.value.state == ListDataComponentState.firstLoad) {
      controller?.value.dataSource = dataSource;
      controller?.value.onDateReceived = onDateReceived;
      controller?.refresh();
    }
    return Container(
      color: Colors.transparent,
      child: ValueListenableBuilder<ListDataComponentValue<T>>(
        valueListenable: controller!,
        builder: (BuildContext context, value, Widget? child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showSearchBox ? searchBox() : const SizedBox(),
              listViewMOde == ListDataComponentMode.listView
                  ? Expanded(child: childBuilder())
                  : childBuilder(),
            ],
          );
        },
      ),
    );
  }

  Widget searchBox() {
    return Container(
      height: 50,
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade400,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              height: 50,
              color: Colors.transparent,
              child: Material(
                child: TextField(
                  controller: controller?.value.searchController,
                  onChanged: (val) {
                    controller?.refresh();
                  },
                  textCapitalization: TextCapitalization.characters,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.only(left: 15, right: 15),
                      hintText: seachHist ?? System.data.strings!.search,
                      hintStyle: System.data.textStyle!.boldTitleLabel),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.search,
                color: System.data.color!.darkTextColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget childBuilder() {
    switch (controller?.value.state) {
      case ListDataComponentState.firstLoad:
        return SingleChildScrollView(
          controller: controller?.value.scrollController,
          child: Column(
            children: List.generate(
              5,
              (index) {
                return loader();
              },
            ),
          ),
        );
      case ListDataComponentState.errorLoaded:
        return GestureDetector(
          onTap: controller?.refresh,
          child: errorLoaded(),
        );
      default:
        return (controller?.value.data.length ?? 0) > 0 ||
                (controller?.value.state == ListDataComponentState.loading)
            ? listMode()
            : GestureDetector(
                onTap: controller?.refresh,
                child: emptyData(),
              );
    }
  }

  Widget listMode() {
    switch (listViewMOde) {
      case ListDataComponentMode.column:
        return columnMode();
      default:
        return listViewMode();
    }
  }

  Widget columnMode() {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Column(
            children: List.generate(
              (controller?.value.data.length ?? 0) +
                  (controller?.value.state == ListDataComponentState.loading
                      ? 5
                      : 0),
              (index) {
                if (itemBuilder != null) {
                  if (index < (controller?.value.data.length ?? -1)) {
                    return itemBuilder!(controller?.value.data[index], index);
                  } else {
                    return loader();
                  }
                } else {
                  return emptyItem();
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                controller?.getOther();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    System.data.strings!.showMore,
                  ),
                  const Icon(
                    FontAwesomeIcons.chevronDown,
                    size: 15,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listViewMode() {
    return NotificationListener(
      onNotification: (n) {
        if (n is ScrollEndNotification) {
          var current = controller?.value.scrollController.position.pixels;
          var min = controller?.value.scrollController.position.minScrollExtent;
          var max = controller?.value.scrollController.position.maxScrollExtent;
          if (controller?.value.scrollController.position.userScrollDirection ==
                  ScrollDirection.forward &&
              ((current ?? 0) <= (min ?? 0))) {
            controller?.refresh();
          } else if (controller
                      ?.value.scrollController.position.userScrollDirection ==
                  ScrollDirection.reverse &&
              ((current ?? 0) >= (max ?? 0))) {
            controller?.getOther();
          }
        }
        return true;
      },
      child: ListView(
        controller: controller?.value.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: List.generate(
          (controller?.value.data.length ?? 0) +
              (controller?.value.state == ListDataComponentState.loading
                  ? 5
                  : 0),
          (index) {
            if (itemBuilder != null) {
              if (index < (controller?.value.data.length ?? -1)) {
                return itemBuilder!(controller?.value.data[index], index);
              } else {
                return loader();
              }
            } else {
              return emptyItem();
            }
          },
        ),
      ),
    );
  }

  Widget loader() {
    return SkeletonAnimation(
      child: itemBuilder != null ? itemBuilder!(null, 0) : emptyItem(),
    );
  }

  Widget emptyItem() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 5, top: 5),
      color: Colors.green,
    );
  }

  Widget errorLoaded() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.exclamationTriangle,
            color: System.data.color!.dangerColor,
            size: 50,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            controller?.value.errorMessage ?? "",
            style: System.data.textStyle!.boldTitleDangerLabel,
          )
        ],
      ),
    );
  }

  Widget emptyData() {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FontAwesomeIcons.database,
            size: 50,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "tidak ada data",
            style: System.data.textStyle!.basicLabel,
          )
        ],
      ),
    );
  }
}

class ListDataComponentController<T>
    extends ValueNotifier<ListDataComponentValue<T>> {
  ListDataComponentController({ListDataComponentValue<T>? value})
      : super(value ?? ListDataComponentValue<T>());

  void addAll(List<T> datas) {
    value.data.addAll(datas);
    commit();
  }

  void refresh() {
    value.state = ListDataComponentState.loading;
    commit();
    if (value.dataSource == null) {
      value.state = ListDataComponentState.loaded;
      commit();
      return;
    }
    value.dataSource!(0, value.searchController.text).then((datas) {
      value.data = (datas);
      if (value.onDateReceived != null) {
        value.onDateReceived!(datas, value.searchController.text);
      }
      value.state = ListDataComponentState.loaded;
      commit();
    }).catchError(
      (onError) {
        value.state = ListDataComponentState.errorLoaded;
        value.errorMessage = ErrorHandlingUtil.handleApiError(onError);
        commit();
      },
    );
  }

  void getOther() {
    double _latPosition = 0;
    try {
      _latPosition = value.scrollController.position.pixels;
    } catch (e) {
      debugPrint("");
    }
    value.state = ListDataComponentState.loading;
    commit();
    if (value.dataSource == null) {
      value.state = ListDataComponentState.loaded;
      commit();
      return;
    }
    value.dataSource!(total, value.searchController.text).then((datas) {
      value.data.addAll(datas);
      if (value.onDateReceived != null) {
        value.onDateReceived!(datas, value.searchController.text);
      }
      value.state = ListDataComponentState.loaded;
      commit();
      try {
        value.scrollController.jumpTo(_latPosition);
      } catch (e) {
        debugPrint("");
      }
    }).catchError(
      (onError) {
        value.state = ListDataComponentState.errorLoaded;
        value.errorMessage = ErrorHandlingUtil.handleApiError(onError);
        commit();
      },
    );
  }

  int get total {
    return value.data.length;
  }

  void commit() {
    notifyListeners();
  }
}

class ListDataComponentValue<T> {
  List<T> data = [];
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  int totalAllData = 0;
  ListDataComponentState state = ListDataComponentState.firstLoad;
  FutureObjectBuilderWith2Param<List<T>, int, String?>? dataSource;
  ValueChanged2Param<List<T>, String?>? onDateReceived;
  String? errorMessage;
}

enum ListDataComponentState {
  firstLoad,
  loading,
  loaded,
  errorLoaded,
}

enum ListDataComponentMode {
  listView,
  column,
  listWidget,
}
