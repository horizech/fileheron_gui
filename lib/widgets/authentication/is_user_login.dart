import 'package:apiraiser/apiraiser.dart';

bool isUserLogin() {
  User? user = Apiraiser.authentication.getCurrentUser();
  if (user != null && user.roleIds != null) {
    return true;
  } else {
    return false;
  }
}
