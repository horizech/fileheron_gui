import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';

// ignore: must_be_immutable
class WindowButtons extends StatefulWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MinimizeWindowButton(
            animate: true,
            colors: WindowButtonColors(
              iconNormal: UpConfig.of(context).theme.baseColor.shade900,
              mouseOver: UpConfig.of(context).theme.baseColor.shade500,
              iconMouseOver: UpConfig.of(context).theme.primaryColor,
            )),
        MaximizeWindowButton(
          animate: true,
          colors: WindowButtonColors(
            iconNormal: UpConfig.of(context).theme.baseColor.shade900,
            mouseOver: UpConfig.of(context).theme.baseColor.shade500,
            iconMouseOver: UpConfig.of(context).theme.primaryColor,
          ),
        ),
        CloseWindowButton(
          animate: true,
          colors: WindowButtonColors(
            iconNormal: UpConfig.of(context).theme.baseColor.shade900,
            mouseOver: Colors.redAccent.shade700,
            iconMouseOver: Colors.white,
          ),
        )
      ],
    );
  }
}
