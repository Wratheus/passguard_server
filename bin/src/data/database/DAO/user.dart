import 'package:drift/drift.dart';
import '../service.dart';
import '../tables/users.dart';

part 'user.g.dart';

@DriftAccessor(
  tables: [
    Users,
  ],
)
class UserDao extends DatabaseAccessor<DatabaseService> with _$UserDaoMixin {
  UserDao(super.db);

  Future<User?> getUserWithLogin(String login) async {
    return db.call(() async => await (db.select(users)
      ..where((tbl) => tbl.login.equals(login)))
        .getSingleOrNull());
  }

  Future<int> addUser({required String login, required String password}) async {
    return db.into(users).insert(UsersCompanion(
      login: Value(login),
      password: Value(password),
    ));
  }
}