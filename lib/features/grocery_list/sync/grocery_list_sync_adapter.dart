import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groceryVault/features/grocery_list/repository/grocery_list_local_data_source.dart';

import '../../../sync/firestore_sync_adapter.dart';
import '../domain/grocery_list.dart';

class GroceryListSyncAdapter implements FirestoreSyncAdapter {
  final GroceryListLocalDataSource _local;
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
