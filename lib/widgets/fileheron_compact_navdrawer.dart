import 'package:fileheron_gui/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_icon.dart';

Widget fileHeronCompactNavDrawer(BuildContext context) {
  Uri uri = Uri.base;
  return Column(
    children: [
      const SizedBox(height: 12),
      InkWell(
        onTap: () {
          ServiceManager<UpNavigationService>()
              .navigateToNamed(Routes.home, replace: true);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  color: uri.fragment == Routes.home
                      ? UpConfig.of(context).theme.primaryColor
                      : Colors.transparent,
                  width: 2),
            ),
          ),
          child: UpIcon(
            style: UpStyle(
                iconSize: 32,
                iconColor: uri.fragment == Routes.home
                    ? UpConfig.of(context).theme.baseColor.shade900
                    : UpConfig.of(context).theme.baseColor.shade800),
            icon: Icons.home,
          ),
        ),
      ),
      const SizedBox(height: 8),
      InkWell(
        onTap: () {
          ServiceManager<UpNavigationService>()
              .navigateToNamed(Routes.projects, replace: true);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  color: uri.fragment == Routes.projects
                      ? UpConfig.of(context).theme.primaryColor
                      : Colors.transparent,
                  width: 2),
            ),
          ),
          child: UpIcon(
            style: UpStyle(
                iconSize: 32,
                iconColor: uri.fragment == Routes.projects
                    ? UpConfig.of(context).theme.baseColor.shade900
                    : UpConfig.of(context).theme.baseColor.shade800),
            icon: Icons.list,
          ),
        ),
      ),
      const SizedBox(height: 8),
      InkWell(
        onTap: () {
          ServiceManager<UpNavigationService>()
              .navigateToNamed(Routes.deploy, replace: true);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  color: uri.fragment == Routes.deploy
                      ? UpConfig.of(context).theme.primaryColor
                      : Colors.transparent,
                  width: 2),
            ),
          ),
          child: UpIcon(
            style: UpStyle(
                iconSize: 32,
                iconColor: uri.fragment == Routes.deploy
                    ? UpConfig.of(context).theme.baseColor.shade900
                    : UpConfig.of(context).theme.baseColor.shade800),
            icon: Icons.rocket_launch,
          ),
        ),
      ),
      const SizedBox(height: 8),
      InkWell(
        onTap: () {
          ServiceManager<UpNavigationService>()
              .navigateToNamed(Routes.about, replace: true);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  color: uri.fragment == Routes.about
                      ? UpConfig.of(context).theme.primaryColor
                      : Colors.transparent,
                  width: 2),
            ),
          ),
          child: UpIcon(
            style: UpStyle(
                iconSize: 32,
                iconColor: uri.fragment == Routes.about
                    ? UpConfig.of(context).theme.baseColor.shade900
                    : UpConfig.of(context).theme.baseColor.shade800),
            icon: Icons.info,
          ),
        ),
      ),
    ],
  );
}
