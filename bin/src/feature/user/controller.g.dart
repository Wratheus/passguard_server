// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$UserControllerRouter(UserController service) {
  final router = Router();
  router.add(
    'POST',
    r'/login',
    service.login,
  );
  router.add(
    'POST',
    r'/register',
    service.register,
  );
  return router;
}
