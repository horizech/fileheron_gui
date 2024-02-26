import 'package:fileheron_gui/services/auth.dart';
import 'package:flutter_up/locator.dart';

void setupLocator() {
  setupFlutterUpLocators([
    FlutterUpLocators.upDialogService,
    FlutterUpLocators.upNavigationService,
    FlutterUpLocators.upScaffoldHelperService,
    FlutterUpLocators.upSearchService,
    FlutterUpLocators.upUrlService
  ]);
  ServiceManager.registerLazySingleton(() => AuthService());
}
