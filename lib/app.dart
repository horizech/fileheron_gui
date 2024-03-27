import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/constants.dart';
import 'package:fileheron_gui/pages/about.dart';
import 'package:fileheron_gui/pages/local_server_page.dart';
import 'package:fileheron_gui/pages/project_page.dart';
import 'package:fileheron_gui/widgets/authentication/loginsignup.dart';
import 'package:fileheron_gui/pages/deployment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/models/up_route.dart';
import 'package:flutter_up/models/up_router_state.dart';
import 'package:flutter_up/up_app.dart';
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
      initialRoute: Routes.home,
      upRoutes: [
        UpRoute(
          path: Routes.loginSignup,
          pageBuilder: (BuildContext context, UpRouterState state) =>
              const LoginSignupPage(),
          name: Routes.loginSignup,
          shouldRedirect: () => Apiraiser.authentication.isSignedIn(),
          redirectRoute: Routes.projects,
        ),
        UpRoute(
            path: Routes.home,
            pageBuilder: (BuildContext context, UpRouterState state) =>
                const LocalServerPage(),
            name: Routes.home),
        UpRoute(
            path: Routes.about,
            pageBuilder: (BuildContext context, UpRouterState state) =>
                const AboutPage(),
            name: Routes.about),
        UpRoute(
            path: Routes.projects,
            pageBuilder: (BuildContext context, UpRouterState state) =>
                const ProjectsPage(),
            name: Routes.projects),
        UpRoute(
            path: Routes.deploy,
            pageBuilder: (BuildContext context, UpRouterState state) =>
                const DeploymentPage(),
            name: Routes.deploy)
      ],
      title: 'FileHeron',
    );
  }
}
