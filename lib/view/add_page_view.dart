import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/circular_loader_component.dart';
import 'package:suzuki/component/input_component.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/model/page_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view_model/add_page_view_model.dart';

class AddPageView extends StatefulWidget {
  final PageModel pageModel;
  final List<PageModel?> listPageModel;

  const AddPageView({
    Key? key,
    required this.pageModel,
    required this.listPageModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddPageViewState();
  }
}

class AddPageViewState extends State<AddPageView> {
  AddPageViewModel addPageViewModel = AddPageViewModel();

  @override
  void initState() {
    super.initState();
    widget.listPageModel
        .add(PageModel(order: (widget.listPageModel.last?.order ?? 0) + 1));
    if (widget.pageModel.id != null) {
      addPageViewModel.nameController.text = widget.pageModel.name ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CircularLoaderComponent(
        controller: addPageViewModel.loadingController,
        child: ChangeNotifierProvider.value(
          value: addPageViewModel,
          child: Center(
            child: Container(
              width: 300,
              color: Colors.white,
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    BasicComponent.panelHeader(
                      title:
                          "${widget.pageModel.id != null ? "Edit" : "Add"} Page",
                      actions: [
                        MenuModel(
                          iconData: Icons.close,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Consumer<AddPageViewModel>(builder: (c, d, w) {
                            return InputComponent.inputTextWithCap(
                              capTitle: "Name",
                              controller: addPageViewModel.nameController,
                              isValid: addPageViewModel.isValidName,
                            );
                          }),
                          const SizedBox(
                            height: 10,
                          ),
                          Consumer<AddPageViewModel>(
                            builder: (c, d, w) {
                              return InputComponent.dropDownPopupWithCap<
                                  PageModel?>(
                                isValid: d.isValidOrder,
                                capTitle: "Order",
                                value: d.order,
                                onSelected: (data) {
                                  d.order = data;
                                  d.commit();
                                },
                                dataSource: Future.value().then((value) {
                                  return widget.listPageModel;
                                }),
                                itemBuilder: (data) {
                                  return Row(
                                    children: [
                                      Text(
                                        data?.id == null ? "Last" : "Before ",
                                        style:
                                            System.data.textStyle!.basicLabel,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        data?.name ?? "",
                                        style:
                                            System.data.textStyle!.basicLabel,
                                      )
                                    ],
                                  );
                                },
                                selectedBuilder: (data) {
                                  return Row(
                                    children: [
                                      Text(
                                        data?.id == null ? "Last" : "Before ",
                                        style:
                                            System.data.textStyle!.basicLabel,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        data?.name ?? "",
                                        style:
                                            System.data.textStyle!.basicLabel,
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  addPageViewModel.savePage(
                                      context, widget.pageModel);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      System.data.color!.primaryColor),
                                ),
                                child: Text(
                                  "Save",
                                  style: System
                                      .data.textStyle!.boldTitleLightLabel,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
