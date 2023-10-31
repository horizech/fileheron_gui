import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fileheron_gui/constants.dart';
import 'package:fileheron_gui/widgets/authentication/is_user_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
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
                      });
                    }),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
                      child: Row(
                        children: [
                          UpIcon(icon: Icons.settings_system_daydream),
                          SizedBox(width: 6),
                          UpText(
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
                      });
                    }),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
                      child: Row(
                        children: [
                          UpIcon(icon: Icons.description),
                          SizedBox(width: 6),
                          UpText(
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
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        widget.callback!("2");
                      });
                    }),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                      child: Row(
                        children: [
                          isUserLogin()
                              ? UpIcon(
                                  icon: Icons.logout,
                                  style: UpStyle(
                                      iconColor: UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade600),
                                )
                              : const UpIcon(
                                  icon: Icons.login,
                                ),
                          const SizedBox(width: 6),
                          isUserLogin()
                              ? UpText(
                                  "LOGOUT",
                                  style: UpStyle(
                                      textColor: UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade600),
                                )
                              : const UpText("LOGIN"),
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
