import 'package:drift/drift.dart';

@DataClassName('User')
class Users extends Table {
  IntColumn get userId => integer().autoIncrement()();

  TextColumn get login => text()();

  TextColumn get password => text()();
}
