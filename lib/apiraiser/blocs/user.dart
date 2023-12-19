import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/apiraiser/models/login_response.dart';
import 'package:fileheron_gui/apiraiser/repositories/user.dart';
import 'package:rxdart/subjects.dart';
// import 'package:rxdart/rxdart.dart';

class UserBloc {
  final repository = UserRepository();

  final PublishSubject<User?> _userFetcher = PublishSubject<User?>();
  Stream<User?> get stream$ => _userFetcher.stream;

  /// LogIn using email and password
  Future<LoginResponse> logIn(login, password) async {
    LoginResponse result = await repository.logIn(login, password);
    _userFetcher.sink.add(result.data);
    return result;
  }

  /// LogIn using auth token
  Future<LoginResponse> loadLastSession() async {
    LoginResponse result = await repository.loadLastSession();
    _userFetcher.sink.add(result.data);
    return result;
  }

  /// SignUp using email and password
  Future<LoginResponse> signUp(SignupRequest request) async {
    LoginResponse result = await repository.signUp(request);
    _userFetcher.sink.add(result.data);
    return result;
  }

  // Generate AES RSA Pair
  Future<APIResult> generateAESRSAPair(String password) async {
    APIResult result = await repository.generateAESRSAPair(password);
    return result;
  }

  dispose() {
    _userFetcher.close();
  }

  /*
  
  /// Send confirmation email
  Future<String> sendEmail(email, password) async {
    return _provider.sendEmail(email, password);
  }

  */
}

final UserBloc userBloc = UserBloc();
