import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'src/core/REST/api.dart';
import 'src/core/utils/rsa_provider.dart';
import 'src/data/database/service.dart';

void main() async {
  final DatabaseService connection = DatabaseService();
  RSAProvider.rsaProviderInit();
  Api server = Api(connection);

  HttpServer servedServer = await shelf_io.serve(
    server.handler,
    'localhost',
    8080,
  );

  print('Serving at http://${servedServer.address.host}:${servedServer.port}');
}
