import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fileheron_gui/constants.dart';
import 'package:fileheron_gui/widgets/authentication/is_user_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';

// ignore: must_be_immutable
class LeftSide extends StatefulWidget {
  final Function(String)? callback;
  int view;
  LeftSide({Key? key, this.callback, required this.view}) : super(key: key);

  @override
  State<LeftSide> createState() => _LeftSideState();
}

class _LeftSideState extends State<LeftSide> {
  int? selectedWidget;
  bool showLocalServer = true;
  bool showFileHeronServer = true;
  @override
  Widget build(BuildContext context) {
    selectedWidget = widget.view;
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      width: 250,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: UpConfig.of(context).theme.baseColor.shade50,
        ),
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(
                    child: MoveWindow(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: UpText(
                      "FileHeron",
                      style: UpStyle(textSize: 20, textWeight: FontWeight.bold),
                    ),
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
                        if (showLocalServer) {
                          setState(() {
                            showLocalServer = false;
                          });
                        } else {
                          setState(() {
                            showLocalServer = true;
                          });
                        }
                      },
                      child: Container(
                        color: UpConfig.of(context).theme.baseColor.shade50,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: UpText(
                                  "Local Server",
                                  style: UpStyle(
                                      textSize: 16,
                                      textWeight: FontWeight.bold,
                                      textColor: UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade800),
                                ),
                              ),
                            ),
                            UpIcon(
                              icon: !showLocalServer
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
                    visible: showLocalServer,
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
                  GestureDetector(
                      onTap: () {
                        if (showFileHeronServer) {
                          setState(() {
                            showFileHeronServer = false;
                          });
                        } else {
                          setState(() {
                            showFileHeronServer = true;
                          });
                        }
                      },
                      child: Container(
                        color: UpConfig.of(context).theme.baseColor.shade50,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: showLocalServer
                                    ? const EdgeInsets.fromLTRB(8, 0, 0, 0)
                                    : const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                child: UpText(
                                  "FileHeron Server",
                                  style: UpStyle(
                                      textSize: 16,
                                      textWeight: FontWeight.bold,
                                      textColor: UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade800),
                                ),
                              ),
                            ),
                            UpIcon(
                              icon: !showFileHeronServer
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
                    visible: showFileHeronServer,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              if (isUserLogin()) {
                                widget.callback!("2");
                                selectedWidget = 2;
                              } else {
                                widget.callback!("4");
                              }
                            });
                          }),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                            child: Row(
                              children: [
                                UpIcon(
                                  icon: Icons.description,
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
                                UpText("PROJECTS",
                                    style: UpStyle(
                                        textColor: UpConfig.of(context)
                                            .theme
                                            .baseColor
                                            .shade800)),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              if (isUserLogin()) {
                                widget.callback!("3");
                                selectedWidget = 3;
                              } else {
                                widget.callback!("4");
                              }
                            });
                          }),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 2, 0, 8),
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
                                UpText("DEPLOYMENTS",
                                    style: UpStyle(
                                        textColor: UpConfig.of(context)
                                            .theme
                                            .baseColor
                                            .shade800)),
                              ],
                            ),
                          ),
                        )
                      ],
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
