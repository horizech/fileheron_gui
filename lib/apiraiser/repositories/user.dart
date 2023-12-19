import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/apiraiser/models/login_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class UserRepository {
  /// LogIn using username and password
  Future<LoginResponse> logIn(username, password) async {
    try {
      APIResult loginResult = await Apiraiser.authentication.login(
        LoginRequest(
          username: username,
          password: password,
        ),
      );
      if (loginResult.success) {
        LoginResponse result = LoginResponse(
          success: true,
          message: loginResult.message,
          data: Apiraiser.authentication.getCurrentUser(),
        );
        return result;
      } else {
        return LoginResponse(success: false, message: loginResult.message);
      }
    } catch (e) {
      return LoginResponse(success: false, message: e.toString());
    }
  }

  /// LogIn using email and password
  Future<LoginResponse> signUp(SignupRequest request) async {
    try {
      APIResult loginResult = await Apiraiser.authentication.signup(request);
      if (loginResult.success) {
        LoginResponse result = LoginResponse(
            success: true,
            message: loginResult.message,
            data: Apiraiser.authentication.getCurrentUser());
        return result;
      } else {
        return LoginResponse(success: false, message: loginResult.message);
      }
    } catch (e) {
      return LoginResponse(success: false, message: e.toString());
    }
  }

  /// Load last session
  Future<LoginResponse> loadLastSession() async {
    try {
      APIResult loginResult =
          await Apiraiser.authentication.loadSessionUsingJwt("");
      if (loginResult.success) {
        LoginResponse result = LoginResponse(
          success: true,
          message: loginResult.message,
          data: Apiraiser.authentication.getCurrentUser(),
        );
        return result;
      } else {
        return LoginResponse(success: false, message: loginResult.message);
      }
    } catch (e) {
      return LoginResponse(success: false, message: e.toString());
    }
  }

  Future<APIResult> generateAESRSAPair(String password) async {
    try {
      APIResult apiResult =
          await Apiraiser.encryption.generateAESRSAPair(password);
      return apiResult;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /*
  /// Send confirmation email
  @override
  Future<String> sendEmail(email, password) async {
    return null;
  }
  */
}
