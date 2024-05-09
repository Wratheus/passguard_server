import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

sealed class JWTProvider {
  static Future<String> getJWT(Map<String, dynamic> payload) async {
    final JWT jwt = JWT(payload);

    final String token =
    jwt.sign(SecretKey(await File('jwt_secret.pem').readAsString()));

    return token;
  }

  static Future<Map<String, dynamic>?> verifyJWT(String token) async {
    try {
      final JWT jwt = JWT.verify(
          token, SecretKey(await File('jwt_secret.pem').readAsString()));
      return Map<String, dynamic>.from(jwt.payload);
    } on JWTExpiredException {
      return null;
    } on JWTException {
      return null;
    }
  }
}