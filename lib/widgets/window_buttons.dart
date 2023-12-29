import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_icon.dart';

// ignore: must_be_immutable
class WindowButtons extends StatefulWidget {
  final Function(String)? callback;
  String? view;
  WindowButtons({Key? key, this.callback, this.view}) : super(key: key);

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1, right: 4),
          child: GestureDetector(
            onTap: () {
              setState(() {
                widget.callback!("4");
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: UpConfig.of(context).theme.primaryColor,
                  shape: BoxShape.circle),
              height: 30,
              width: 30,
              child: UpIcon(
                icon: Icons.person,
                style: UpStyle(
                  iconColor: UpThemes.getContrastColor(
                      UpConfig.of(context).theme.primaryColor),
                  iconSize: 20,
                ),
              ),
            ),
          ),
        ),
        MinimizeWindowButton(
            animate: true,
            colors: WindowButtonColors(
              iconNormal: UpConfig.of(context).theme.baseColor.shade900,
              mouseOver: UpConfig.of(context).theme.baseColor,
              iconMouseOver: UpConfig.of(context).theme.primaryColor,
            )),
        MaximizeWindowButton(
          animate: true,
          colors: WindowButtonColors(
            iconNormal: UpConfig.of(context).theme.baseColor.shade900,
            mouseOver: UpConfig.of(context).theme.baseColor,
            iconMouseOver: UpConfig.of(context).theme.primaryColor,
          ),
        ),
        CloseWindowButton(
          animate: true,
          colors: WindowButtonColors(
            iconNormal: UpConfig.of(context).theme.baseColor.shade900,
            mouseOver: UpConfig.of(context).theme.baseColor,
            iconMouseOver: UpConfig.of(context).theme.primaryColor,
          ),
        )
      ],
    );
  }
}
