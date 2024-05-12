import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../core/utils/jwt_provider.dart';
import '../../core/utils/response_template.dart';
import '../../core/utils/rsa_provider.dart';
import '../../data/database/service.dart';

final class UserService with ResponseTemplates {
  final DatabaseService database;

  UserService(this.database);

  Future<Response> login(Request request) async {
    try {
      final paramsStr = await request.readAsString();
      final params = jsonDecode(paramsStr);
      final login = params['login'];
      final String password = params['password'];

      final user = await database.userDao.getUserWithLogin(login);

      final encodedPasswordString = await RSAProvider.encode(password);

      if (user == null || user.password != encodedPasswordString.base64) {
        return Response.ok(mapToJson(message: 'Неверный логин или пароль!'));
      }

      final token = await JWTProvider.getJWT({'userId': user.userId});

      return Response.ok(mapToJson(
        success: true,
        data: {'userId': user.userId, 'token': token},
      ));
    } catch (e) {
      return Response.ok(mapToJson(message: e.toString()));
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
        return Response.ok(mapToJson(message: "Пароли не совпадают"));
      }

      final user = await database.userDao.getUserWithLogin(login);

      if (user != null) {
        return Response.ok(
            mapToJson(message: "Пользователь с таким логином уже существует"));
      }

      final newId =
          await database.userDao.addUser(login: login, password: password);

      final token = await JWTProvider.getJWT({'userId': newId});

      final response = {
        "success": true,
        'userId': newId,
        'token': token,
      };

      print(response);

      return Response.ok(jsonEncode(response));
    } catch (e) {
      return Response.ok(mapToJson(message: e.toString()));
    }
  }
}
