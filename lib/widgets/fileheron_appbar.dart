import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/constants.dart';
import 'package:fileheron_gui/services/auth.dart';
import 'package:fileheron_gui/widgets/window_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/models/up_app_bar_item.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';

PreferredSizeWidget fileHeronAppBar(
    BuildContext context, String tittle, GlobalKey<ScaffoldState> key) {
  List<UpAppBarItem> getUpAppBarItems() {
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

  void login() async {
    ServiceManager<UpNavigationService>().navigateToNamed(Routes.loginSignup);
  }

  void logOut() async {
    ServiceManager<AuthService>().logOut();
    ServiceManager<UpNavigationService>().navigateToNamed(Routes.home);
  }

  void select(UpAppBarItem item) {
    // Causes the app to rebuild with the const _selectedItem.
    UpAppBarItem selectedItem = item;
    if (selectedItem.title == "Logout") {
      logOut();
    }
    if (selectedItem.title == "Login") {
      login();
    }
  }

  return UpAppBar(
    scaffoldKey: key,
    titleWidget: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            ServiceManager<UpNavigationService>().navigateToNamed(Routes.home);
          },
          child: SizedBox(
            width: 50,
            height: 50,
            child: Image.asset("assets/file-heron-128.png"),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          child: UpText(
            tittle,
            type: UpTextType.heading5,
          ),
        ),
      ],
    ),
    actions: [
      PopupMenuButton<UpAppBarItem>(
        icon: const UpIcon(icon: Icons.more_vert),
        color: UpConfig.of(context).theme.baseColor.shade50,
        onSelected: select,
        itemBuilder: (BuildContext context) {
          return getUpAppBarItems().map((UpAppBarItem item) {
            return PopupMenuItem<UpAppBarItem>(
              value: item,
              child: Row(
                children: [
                  UpIcon(
                    icon: item.icon!,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: UpText(item.title ?? ""),
                  )
                ],
              ),
            );
          }).toList();
        },
      ),
      const Visibility(visible: !kIsWeb, child: WindowButtons()),
    ],
  );
}
