import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:drift/drift.dart';

import 'tables/grocery_list_table.dart';
import 'tables/grocery_item_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    GroceryListTable,
    GroceryItemTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app_db.sqlite'));
    return NativeDatabase(file);
  });
}