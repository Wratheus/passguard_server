import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shelf/shelf.dart';

import '../../core/utils/jwt_provider.dart';
import '../../core/utils/response_template.dart';
import '../../data/database/service.dart';

final class UserService with ResponseTemplates {
  final DatabaseService database;

  UserService(this.database);

  Future<Response> auth(Request request) async {
    try {
      final paramsStr = await request.readAsString();
      final params = jsonDecode(paramsStr);
      final login = params['login'];
      final password = params['password'];

      final user = await database.userDao.getUserWithLogin(login);

      final encodedPasswordString = encodePassword(password);

      if (user == null || user.password != encodedPasswordString) {
        return Response.forbidden(
          error(errorMessage: 'Неверный логин или пароль!'),
        );
      }

      final token = await JWTProvider.getJWT({'userId': user.userId});

      return Response.ok(
        ok({
          'userId': user.userId,
          'token': token,
        }),
      );
    } catch (e) {
      return Response.forbidden(error(errorMessage: e.toString()));
    }
  }

  Future<Response> register(Request request) async {
    try {
      final paramsStr = await request.readAsString();
      final params = jsonDecode(paramsStr);
      final login = params['login'];
      final password = params['password'];
      final confirm = params['confirm'];

      if (password != confirm) {
        return Response.forbidden(error(errorMessage: "Пароли не совпадают"));
      }

      final user = await database.userDao.getUserWithLogin(login);

      if (user != null) {
        return Response.forbidden(
            error(errorMessage: "Пользователь с таким логином уже существует"));
      }

      final encodedPasswordString = encodePassword(password);

      final newId = await database.userDao
          .addUser(login: login, password: encodedPasswordString);

      final token = await JWTProvider.getJWT({'userId': newId});

      final response = {
        'userId': newId,
        'token': token,
      };

      final encodedData = ok(response);

      print(encodedData);

      return Response.ok(encodedData);
    } catch (e) {
      return Response.forbidden(error(errorMessage: e.toString()));
    }
  }

  String encodePassword(String password) {
    final encodedPasswordDigest = sha256.convert(utf8.encode(password));

    final encodedPasswordString = base64Encode(encodedPasswordDigest.bytes);
    return encodedPasswordString;
  }
}