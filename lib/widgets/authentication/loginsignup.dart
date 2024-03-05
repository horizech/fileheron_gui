import 'package:fileheron_gui/widgets/authentication/login.dart';
import 'package:fileheron_gui/widgets/authentication/signup.dart';
import 'package:fileheron_gui/widgets/fileheron_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/helpers/up_layout.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';

import '../../constants.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  String _mode = Constant.authLogin;

  _gotoLogin() {
    setState(() {
      _mode = Constant.authLogin;
    });
  }

  _gotoSignup() {
    setState(() {
      _mode = Constant.authSignup;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget getView() {
    List<Widget> view = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: UpCard(
          style: UpStyle(cardWidth: 400),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: UpConfig.of(context).theme.baseColor,
                        shape: BoxShape.circle),
                    child: Image.asset("assets/file-heron-128.png"),
                  ),
                  const SizedBox(width: 8),
                  UpText(
                    "FileHeron",
                    style: UpStyle(textSize: 20, textWeight: FontWeight.bold),
                  )
                ]),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  onTap: () {
                    _gotoLogin();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: _mode == Constant.authLogin
                                      ? UpConfig.of(context).theme.primaryColor
                                      : Colors.transparent,
                                  width: 2))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: UpText(
                          "LOGIN",
                          style: UpStyle(
                              textSize: 17,
                              textWeight: FontWeight.bold,
                              textColor: UpConfig.of(context)
                                  .theme
                                  .baseColor
                                  .shade800),
                        ),
                      )),
                ),
                const SizedBox(width: 22),
                GestureDetector(
                  onTap: () {
                    _gotoSignup();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: _mode != Constant.authLogin
                                    ? UpConfig.of(context).theme.primaryColor
                                    : Colors.transparent,
                                width: 2))),
                    child: UpText(
                      "SIGNUP",
                      style: UpStyle(
                          textSize: 17,
                          textWeight: FontWeight.bold,
                          textColor:
                              UpConfig.of(context).theme.baseColor.shade800),
                    ),
                  ),
                ),
              ]),
              _mode == Constant.authLogin
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LoginPage(),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SignupPage(),
                    ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    ];

    return UpLayout.isLandscape(context)
        ? Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 100),
              // height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: view,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: view,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return UpScaffold(
      appBar: fileHeronAppBar(context, "LOGIN"),
      body: SizedBox(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical, child: getView()),
      ),
    );
  }
}
