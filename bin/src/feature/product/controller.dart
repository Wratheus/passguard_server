import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../../data/database/service.dart';
import 'service.dart';

part 'controller.g.dart';

class UserController {
  final DatabaseService database;
  final UserService service;

  UserController(this.database) : service = UserService(database);

  @Route.post('/login')
  Future<Response> auth(Request request) async => service.auth(request);

  @Route.post('/register')
  Future<Response> register(Request request) async => service.register(request);

  Router get router => _$UserControllerRouter(this);

  Handler get handler => _$UserControllerRouter(this).call;
}
