import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_sync_adapter.dart';

class FirestoreSyncService {
  final FirebaseFirestore _firestore;
  StreamSubscription? _sub;

  FirestoreSyncService(this._firestore);

  Future<void> syncNow(FirestoreSyncAdapter adapter) async {
    final snapshot =
    await _firestore.collection(adapter.collectionPath()).get();

    for (final doc in snapshot.docs) {
      await adapter.applyRemoteDocument(doc.data(), doc.id);
    }

    // await adapter.pushLocalToRemote();
  }

  void startRealtime(FirestoreSyncAdapter adapter) {
    _sub?.cancel();

    _sub = _firestore
        .collection(adapter.collectionPath())
        .snapshots()
        .listen((snapshot) {
      for (final change in snapshot.docChanges) {
        adapter.applyRemoteDocument(
          change.doc.data()!,
          change.doc.id,
        );
      }
    });
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
  }
}