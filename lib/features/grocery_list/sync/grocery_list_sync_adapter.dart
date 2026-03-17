import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:groceryVault/features/grocery_list/data/grocery_list_store.dart';

import '../../../sync/firestore_sync_adapter.dart';
import '../domain/grocery_item.dart';
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
    final parsed = GroceryList.fromFirestore(data, documentId);

    final local = await _local.getById(parsed.id);

    // Build lookup for existing local items
    final localItemsByName = {
      for (final item in local?.items ?? <GroceryItem>[])
        item.name: item,
    };

    final reconciledItems = parsed.items.map((remoteItem) {
      final localItem = localItemsByName[remoteItem.name];

      if (localItem != null) {
        // 🔑 REUSE local identity
        return remoteItem.copyWith(
          id: localItem.id,
          createdAt: localItem.createdAt,
        );
      }

      // New item → keep generated UUID
      return remoteItem;
    }).toList();

    final remote = parsed.copyWith(items: reconciledItems);

    // 🔍 DEBUG
    debugPrint('📦 Remote GroceryList: id=${remote.id}');
    debugPrint('📦 Remote GroceryList: title=${remote.title}');
    debugPrint('📦 Remote GroceryList: updatedAt=${remote.updatedAt}');
    debugPrint('📦 Remote GroceryList: items=${remote.items.length}');

    for (final item in remote.items) {
      debugPrint(
        '📦 Item → id=${item.id}, name=${item.name}, checked=${item.isChecked}',
      );
    }

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
