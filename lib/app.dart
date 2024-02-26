import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/services/auth.dart';
import 'package:fileheron_gui/widgets/right_side_web.dart';
import 'package:fileheron_gui/widgets/window_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fileheron_gui/widgets/left_side.dart';
import 'package:fileheron_gui/widgets/right_side.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/models/up_app_bar_item.dart';
import 'package:flutter_up/models/up_route.dart';
import 'package:flutter_up/models/up_router_state.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/up_app.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_list_tile.dart';
import 'package:flutter_up/widgets/up_nav_drawer.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:horizech_flutter_common/horizech_flutter_common.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return UpApp(
      theme: HorizechCommon().themes.theme2024Light,
      initialRoute: '/home',
      upRoutes: [
        UpRoute(
          path: '/home',
          pageBuilder: (BuildContext context, UpRouterState state) =>
              const HomePage(),
        )
      ],
      title: 'FileHeron',
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String view = "1";
  UpAppBarItem _selectedItem = UpAppBarItem(); // The app's "state".
  callback(newView) {
    setState(() {
      view = newView;
    });
  }

  List<UpAppBarItem> _getUpAppBarItems() {
    if (Apiraiser.authentication.getCurrentUser() != null) {
      return <UpAppBarItem>[
        UpAppBarItem(
            title: Apiraiser.authentication.getCurrentUser()!.fullname,
            icon: Icons.person),
        UpAppBarItem(title: "Logout", icon: Icons.power_settings_new),
      ];
    } else {
      return [
        UpAppBarItem(title: "Login", icon: Icons.person),
      ];
    }
  }

  void _select(UpAppBarItem item) {
    // Causes the app to rebuild with the const _selectedItem.
    setState(() {
      _selectedItem = item;
      if (_selectedItem.title == "Logout") {
        setState(() {
          _logOut();
        });
      }
      if (_selectedItem.title == "Login") {
        setState(() {
          _login();
        });
      }
    });
  }

  void _login() async {
    setState(() {
      callback("4");
    });
  }

  void _logOut() async {
    setState(() {
      ServiceManager<AuthService>().logOut();
      callback("1");
    });
  }

  @override
  Widget build(BuildContext context) {
    return UpScaffold(
      appBar: UpAppBar(
        titleWidget: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  view = "1";
                });
              },
              child: SizedBox(
                width: 50,
                height: 50,
                child: Image.asset("assets/logo.png"),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            SizedBox(
              child: UpText(
                getTitle(view),
                type: UpTextType.heading5,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<UpAppBarItem>(
            icon: const UpIcon(icon: Icons.more_vert),
            color: UpConfig.of(context).theme.baseColor.shade50,
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return _getUpAppBarItems().map((UpAppBarItem item) {
                return PopupMenuItem<UpAppBarItem>(
                  value: item,
                  child: Row(
                    children: [
                      UpIcon(
                        icon: item.icon!,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: UpText(item.title ?? ""),
                      )
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: UpNavDrawer(
        children: [
          getDrawerHeader(context),
          UpExpansionTile(
            title: "Local Server",
            children: [
              UpListTile(
                isSelected: view == "1",
                leadingIcon: Icons.home,
                title: "Local Server",
                onTap: () {
                  setState(() {
                    view = "1";
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          UpExpansionTile(
            title: "FileHeron Server",
            children: [
              UpListTile(
                isSelected: view == "2",
                leadingIcon: Icons.home,
                title: "Projects",
                onTap: () {
                  setState(() {
                    view = "2";
                  });
                  Navigator.of(context).pop();
                },
              ),
              UpListTile(
                isSelected: view == "3",
                leadingIcon: Icons.home,
                title: "Deployments",
                onTap: () {
                  setState(() {
                    view = "3";
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
      body: kIsWeb
          ? Padding(
              padding: const EdgeInsets.all(6),
              child: RightSideWeb(
                view: int.parse(view),
                callback: callback,
              ),
            )
          : WindowBorder(
              width: 1,
              color: Colors.black,
              child: Container(
                  color: UpConfig.of(context).theme.baseColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: WindowTitleBarBox(
                          child: Row(
                            children: [
                              Expanded(
                                child: MoveWindow(),
                              ),
                              WindowButtons(
                                view: "",
                                callback: callback,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: LeftSide(
                                  view: int.parse(view),
                                  callback: callback,
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Container(
                                    color: UpConfig.of(context).theme.baseColor,
                                    child: RightSide(
                                      view: int.parse(view),
                                      callback: callback,
                                    ),
                                  )),
                            ]),
                      )
                    ],
                  ))),
    );
  }
}

Widget getDrawerHeader(context) {
  return Container(
    padding: const EdgeInsets.all(8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: 80,
            child: Image.asset("assets/app_icon.png"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: UpText(
            style: UpStyle(textWeight: FontWeight.w900),
            "FileHeron",
          ),
        ),
        Visibility(
          visible: Apiraiser.authentication.getCurrentUser() != null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: UpText(
                style: UpStyle(textWeight: FontWeight.w900),
                "Welcome ${Apiraiser.authentication.getCurrentUser()?.fullname}"),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}

String getTitle(String view) {
  if (view == "1") {
    return "FileHeron";
  } else if (view == "2") {
    return "Projects";
  } else if (view == "3") {
    return "Deployments";
  } else {
    return "FileHeron";
  }
}
