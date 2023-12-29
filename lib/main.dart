import 'package:apiraiser/apiraiser.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fileheron_gui/app.dart';
import 'package:fileheron_gui/locator.dart';
import 'package:flutter/material.dart';
import 'environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  Apiraiser.init(Environment.apiUrl);
  runApp(
    const MyApp(),
  );
  doWhenWindowReady(() {
    var initialSize = const Size(800, 600);
    appWindow.size = initialSize;
    appWindow.minSize = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "FileHeron";
    appWindow.show();
  });
}
