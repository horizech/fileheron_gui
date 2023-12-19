import 'package:flutter/material.dart';
import 'package:apiraiser/apiraiser.dart';

class LoginResponse {
  bool? success;
  String? message;
  User? data;

  LoginResponse({
    this.success,
    this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json['Success'] as bool == true) {
        LoginResponse loginResponse = LoginResponse(
            success: json['Success'],
            message: json['Message'],
            data: User.fromJson(
              json['Data'],
            ));
        return loginResponse;
      } else {
        LoginResponse loginResponse = LoginResponse(
            success: json['Success'], message: json['Message'], data: null);
        return loginResponse;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['Success'] = success;
    result['Message'] = message;
    result['Data'] = (data as List<dynamic>).map((e) => e as int).toList();
    return result;
  }
}
