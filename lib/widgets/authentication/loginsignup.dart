import 'package:fileheron_gui/widgets/authentication/login.dart';
import 'package:fileheron_gui/widgets/authentication/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/helpers/up_layout.dart';
import 'package:flutter_up/widgets/up_card.dart';

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
          body: Column(
            children: [
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: RichText(
                    text: TextSpan(
                      text: _mode == Constant.authLogin
                          ? 'Dont have an account?  '
                          : 'Already have an account?  ',
                      style: TextStyle(
                        color: UpConfig.of(context).theme.baseColor[900],
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: _mode == Constant.authLogin
                              ? ' Signup now'
                              : ' Login now',
                          style: TextStyle(
                              color: UpConfig.of(context).theme.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _mode == Constant.authLogin
                                  ? _gotoSignup()
                                  : _gotoLogin();
                            },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
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
    return SizedBox(
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical, child: getView()),
    );
  }
}
