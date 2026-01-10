import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/grocery_list.dart';
import 'grocery_list_store.dart';
import 'grocery_list_db_mapper.dart';

class GroceryListLocalStore implements GroceryListStore {
  final AppDatabase _db;

  GroceryListLocalStore(this._db);

  /// Stream for UI
  @override
  Stream<List<GroceryList>> watchAll() {
    final lists = _db.select(_db.groceryListTable)
      ..where((l) => l.isDeleted.equals(false))
      ..orderBy([(l) => OrderingTerm.desc(l.createdAt)]);

    return lists.watch().asyncMap((rows) async {
      return Future.wait(rows.map(_loadList));
    });
  }

  @override
  Future<List<GroceryList>> getAllIncludingDeleted() async {
    final rows = await _db.select(_db.groceryListTable).get();
    return Future.wait(rows.map(_loadList));
  }

  @override
  Future<GroceryList?> getById(String id) async {
    final row = await (_db.select(
      _db.groceryListTable,
    )..where((l) => l.id.equals(id))).getSingleOrNull();

    return row == null ? null : _loadList(row);
  }

  @override
  Future<void> upsert(GroceryList list) async {
    await _db.into(_db.groceryListTable).insertOnConflictUpdate(list.toDb());

    await _db.transaction(() async {
      await (_db.delete(
        _db.groceryItemTable,
      )..where((i) => i.listId.equals(list.id))).go();

      await _db.batch((b) {
        b.insertAll(
          _db.groceryItemTable,
          list.items.map((i) => i.toDb()).toList(),
        );
      });
    });
  }

  @override
  Future<void> deleteById(String id) async {
    await (_db.delete(
      _db.groceryListTable,
    )..where((l) => l.id.equals(id))).go();
  }

  @override
  Future<void> toggleCompleted(String itemId) async {
    await (_db.update(
      _db.groceryItemTable,
    )..where((i) => i.id.equals(itemId))).write(
      GroceryItemTableCompanion(
        isChecked: const Value(true), // or toggle logic
      ),
    );
  }

  @override
  Future<void> applyRemote(GroceryList list) async {
    await upsert(list);
  }

  Future<GroceryList> _loadList(GroceryListTableData row) async {
    final items =
        await (_db.select(_db.groceryItemTable)
              ..where((i) => i.listId.equals(row.id))
              ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]))
            .get();

    return groceryListFromDb(row, items);
  }
}
