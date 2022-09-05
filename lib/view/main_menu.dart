import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:suzuki/model/menu_model.dart';
import 'package:suzuki/util/system.dart';
import 'package:suzuki/view_model/main_menu_view_model.dart';
import 'package:suzuki/util/type.dart';

class MainMenuView extends StatefulWidget {
  final List<MenuModel?>? drawerMenus;
  final WidgetFromDataBuilder<MenuModel?>? onCreateBody;
  final VoidCallback? onLogout;

  const MainMenuView(
      {Key? key, this.drawerMenus, this.onCreateBody, this.onLogout})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainMenuState();
  }
}

class MainMenuState extends State<MainMenuView> {
  MainMenuViewModel mainMenuViewModel = MainMenuViewModel();

  @override
  void initState() {
    if ((widget.drawerMenus?.length ?? 0) > 0) {
      mainMenuViewModel.selectedMenu = widget.drawerMenus?.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: mainMenuViewModel,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            color: System.data.color!.primaryColor,
            height: double.infinity,
            child: Row(
              children: [
                Container(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {
                      mainMenuViewModel.menuIsOpen =
                          !mainMenuViewModel.menuIsOpen;
                      mainMenuViewModel.commit();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Image.network("assets/assets/logo_sfi_white.png"),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    color: Colors.transparent,
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(20),
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      "${System.data.global.user?.email}",
                      style: System.data.textStyle!.boldTitleLabel.copyWith(
                        color: System.data.color!.lightTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTapUp: (td) {
                      showMenu<int>(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          td.globalPosition.dx,
                          td.globalPosition.dy + 20,
                          0,
                          0,
                        ),
                        items: [
                          PopupMenuItem(
                            padding: const EdgeInsets.all(5),
                            value: 0,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10, top: 10),
                              decoration: BoxDecoration(
                                  color: System.data.color!.lightBackground),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Logout",
                                    style: System.data.textStyle!.basicLabel,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ).then((value) {
                        switch (value) {
                          case 0:
                            if (widget.onLogout != null) {
                              widget.onLogout!();
                            }
                            break;
                          default:
                        }
                        return value;
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.userAlt,
                      color: System.data.color!.lightTextColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: System.data.color!.background,
        body: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.only(left: 40),
                child: Consumer<MainMenuViewModel>(
                  builder: (c, d, w) {
                    if (widget.onCreateBody != null) {
                      if (d.selectedMenu == null &&
                          (widget.drawerMenus?.length ?? 0) > 0) {
                        return widget.onCreateBody!(widget.drawerMenus!.first);
                      } else if (d.selectedMenu != null) {
                        return widget.onCreateBody!(d.selectedMenu);
                      } else {
                        return const SizedBox();
                      }
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: sideMenu(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sideMenu() {
    double width = MediaQuery.of(context).size.width;
    return Consumer<MainMenuViewModel>(
      builder: (c, d, w) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(2, 2),
              blurRadius: 2,
            )
          ]),
          width: !d.menuIsOpen
              ? 40
              : (width * 20 / 100) > 300
                  ? 300
                  : (width * 20 / 100) < (width * 20 / 100)
                      ? (width * 20 / 100)
                      : 300,
          child: Column(
            children: List.generate(widget.drawerMenus?.length ?? 0, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 5, top: 5),
                height: 50,
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: GestureDetector(
                    onTap: () {
                      d.setSelectedMenu(widget.drawerMenus![index]!);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          color: d.selectedMenu == widget.drawerMenus![index]!
                              ? System.data.color!.primaryColor
                              : Colors.transparent,
                          height: 40,
                          width: 40,
                          child: Icon(
                            widget.drawerMenus![index]!.iconData,
                            color: d.selectedMenu == widget.drawerMenus![index]!
                                ? System.data.color!.lightTextColor
                                : System.data.color!.darkTextColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Center(
                          child: Container(
                            color: Colors.transparent,
                            child: Text(
                              widget.drawerMenus![index]!.title ?? "",
                              style: System.data.textStyle!.boldTitleLabel,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
