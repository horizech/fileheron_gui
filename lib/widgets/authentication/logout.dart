import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_text.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  User? user = Apiraiser.authentication.getCurrentUser();
  @override
  Widget build(BuildContext context) {
    String username = user?.fullname ?? "";
    _logout() {
      Apiraiser.authentication.signOut();
      UpToast().showToast(context: context, text: "Logout Successfully");
    }

    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * .05,
          right: MediaQuery.of(context).size.width * .05,
          top: MediaQuery.of(context).size.width / 2 -
              MediaQuery.of(context).size.width * .35),
      child: Container(
        decoration: BoxDecoration(
            color: UpConfig.of(context).theme.baseColor.shade50,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              UpText(
                "Hi ",
                style: UpStyle(
                  textSize: 20,
                ),
              ),
              UpText("$username, ",
                  style: UpStyle(
                      textSize: 20,
                      textColor: UpConfig.of(context).theme.primaryColor,
                      textWeight: FontWeight.bold)),
              UpText(
                "Are you sure to Logout?",
                style: UpStyle(textSize: 20),
              )
            ]),
            const SizedBox(height: 16),
            UpButton(
              onPressed: () {
                setState(() {
                  _logout();
                });
              },
              text: 'LOGOUT',
            ),
          ]),
        ),
      ),
    );
  }
}
