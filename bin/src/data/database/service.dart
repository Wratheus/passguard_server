import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import '../../core/constants/enums.dart';
import '../../core/utils/log.dart';
import 'DAO/product.dart';
import 'DAO/user.dart';
import 'tables/products.dart';
import 'tables/users.dart';

part 'service.g.dart';

@DriftDatabase(
  daos: <Type>[
    ProductDao,
    UserDao,
  ],
  tables: <Type>[
    Products,
    Users,
  ],
)
final class DatabaseService extends _$DatabaseService {
  DatabaseService() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static Future<Directory> get getDirectory async => Directory("database");

  static Future<File> get getDbFile async =>
      File("${(await getDirectory).path}/passguard.sqlite");

  @override
  MigrationStrategy get migration => MigrationStrategy(
      onUpgrade: (Migrator m, int from, int to) async {},
      beforeOpen: (OpeningDetails details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      });

  Future<T?> call<T>(Future<T?> Function() fn) async =>
      await fn().onError((Object? error, StackTrace stackTrace) {
        error?.log(name: 'Database.call', level: LogLevel.error);
        return null;
      });

  Future<void> clearDatabase() async {
    for (final TableInfo<Table, Object?> table in allTables) {
      await delete(table).go();
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(
    () async {
      final File file = await DatabaseService.getDbFile;
      file.toString().log(name: "drift._openConnection()");
      return NativeDatabase.createInBackground(file);
    },
  );
}
