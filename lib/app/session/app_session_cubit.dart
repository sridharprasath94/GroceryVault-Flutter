import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/grocery_list/data/grocery_list_store.dart';
import '../../features/grocery_list/sync/grocery_list_sync_adapter.dart';
import '../../sync/firestore_sync_service.dart';

class AppSessionCubit extends Cubit<void> {
  final GroceryListStore _store;
  final FirestoreSyncService _syncService;

  AppSessionCubit(
      this._store,
      this._syncService,
      ) : super(null);

  Future<void> onUserAuthenticated(String uid) async {
    final adapter = GroceryListSyncAdapter(_store, uid);

    await _syncService.syncNow(adapter);
    _syncService.startRealtime(adapter);
  }

  Future<void> onUserLoggedOut() async {
    _syncService.stop();
  }
}