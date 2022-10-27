import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fileheron_gui/widgets/left_side.dart';
import 'package:fileheron_gui/widgets/right_side.dart';
import 'package:flutter_up/flutter_up_app.dart';
import 'package:flutter_up/models/up_route.dart';
import 'package:flutter_up/models/up_router_state.dart';
import 'package:flutter_up/themes/up_themes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterUpApp(
      initialRoute: '/home',
      upRoutes: [
        UpRoute(
          path: '/home',
          pageBuilder: (BuildContext context, UpRouterState state) =>
              const HomePage(),
        )
      ],
      themeCollection: UpThemes.predefinedThemesCollection,
      defaultThemeId: UpThemes.lightRed.id,
      title: 'FileHeron',
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WindowBorder(
        width: 1,
        color: Colors.black,
        child: Row(children: const [
          LeftSide(),
          Expanded(
            child: RightSide(),
          ),
        ]),
      ),
    );
  }
}
