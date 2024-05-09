import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../core/utils/jwt_provider.dart';
import '../../core/utils/response_template.dart';
import '../../core/utils/rsa_provider.dart';
import '../../data/database/service.dart';

final class ProductService with ResponseTemplates {
  final DatabaseService database;

  ProductService(this.database);

  Future<Response> add(Request request) async {
    final data = await request.readAsString();
    try {
      final map = jsonDecode(data);
      final token = map['token'];
      final password = map['password'];
      if (password is! String) {
        return Response.forbidden(error(errorMessage: 'password обязателен'));
      }
      final name = map['name'];
      final url = map['url'];
      final description = map['description'];

      final payload = await JWTProvider.verifyJWT(token);

      if (payload == null) {
        return Response.forbidden(
            error(errorMessage: 'Авторизация не пройдена'));
      }

      final encryptedPassword = await RSAProvider.encode(password);

      final passwordId = await database.productDao.addPassword(
          userId: payload['userId'],
          password: encryptedPassword,
          url: url,
          description: description,
          name: name);

      return Response.ok(ok({'id': passwordId}));
    } catch (e) {
      return Response.forbidden(error(errorMessage: e.toString()));
    }
  }

  Future<Response> delete(Request request) async {
    final data = await request.readAsString();
    try {
      final map = jsonDecode(data);
      final token = map['token'];
      final id = map['id'];
      if (id == null) {
        return Response.forbidden(error(errorMessage: 'id is required'));
      }
      final payload = await JWTProvider.verifyJWT(token);

      if (payload == null) {
        return Response.forbidden(
            error(errorMessage: 'Авторизация не пройдена'));
      }

      await database.productDao.deletePassword(
        userId: payload['userId'],
        passwordId: int.parse(id),
      );

      return Response.ok(ok({'result': true}));
    } catch (e) {
      return Response.forbidden(error(errorMessage: e.toString()));
    }
  }

  Future<Response> get(Request request) async {
    final data = await request.readAsString();
    try {
      final map = jsonDecode(data);
      final token = map['token'];
      final passwordId = map['id'];
      if (passwordId is! int) {
        return Response.forbidden(error(errorMessage: 'id обязателен'));
      }

      final payload = await JWTProvider.verifyJWT(token);

      if (payload == null) {
        return Response.forbidden(
            error(errorMessage: 'Авторизация не пройдена'));
      }

      final userId = payload['userId'];

      final password =
          await database.productDao.getPassword(userId, passwordId);

      if (password == null) {
        return Response.forbidden(
            error(errorMessage: 'Пароля с таким id не найдено'));
      }

      final dectyptedPassword =
          await RSAProvider.decode(password.password);

      return Response.ok(ok({
        'password': password.copyWith(password: dectyptedPassword).toJson()
      }));
    } catch (e) {
      return Response.forbidden(error(errorMessage: e.toString()));
    }
  }

  Future<Response> getAll(Request request) async {
    final data = await request.readAsString();
    try {
      final map = jsonDecode(data);
      final token = map['token'];
      final payload = await JWTProvider.verifyJWT(token);

      if (payload == null) {
        return Response.forbidden(
            error(errorMessage: 'Авторизация не пройдена'));
      }

      final userId = payload['userId'];

      final passwords = await database.productDao.getAllPasswords(userId);

      if (passwords == null) {
        return Response.forbidden('Произошла неизвестная ошибка');
      }

      var decryptedPasswords = [];

      for (var pass in passwords) {
        final dectyptedPassword = await RSAProvider.decode(pass.password);

        decryptedPasswords.add(dectyptedPassword);
      }

      final List<Map<String, dynamic>> passwordsJsonList = [];

      for (int i = 0; i < passwords.length; i++) {
        passwordsJsonList.add(
            passwords[i].copyWith(password: decryptedPasswords[i]).toJson());
      }

      return Response.ok(ok({'passwords': passwordsJsonList}));
    } catch (e) {
      return Response.forbidden(error(errorMessage: e.toString()));
    }
  }
}
