import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_list_tile.dart';
import 'package:flutter_up/widgets/up_text.dart';

Widget fileHeronNavDrawer(BuildContext context) {
  Uri uri = Uri.base;
  return Column(
    children: [
      getDrawerHeader(context),
      UpExpansionTile(
        title: "Local Server",
        children: [
          UpListTile(
            isSelected: uri.fragment == Routes.home,
            leadingIcon: Icons.home,
            title: "Local Server",
            onTap: () {
              ServiceManager<UpNavigationService>()
                  .navigateToNamed(Routes.home, replace: true);
            },
          ),
        ],
      ),
      UpExpansionTile(
        title: "FileHeron Server",
        children: [
          UpListTile(
            isSelected: uri.fragment == Routes.projects,
            leadingIcon: Icons.list,
            title: "Projects",
            onTap: () {
              ServiceManager<UpNavigationService>()
                  .navigateToNamed(Routes.projects, replace: true);
            },
          ),
          UpListTile(
            isSelected: uri.fragment == Routes.deploy,
            leadingIcon: Icons.rocket_launch,
            title: "Deployments",
            onTap: () {
              ServiceManager<UpNavigationService>()
                  .navigateToNamed(Routes.deploy, replace: true);
            },
          ),
        ],
      ),
      UpListTile(
        isSelected: uri.fragment == Routes.about,
        leadingIcon: Icons.info,
        title: "About",
        onTap: () {
          ServiceManager<UpNavigationService>()
              .navigateToNamed(Routes.about, replace: true);
        },
      ),
    ],
  );
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
            child: Image.asset("assets/file-heron-128.png"),
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
