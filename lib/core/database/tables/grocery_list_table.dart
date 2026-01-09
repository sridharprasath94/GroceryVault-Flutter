import 'package:drift/drift.dart';

class GroceryListTable extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get description => text().nullable()();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false))();

  IntColumn get deletedAt => integer().nullable()();

  IntColumn get createdAt => integer()();

  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}