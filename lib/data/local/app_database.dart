import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('AppUser')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text().unique()();
  TextColumn get password => text()();
}

@DataClassName('AppItem')
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Users, Items])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'app_boilerplate_db');
  }

  Future<int> insertUser(UsersCompanion entry) {
    return into(users).insert(entry);
  }

  Future<AppUser?> getUserByEmail(String email) {
    return (select(users)..where((tbl) => tbl.email.equals(email))).getSingleOrNull();
  }

  Future<AppUser?> getUserById(int id) {
    return (select(users)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertItem(ItemsCompanion entry) {
    return into(items).insert(entry);
  }

  Future<List<AppItem>> getAllItems() {
    return (select(items)..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])).get();
  }

  Future<int> deleteItemById(int id) {
    return (delete(items)..where((tbl) => tbl.id.equals(id))).go();
  }
}
