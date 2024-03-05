import 'package:fileheron_gui/services/auth.dart';
import 'package:fileheron_gui/services/key.dart';
import 'package:flutter_up/locator.dart';

void setupLocator() {
  setupFlutterUpLocators([
    FlutterUpLocators.upDialogService,
    FlutterUpLocators.upNavigationService,
    FlutterUpLocators.upScaffoldHelperService,
    FlutterUpLocators.upSearchService,
    FlutterUpLocators.upUrlService,
    FlutterUpLocators.upLayoutService,
  ]);
  ServiceManager.registerLazySingleton(() => AuthService());
  ServiceManager.registerLazySingleton(() => KeyService());
}
