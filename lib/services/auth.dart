import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/apiraiser/blocs/project.dart';
import 'package:fileheron_gui/apiraiser/blocs/user.dart';
import 'package:fileheron_gui/apiraiser/models/login_response.dart';
import 'package:fileheron_gui/services/key.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/subjects.dart';
import 'package:flutter_up/locator.dart';


class AuthService {
  final BehaviorSubject<User?> _user = BehaviorSubject.seeded(null);
  Stream get stream$ => _user.stream;
  User? get user => _user.valueWrapper?.value;

  String? get token => user?.accessToken;

  void update(User? newValue) {
    _user.add(newValue);
  }

  void updateUser(User? user) async {
    update(user);
  }

  /// LogIn using email and password
  Future<LoginResponse> logIn(login, password) async {
    LoginResponse response = await userBloc.logIn(login, password);
    if (response.success ?? false) {
      updateUser(response.data);
    }
    return response;
  }

  /// LogIn using auth token
  Future<LoginResponse> loadLastSession() async {
    LoginResponse response = await userBloc.loadLastSession();
    if (response.success ?? false) {
      updateUser(response.data);
    }
    return response;
  }

  /// SignUp using email and password
  Future<LoginResponse> signUp(SignupRequest request) async {
    LoginResponse response = await userBloc.signUp(request);
    if (response.success ?? false) {
      updateUser(response.data);
    }
    return response;
  }

  /*
  
  /// Send confirmation email
  Future<String> sendEmail(email, password) async {
    return _provider.sendEmail(email, password);
  }

  */

  /// LogOut

  Future<bool> logOut() async {
    Apiraiser.authentication.signOut();
    ServiceManager<AuthService>().update(null);
    ServiceManager<KeyService>().removeKey();

    projectBloc.clear();
    const storage = FlutterSecureStorage();
    await storage.write(key: "key", value: null);
    await storage.write(key: "duration", value: null);
    await storage.write(key: "sessionStartedTime", value: null);

    return true;
  }
}
