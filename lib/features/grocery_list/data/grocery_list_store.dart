import '../domain/grocery_list.dart';

abstract class GroceryListStore {
  /// Stream grocery lists from local DB
  Stream<List<GroceryList>> watchAll();

  /// Used by sync
  Future<List<GroceryList>> getAllIncludingDeleted();

  Future<GroceryList?> getById(String id);

  /// Writes
  Future<void> upsert(GroceryList groceryList);

  Future<void> deleteById(String id);

  /// Toggle completion for a grocery item
  Future<void> toggleCompleted(String itemId);

  /// Used by FirestoreSyncAdapter
  Future<void> applyRemote(GroceryList groceryList);
}
