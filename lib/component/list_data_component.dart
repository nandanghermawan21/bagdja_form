import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:suzuki/util/error_handling_util.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/util/type.dart';

class ListDataComponent<T> extends StatelessWidget {
  final ListDataComponentController<T>? controller;
  final WidgetFromDataBuilder2Param<T?, int>? itemBuilder;
  final Widget? emptyWidget;
  final FutureObjectBuilderWith2Param<List<T>, int, String?>? dataSource;
  final ValueChanged2Param<List<T>, String?>? onDataReceived;
  final bool showSearchBox;
  final String? seachHist;
  final ListDataComponentMode listViewMode;
  final Widget? header;
  final ValueChanged<T?>? onSelected;
  final bool enableGetMore;
  final ObjectBuilderWith2Param<bool, T, int>? onWillReceiveDropedData;
  final ValueChanged2Param<T, int>? onReceiveDropedData;
  final WidgetFromDataBuilder2Param<T?, int>? dragFeedbackBuilder;
  final ObjectBuilderWith2Param<Object, T?, int>? dragDataBuilder;

  const ListDataComponent({
    Key? key,
    this.controller,
    this.itemBuilder,
    this.dataSource,
    this.onDataReceived,
    this.showSearchBox = false,
    this.seachHist,
    this.listViewMode = ListDataComponentMode.listView,
    this.header,
    this.onSelected,
    this.emptyWidget,
    this.enableGetMore = true,
    this.onReceiveDropedData,
    this.onWillReceiveDropedData,
    this.dragFeedbackBuilder,
    this.dragDataBuilder,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    if (controller?.value.state == ListDataComponentState.firstLoad) {
      controller?.value.dataSource = dataSource;
      controller?.value.onDataReceived = onDataReceived;
      controller?.value.onSelected = onSelected;
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
              header != null ? header! : const SizedBox(),
              showSearchBox ? searchBox() : const SizedBox(),
              [ListDataComponentMode.listView, ListDataComponentMode.tile]
                      .contains(listViewMode)
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
            ? listModeBuilder()
            : GestureDetector(
                onTap: controller?.refresh,
                child: emptyData(),
              );
    }
  }

  Widget listModeBuilder() {
    switch (listViewMode) {
      case ListDataComponentMode.column:
        return columnMode();
      case ListDataComponentMode.tile:
        return tilewMode();
      default:
        return listMode();
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
                    return GestureDetector(
                      onTap: () {
                        controller?.value.selected =
                            controller?.value.data[index];
                        controller?.commit();
                        if (onSelected != null) {
                          onSelected!(controller?.value.data[index]);
                        }
                      },
                      child: item(controller?.value.data[index], index),
                    );
                  } else {
                    return loader();
                  }
                } else {
                  return emptyItem();
                }
              },
            ),
          ),
          enableGetMore != true
              ? const SizedBox()
              : Container(
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

  Widget tilewMode() {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: NotificationListener(
        onNotification: (n) {
          if (n is ScrollEndNotification) {
            var current = controller?.value.scrollController.position.pixels;
            var min =
                controller?.value.scrollController.position.minScrollExtent;
            var max =
                controller?.value.scrollController.position.maxScrollExtent;
            if (controller
                        ?.value.scrollController.position.userScrollDirection ==
                    ScrollDirection.forward &&
                ((current ?? 0) <= (min ?? 0))) {
              controller?.refresh();
            } else if (controller
                        ?.value.scrollController.position.userScrollDirection ==
                    ScrollDirection.reverse &&
                ((current ?? 0) >= (max ?? 0))) {
              if (enableGetMore == true) controller?.getOther();
            }
          }
          return true;
        },
        child: SingleChildScrollView(
          controller: controller?.value.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Wrap(
            children: List.generate(
              (controller?.value.data.length ?? 0) +
                  (controller?.value.state == ListDataComponentState.loading
                      ? 5
                      : 0),
              (index) {
                if (itemBuilder != null) {
                  if (index < (controller?.value.data.length ?? -1)) {
                    return GestureDetector(
                      onTap: () {
                        controller?.value.selected =
                            controller?.value.data[index];
                        controller?.commit();
                        if (onSelected != null) {
                          onSelected!(controller?.value.data[index]);
                        }
                      },
                      child: IntrinsicWidth(
                        child: Container(
                          child: item(controller?.value.data[index], index),
                        ),
                      ),
                    );
                  } else {
                    return loader();
                  }
                } else {
                  return emptyItem();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget listMode() {
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
            if (enableGetMore == true) controller?.getOther();
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
                return GestureDetector(
                  onTap: () {
                    controller?.value.selected = controller?.value.data[index];
                    controller?.commit();
                    if (onSelected != null) {
                      onSelected!(controller?.value.data[index]);
                    }
                  },
                  child: item(controller?.value.data[index], index),
                );
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

  Widget item(T? data, int index) {
    List<Widget> _item = [
      draggable(data, index),
      Container(
        color: Colors.transparent,
        child: Draggable<Object>(
          dragAnchorStrategy: (drg, obj, offset) {
            return const Offset(1, 1);
          },
          feedback: Material(
            child: dragFeedBack(data, index),
          ),
          data: dragDataBuilder != null ? dragDataBuilder!(data, index) : data,
          child: itemBuilder!(data, index),
        ),
      ),
      index == (controller?.value.data.length ?? 0) - 1
          ? draggable(data, index + 1)
          : const SizedBox(),
    ];

    return Container(
      color: Colors.transparent,
      child: Column(
        children: _item,
      ),
    );
  }

  Widget draggable(data, index) {
    return DragTarget<Object>(
      builder: (c, d, w) {
        return Container(
          height: controller?.value.droppedItem != null ? null : 1,
          width: double.infinity,
          color: Colors.transparent,
          child: (controller?.value.droppedItem != null &&
                  controller?.value.droppedIndexTarget == index &&
                  controller?.value.droppedItem != data)
              ? itemBuilder!(controller?.value.droppedItem, -1)
              : const SizedBox(),
        );
      },
      onMove: (object) {
        if (object.data is T) {
          if (controller?.value.droppedItem == (object.data as T)) return;
          controller?.value.droppedItem = (object.data as T);
          controller?.value.droppedIndexTarget = index;
          controller?.commit();
        }
      },
      onLeave: (object) {
        controller?.value.droppedItem = null;
        controller?.commit();
      },
      onWillAccept: (object) {
        controller?.value.droppedItem = null;
        controller?.commit();
        if (onWillReceiveDropedData != null) {
          return onWillReceiveDropedData!((object as T), index);
        } else {
          return true;
        }
      },
      onAccept: (object) {
        controller?.value.droppedItem = null;
        controller?.commit();
        if (onReceiveDropedData != null) {
          onReceiveDropedData!((object as T), index);
        }
      },
    );
  }

  Widget dragFeedBack(T? data, int index) {
    return dragFeedbackBuilder != null
        ? dragFeedbackBuilder!(data, index)
        : Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Center(
              child: FittedBox(
                child: Text("$index"),
              ),
            ),
          );
  }

  Widget loader() {
    return SkeletonAnimation(
      shimmerColor: Colors.grey.shade100,
      child: itemBuilder != null ? itemBuilder!(null, 0) : emptyItem(),
    );
  }

  Widget emptyItem() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 5, top: 5),
      color: Colors.transparent,
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
          !(controller?.value.errorMessage ?? "").contains("<div")
              ? Text(
                  controller?.value.errorMessage ?? "Error",
                  textAlign: TextAlign.center,
                )
              : Container(
                  height: 300,
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Html(
                      data: controller?.value.errorMessage,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget emptyData() {
    return DragTarget<Object>(
      builder: (c, lo, ld) {
        if (controller?.value.droppedItem != null) {
          return itemBuilder!(controller?.value.droppedItem, -1);
        } else {
          if (controller?.value.droppedItem != null) {
            return itemBuilder!(controller?.value.droppedItem, -1);
          } else {
            return emptyWidget ??
                Container(
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
      },
      onMove: (object) {
        if (object.data is T) {
          if (controller?.value.droppedItem == (object.data as T)) return;
          controller?.value.droppedItem = (object.data as T);
          controller?.commit();
        }
      },
      onLeave: (object) {
        controller?.value.droppedItem = null;
        controller?.commit();
      },
      onWillAccept: (object) {
        controller?.value.droppedItem = null;
        controller?.commit();
        if (onWillReceiveDropedData != null) {
          return onWillReceiveDropedData!((object as T), 0);
        } else {
          return true;
        }
      },
      onAccept: (object) {
        controller?.value.droppedItem = null;
        controller?.commit();
        if (onReceiveDropedData != null) {
          onReceiveDropedData!((object as T), 0);
        }
      },
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
    value.data = [];
    commit();
    if (value.dataSource == null) {
      value.state = ListDataComponentState.loaded;
      commit();
      return;
    }
    value.dataSource!(0, value.searchController.text).then((datas) {
      value.data = (datas);
      if (value.onDataReceived != null) {
        value.onDataReceived!(datas, value.searchController.text);
      }
      value.state = ListDataComponentState.loaded;
      setSelectedData();
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
      value.selected ??= value.data.first;
      commit();
      return;
    }
    value.dataSource!(total, value.searchController.text).then((datas) {
      value.data.addAll(datas);
      if (value.onDataReceived != null) {
        value.onDataReceived!(datas, value.searchController.text);
      }
      value.state = ListDataComponentState.loaded;
      setSelectedData();
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

  void setSelectedData() {
    if (value.data.isNotEmpty) {
      value.selected ??= value.data.first;
      if (value.onSelected != null) {
        value.onSelected!(value.selected);
      }
    }
  }

  int get total {
    return value.data.length;
  }

  void commit() {
    notifyListeners();
  }

  void startLoading() {
    value.state = ListDataComponentState.loading;
    commit();
  }

  void stopLoading() {
    value.state = ListDataComponentState.loaded;
    commit();
  }
}

class ListDataComponentValue<T> {
  T? droppedItem;
  int? droppedIndexTarget;
  List<T> data = [];
  T? selected;
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  int totalAllData = 0;
  ListDataComponentState state = ListDataComponentState.firstLoad;
  FutureObjectBuilderWith2Param<List<T>, int, String?>? dataSource;
  ValueChanged2Param<List<T>, String?>? onDataReceived;
  ValueChanged<T?>? onSelected;
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
  tile,
}
