import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fileheron_gui/constants.dart';
import 'package:fileheron_gui/widgets/authentication/is_user_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';

class LeftSide extends StatefulWidget {
  final Function(String)? callback;
  final String? view;
  const LeftSide({Key? key, this.callback, this.view}) : super(key: key);

  @override
  State<LeftSide> createState() => _LeftSideState();
}

class _LeftSideState extends State<LeftSide> {
  int selectedWidget = 1;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Container(
        color: UpConfig.of(context).theme.baseColor.shade50,
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(
                    child: MoveWindow(),
                  ),
                  const UpText(
                    "FileHeron",
                  ),
                  Expanded(
                    child: MoveWindow(),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: UpConfig.of(context).theme.baseColor.shade200,
            ),
            Expanded(
              child: Column(
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: UpText(
                            "Server",
                            // style: TextStyle(
                            //   color: Colors.white,
                            // ),
                          ),
                        ),
                      ),
                      UpIcon(
                        icon: Icons.arrow_drop_down,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        widget.callback!("1");
                        selectedWidget = 1;
                      });
                    }),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                      child: Row(
                        children: [
                          UpIcon(
                            icon: Icons.settings_system_daydream,
                            style: UpStyle(
                                iconColor: selectedWidget == 1
                                    ? UpConfig.of(context).theme.primaryColor
                                    : UpThemes.getContrastColor(
                                        UpConfig.of(context).theme.baseColor)),
                          ),
                          const SizedBox(width: 6),
                          const UpText(
                            "LOCAL SERVER",
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        widget.callback!("3");
                        selectedWidget = 3;
                      });
                    }),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                      child: Row(
                        children: [
                          UpIcon(
                            icon: Icons.description,
                            style: UpStyle(
                                iconColor: selectedWidget == 3
                                    ? UpConfig.of(context).theme.primaryColor
                                    : UpThemes.getContrastColor(
                                        UpConfig.of(context).theme.baseColor)),
                          ),
                          const SizedBox(width: 6),
                          const UpText(
                            "PROJECTS",
                            // style: TextStyle(
                            //   color: Colors.white,
                            //   fontWeight: FontWeight.bold,
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  !isUserLogin()
                      ? GestureDetector(
                          onTap: (() {
                            setState(() {
                              widget.callback!("2");
                              selectedWidget = 2;
                            });
                          }),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                            child: Row(
                              children: [
                                UpIcon(
                                  icon: Icons.login,
                                  style: UpStyle(
                                      iconColor: selectedWidget == 2
                                          ? UpConfig.of(context)
                                              .theme
                                              .primaryColor
                                          : UpThemes.getContrastColor(
                                              UpConfig.of(context)
                                                  .theme
                                                  .baseColor)),
                                ),
                                const SizedBox(width: 6),
                                const UpText("LOGIN"),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  isUserLogin()
                      ? GestureDetector(
                          onTap: (() {
                            setState(() {
                              widget.callback!("4");
                              selectedWidget = 4;
                            });
                          }),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                            child: Row(
                              children: [
                                UpIcon(
                                  icon: Icons.logout,
                                  style: UpStyle(
                                      iconColor: selectedWidget == 4
                                          ? UpConfig.of(context)
                                              .theme
                                              .primaryColor
                                          : UpConfig.of(context)
                                              .theme
                                              .baseColor
                                              .shade600),
                                ),
                                const SizedBox(width: 6),
                                UpText(
                                  "LOGOUT",
                                  style: UpStyle(
                                      textColor: UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade600),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: UpText(version),
              ),
            )
          ],
        ),
      ),
    );
  }
}
