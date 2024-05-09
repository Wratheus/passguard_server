// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ProductControllerRouter(ProductController service) {
  final router = Router();
  router.add(
    'POST',
    r'/add',
    service.add,
  );
  router.add(
    'POST',
    r'/delete',
    service.delete,
  );
  router.add(
    'POST',
    r'/get',
    service.get,
  );
  router.add(
    'POST',
    r'/getAll',
    service.getAll,
  );
  return router;
}
