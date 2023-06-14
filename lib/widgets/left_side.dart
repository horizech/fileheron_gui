import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fileheron_gui/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';

class LeftSide extends StatelessWidget {
  const LeftSide({Key? key}) : super(key: key);

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
                    // style: TextStyle(
                    //   color: Colors.white,
                    //   fontWeight: FontWeight.bold,
                    // ),
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
            const Expanded(
              child: Column(
                children: [
                  Row(
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
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
                        child: UpText(
                          "Local Server",
                          // style: TextStyle(
                          //   color: Colors.white,
                          //   fontWeight: FontWeight.bold,
                          // ),
                        ),
                      ),
                    ],
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
