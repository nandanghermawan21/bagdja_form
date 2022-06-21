import 'package:flutter/material.dart';
import 'package:suzuki/component/basic_component.dart';
import 'package:suzuki/component/input_component.dart';
import 'package:suzuki/component/list_data_component.dart';
import 'package:suzuki/model/form_model.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/model/page_model.dart';
import 'package:suzuki/util/system.dart';

class FormEditorView extends StatefulWidget {
  final FormModel? formModel;
  final VoidCallback? onTapClose;

  const FormEditorView({
    Key? key,
    this.formModel,
    this.onTapClose,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormEditorViewState();
  }
}

class FormEditorViewState extends State<FormEditorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(0),
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              height: 100,
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: Colors.transparent,
                              child: InputComponent.inputTextWithCap(
                                controller: TextEditingController(),
                                capTitle: "Form Code",
                                hint: "Form Code",
                                readOnly: true,
                                value: widget.formModel?.code,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              color: Colors.transparent,
                              child: InputComponent.inputTextWithCap(
                                controller: TextEditingController(),
                                capTitle: "Form Name",
                                hint: "Form Name",
                                readOnly: true,
                                value: widget.formModel?.name,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    color: Colors.transparent,
                    height: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: widget.onTapClose,
                          child: Icon(
                            Icons.close,
                            color: System.data.color!.darkTextColor,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                child: pageEditor(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget pageEditor() {
    return ListDataComponent<PageModel?>(
      controller: ListDataComponentController<PageModel?>(),
      enableGetMore: false,
      listViewMode: ListDataComponentMode.tile,
      dataSource: (skip, search) {
        return PageModel.formPages(
          token: System.data.global.token,
          id: widget.formModel?.id,
        );
      },
      itemBuilder: (data, index) {
        return pageItem();
      },
    );
  }

  Widget pageItem() {
    return Container(
      margin: const EdgeInsets.all(10),
      color: Colors.transparent,
      width: 300,
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: BasicComponent.panelHeader(
              title: "Page 1",
              backgroundColor: Colors.white,
              color: System.data.color!.darkTextColor,
              actions: [
                MenuModel(
                  iconData: Icons.edit,
                ),
                MenuModel(
                  iconData: Icons.delete,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Column(
              children: [
                BasicComponent.panelHeader(
                  title: "Question Group",
                ),
                BasicComponent.panelHeader(
                  title: "Dicission",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
