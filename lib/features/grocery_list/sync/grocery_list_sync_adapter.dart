import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:groceryVault/features/grocery_list/data/grocery_list_store.dart';

import '../../../sync/firestore_sync_adapter.dart';
import '../domain/grocery_list.dart';

class GroceryListSyncAdapter implements FirestoreSyncAdapter {
  final GroceryListStore _local;
  final String _uid;

  GroceryListSyncAdapter(this._local, this._uid);

  @override
  String collectionPath() => 'users/$_uid/lists';

  @override
  Future<void> applyRemoteDocument(
      Map<String, dynamic> data,
      String documentId,
      ) async {
    final remote = GroceryList.fromFirestore(data, documentId);

    // 🔍 DEBUG: print remote list
    debugPrint('📦 Remote GroceryList:  id: ${remote.id}');
    debugPrint('📦 Remote GroceryList:  title: ${remote.title}');
    debugPrint('📦 Remote GroceryList:  updatedAt: ${remote.updatedAt}');
    debugPrint('📦 Remote GroceryList:  items count: ${remote.items.length}');

    for (final item in remote.items) {
      debugPrint(
        '📦 Remote GroceryList:  🧺 Item → '
            'id=${item.id}, '
            'listId=${item.listId}, '
            'name=${item.name}, '
            'checked=${item.isChecked}, '
            'updatedAt=${item.updatedAt}',
      );
    }

    final local = await _local.getById(remote.id);

    if (local == null || remote.updatedAt > local.updatedAt) {
      await _local.applyRemote(remote);
    }
  }

  @override
  Future<void> pushLocalToRemote() async {
    final lists = await _local.getAllIncludingDeleted();

    for (final list in lists) {
      await FirebaseFirestore.instance
          .collection(collectionPath())
          .doc(list.id.toString())
          .set(list.toFirestore());
    }
  }
}
