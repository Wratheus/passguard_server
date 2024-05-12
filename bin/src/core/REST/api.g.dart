// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ApiRouter(Api service) {
  final router = Router();
  router.mount(
    r'/api/user',
    service._users.call,
  );
  router.mount(
    r'/api/product',
    service._products.call,
  );
  return router;
}
