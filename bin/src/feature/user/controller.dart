import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../../data/database/service.dart';
import 'service.dart';

part 'controller.g.dart'; // generated with 'pub run build_runner build'

class ProductController {
  final DatabaseService database;
  final ProductService service;

  ProductController(this.database) : service = ProductService(database);

  @Route.post('/add')
  Future<Response> add(Request request) async => service.add(request);

  @Route.post('/delete')
  Future<Response> delete(Request request) async => service.delete(request);

  @Route.post('/get')
  Future<Response> get(Request request) async => service.get(request);

  @Route.post('/getAll')
  Future<Response> getAll(Request request) async => service.getAll(request);

  Router get router => _$ProductControllerRouter(this);

  Handler get handler => _$ProductControllerRouter(this).call;
}
