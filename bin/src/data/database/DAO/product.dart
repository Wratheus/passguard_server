import 'package:drift/drift.dart';
import 'package:encrypt/encrypt.dart';

import '../service.dart';
import '../tables/products.dart';

part 'product.g.dart';

@DriftAccessor(
  tables: <Type>[
    Products,
  ],
)
class ProductDao extends DatabaseAccessor<DatabaseService> with _$ProductDaoMixin {
  ProductDao(super.db);

  Future<Product?> getPassword(int userId, int passwordId) async {
    return db.call(() async => await (db.select(products)
      ..where(($ProductsTable tbl) => tbl.id.equals(passwordId)))
        .getSingleOrNull());
  }

  Future<List<Product>?> getAllPasswords(int userId) async {
    return db.call(() async => await (db.select(products)
      ..where(($ProductsTable tbl) => tbl.userId.equals(userId)))
        .get());
  }

  Future<int?> addPassword(
      {required int userId,
        required Encrypted password,
        String? url,
        String? description,
        String? name}) async {
    return db.call(() async => db.into(products).insert(ProductsCompanion(
        password: Value(password.base64),
        name: Value(name),
        description: Value(description),
        url: Value(url),
        userId: Value(userId))));
  }

  Future<void> deletePassword({
    required int userId,
    required int passwordId,
  }) async {
    return db.call(() async =>
    await ((db.delete(products)..where(($ProductsTable tbl) => tbl.id.equals(passwordId)))
      ..where(($ProductsTable tbl) => tbl.userId.equals(userId)))
        .go());
  }
}