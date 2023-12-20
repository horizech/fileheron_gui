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
  bool showContent = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      width: 250,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: UpConfig.of(context).theme.baseColor.shade100,
        ),
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(
                    child: MoveWindow(),
                  ),
                  UpText(
                    "FileHeron",
                    style: UpStyle(textSize: 20, textWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: MoveWindow(),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: UpConfig.of(context).theme.baseColor.shade300,
            ),
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        if (showContent) {
                          setState(() {
                            showContent = false;
                          });
                        } else {
                          setState(() {
                            showContent = true;
                          });
                        }
                      },
                      child: Container(
                        color: UpConfig.of(context).theme.baseColor.shade100,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: UpText(
                                  "Server",
                                  style: UpStyle(
                                      textSize: 17,
                                      textWeight: FontWeight.bold,
                                      textColor: UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade800),
                                ),
                              ),
                            ),
                            UpIcon(
                              icon: !showContent
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_drop_up,
                              style: UpStyle(
                                  iconSize: 18,
                                  iconColor: UpConfig.of(context)
                                      .theme
                                      .baseColor
                                      .shade800),
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: showContent,
                    child: GestureDetector(
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
                                      : UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade900),
                            ),
                            const SizedBox(width: 6),
                            UpText("LOCAL SERVER",
                                style: UpStyle(
                                    textColor: UpConfig.of(context)
                                        .theme
                                        .baseColor
                                        .shade800)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: showContent,
                      child: Column(
                        children: [
                          !isUserLogin()
                              ? GestureDetector(
                                  onTap: (() {}),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 8, 0, 8),
                                    child: Row(
                                      children: [
                                        UpIcon(
                                          icon: Icons.description,
                                          style: UpStyle(
                                              iconColor: UpConfig.of(context)
                                                  .theme
                                                  .baseColor
                                                  .shade500),
                                        ),
                                        const SizedBox(width: 6),
                                        UpText(
                                          "PROJECTS",
                                          style: UpStyle(
                                              textColor: UpConfig.of(context)
                                                  .theme
                                                  .baseColor
                                                  .shade500),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          isUserLogin()
                              ? GestureDetector(
                                  onTap: (() {
                                    setState(() {
                                      widget.callback!("3");
                                      selectedWidget = 3;
                                    });
                                  }),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 8, 0, 8),
                                    child: Row(
                                      children: [
                                        UpIcon(
                                          icon: Icons.description,
                                          style: UpStyle(
                                              iconColor: selectedWidget == 3
                                                  ? UpConfig.of(context)
                                                      .theme
                                                      .primaryColor
                                                  : UpConfig.of(context)
                                                      .theme
                                                      .baseColor
                                                      .shade800),
                                        ),
                                        const SizedBox(width: 6),
                                        UpText("PROJECTS",
                                            style: UpStyle(
                                                textColor: UpConfig.of(context)
                                                    .theme
                                                    .baseColor
                                                    .shade800)),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )),
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
                                          : UpConfig.of(context)
                                              .theme
                                              .baseColor
                                              .shade800),
                                ),
                                const SizedBox(width: 6),
                                UpText("LOGIN",
                                    style: UpStyle(
                                        textColor: UpConfig.of(context)
                                            .theme
                                            .baseColor
                                            .shade800)),
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
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
                                              .shade500),
                                ),
                                const SizedBox(width: 6),
                                UpText(
                                  "LOGOUT",
                                  style: UpStyle(
                                      textColor: UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade500),
                                ),
                              ],
                            ),
                          ),
                        ),
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
