import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/dialogs/up_info.dart';
import 'package:flutter_up/dialogs/up_loading.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_dialog.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/validation/up_valdation.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _username = "", _fullname = "", _email = "", _password = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _signup() async {
    var formState = _formKey.currentState;

    if (formState!.validate()) {
      formState.save();
      String loadingDialogCompleterId = ServiceManager<UpDialogService>()
          .showDialog(context, UpLoadingDialog(),
              data: {'text': 'Signing up...'});

      APIResult result = await Apiraiser.authentication.signup(
        SignupRequest(
          username: _username,
          fullName: _fullname,
          email: _email,
          password: _password,
        ),
      );
      if (context.mounted) {
        ServiceManager<UpDialogService>().completeDialog(
            // ignore: use_build_context_synchronously
            context: context,
            completerId: loadingDialogCompleterId,
            result: null);
      }

      _handleSignupResult(result);
    } else {
      ServiceManager<UpDialogService>().showDialog(context, UpInfoDialog(),
          data: {'title': 'Error', 'text': 'Please fill all fields.'});
    }
  }

  void _handleSignupResult(APIResult result) {
    if (result.success) {
      _saveSession(result);
      setState(() {
        const HomePage();
      });
      UpToast().showToast(context: context, text: "SignUp Successfully");
    } else {
      ServiceManager<UpDialogService>().showDialog(context, UpInfoDialog(),
          data: {'title': 'Error', 'text': result.message});
    }
  }

  void _saveSession(APIResult result) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('email', _email);
  }
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UpTextField(
                    style: UpStyle(textfieldBorderRadius: 20),
                    validation: UpValidation(minLength: 6),
                    label: "Username",
                    onSaved: (input) => _username = input!,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UpTextField(
                    style: UpStyle(textfieldBorderRadius: 20),
                    label: 'Full name',
                    validation: UpValidation(isRequired: true),
                    onSaved: (input) => _fullname = input!,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UpTextField(
                    style: UpStyle(textfieldBorderRadius: 20),
                    label: 'Email',
                    validation: UpValidation(isRequired: true, isEmail: true),
                    onSaved: (input) => _email = input!,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UpTextField(
                      style: UpStyle(textfieldBorderRadius: 20),
                      label: 'Password',
                      validation: UpValidation(isRequired: true, minLength: 6),
                      maxLines: 1,
                      onSaved: (input) => _password = input!,
                      obscureText: true,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                      height: 42,
                      width: 160,
                      child: UpButton(
                        style: UpStyle(buttonBorderRadius: 20),
                        text: "Signup",
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Signup"),
                        ),
                        onPressed: () => _signup(),
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
