import 'package:apiraiser/apiraiser.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fileheron_gui/widgets/fileheron_appbar.dart';
import 'package:fileheron_gui/widgets/fileheron_navdrawer.dart';
import 'package:fileheron_gui/widgets/left_side.dart';
import 'package:fileheron_gui/widgets/right_side.dart';
import 'package:fileheron_gui/widgets/right_side_web.dart';
import 'package:fileheron_gui/widgets/window_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String view = "1";
  callback(newView) {
    setState(() {
      view = newView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UpScaffold(
      key: const Key('HOME_KEY'),
      appBar: fileHeronAppBar(context, "FileHeron"),
      drawer: fileHeronNavDrawer(context),
      body: kIsWeb
          ? Padding(
              padding: const EdgeInsets.all(6),
              child: RightSideWeb(
                view: int.parse(view),
                callback: callback,
              ),
            )
          : WindowBorder(
              width: 1,
              color: Colors.black,
              child: Container(
                  color: UpConfig.of(context).theme.baseColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: WindowTitleBarBox(
                          child: Row(
                            children: [
                              Expanded(
                                child: MoveWindow(),
                              ),
                              const WindowButtons(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: LeftSide(
                                  view: int.parse(view),
                                  callback: callback,
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Container(
                                    color: UpConfig.of(context).theme.baseColor,
                                    child: RightSide(
                                      view: int.parse(view),
                                      callback: callback,
                                    ),
                                  )),
                            ]),
                      )
                    ],
                  ))),
    );
  }
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
