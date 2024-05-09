import 'package:drift/drift.dart';

@DataClassName('Product')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer()();

  TextColumn get password => text()();

  TextColumn get name => text().nullable()();

  TextColumn get url => text().nullable()();

  TextColumn get description => text().nullable()();
}