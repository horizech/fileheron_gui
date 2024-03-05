import 'package:fileheron_gui/pages/about.dart';
import 'package:fileheron_gui/pages/homepage.dart';
import 'package:fileheron_gui/widgets/authentication/login.dart';
import 'package:fileheron_gui/widgets/authentication/loginsignup.dart';
import 'package:fileheron_gui/widgets/authentication/signup.dart';
import 'package:fileheron_gui/widgets/deployment_widget.dart';
import 'package:fileheron_gui/widgets/project_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String kDefaultHost = 'localhost';
const int kDefaultPort = 8080;
const String kDefaultRoot = 'public';
const bool kDefaultListDir = true;
const String? kDefaultLogFile = null;
const bool kDefaultSSL = false;
const String? kDefaultCertificateChain = null;
const String? kDefaultServerKey = null;
const String? kDefaultServerKeyPassword = null;
const String kDefaultServerType = 'static';
const String version = "v 1.1.0";
const String authLogout = "Logout";

class Constant {
  static const String authLogin = "Login";
  static const String authSignup = "Signup";
  static const String routes = "Signup";
  static const String authLogout = "Logout";
}

class Routes {
  static const String index = "/";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String loginSignup = "/loginsignup";
  static const String home = "/home";
  static const String about = "/about";
  static const String projects = "/projects";
  static const String deploy = "/deploy";
}

getRouteSettings(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Routes.home:
      return MaterialPageRoute(builder: (context) => const HomePage());
    case Routes.login:
      return MaterialPageRoute(
          builder: (context) => const LoginPage(), fullscreenDialog: true);
    case Routes.signup:
      return MaterialPageRoute(
          builder: (context) => const SignupPage(), fullscreenDialog: true);
    case Routes.loginSignup:
      return MaterialPageRoute(
          builder: (context) => const LoginSignupPage(),
          fullscreenDialog: true);
    case Routes.projects:
      return MaterialPageRoute(
          builder: (context) => const Projects(), fullscreenDialog: true);
    case Routes.deploy:
      return MaterialPageRoute(
          builder: (context) => const Deployment(), fullscreenDialog: true);
    case Routes.about:
      return MaterialPageRoute(builder: (context) => const AboutPage());
  }
}
