import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class LeftSide extends StatelessWidget {
  const LeftSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(
                    child: MoveWindow(),
                  ),
                  const Text(
                    "FileHeron",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: MoveWindow(),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.white,
            ),
            Column(
              children: [
                Row(
                  children: const [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          "Server",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
                      child: Text(
                        "Local Server",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
