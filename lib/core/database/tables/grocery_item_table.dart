import 'package:drift/drift.dart';
import 'grocery_list_table.dart';

class GroceryItemTable extends Table {
  TextColumn get id => text()();

  TextColumn get listId =>
      text().references(GroceryListTable, #id)();

  TextColumn get name => text()();

  BoolColumn get isChecked =>
      boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer()();

  IntColumn get createdAt => integer()();

  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}