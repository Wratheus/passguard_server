import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../data/database/service.dart';
import '../../feature/product/controller.dart';
import '../../feature/user/controller.dart';

part 'api.g.dart';

class Api {
  Api(this.database);

  final DatabaseService database;



  @Route.mount('/api/user')
  Router get _users => UserController(database).router;

  @Route.mount('/api/product')
  Router get _products => ProductController(database).router;

  Router get router => _$ApiRouter(this);

  Handler get handler => _$ApiRouter(this).call;
}