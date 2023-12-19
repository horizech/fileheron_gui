import 'package:fileheron_gui/constants.dart';
import 'package:fileheron_gui/services/auth.dart';
import 'package:fileheron_gui/services/key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';

class Session {
  static checkLimitedSession(BuildContext context) async {
    await const FlutterSecureStorage().read(key: "duration").then((duration) {
      if (duration != null &&
          ServiceManager<KeyService>().getRemainingTime() < 5) {
        endSession(context);
      }
    });
  }

  static endSession(context) {
    UpToast().showToast(
      context: context,
      text: "Session timeout",
      isRounded: true,
    );
    ServiceManager<AuthService>().logOut();
    ServiceManager<UpNavigationService>()
        .navigateToNamed(Routes.loginSignup, replace: true);
  }
}
