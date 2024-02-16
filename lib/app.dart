import 'package:fileheron_gui/widgets/window_buttons.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fileheron_gui/widgets/left_side.dart';
import 'package:fileheron_gui/widgets/right_side.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/models/up_route.dart';
import 'package:flutter_up/models/up_router_state.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/up_app.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return UpApp(
      initialRoute: '/home',
      upRoutes: [
        UpRoute(
          path: '/home',
          pageBuilder: (BuildContext context, UpRouterState state) =>
              const HomePage(),
        )
      ],
      theme: UpThemes.generateThemeByColor(
        // baseColor: const Color.fromARGB(255, 25, 23, 30),
        baseColor: const Color.fromARGB(255, 47, 45, 45),
        // baseColor: Colors.white,
        // baseColor: Colors.black,
        isDark: true,
        primaryColor: const Color.fromARGB(255, 252, 225, 0),
        // primaryColor: Colors.blue,
      ),
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
  callback(newView) {
    setState(() {
      view = newView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WindowBorder(
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
