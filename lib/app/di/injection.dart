import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../core/database/app_database.dart';
import '../../features/grocery_list/data/grocery_list_local_store.dart';
import '../../features/grocery_list/repository/grocery_list_local_data_source.dart';
import '../../features/grocery_list/repository/grocery_list_repository.dart';
import '../../sync/firestore_sync_service.dart';

final getIt = GetIt.instance;

void setupDI() {
  // -------------------------
  // Core
  // -------------------------
  getIt.registerLazySingleton<AppDatabase>(
        () => AppDatabase(),
  );

  // -------------------------
  // Sync (Firestore)
  // -------------------------
  getIt.registerLazySingleton<FirestoreSyncService>(
        () => FirestoreSyncService(
      FirebaseFirestore.instance,
    ),
  );


  // -------------------------
  // Grocery List - Local DB
  // -------------------------
  getIt.registerLazySingleton<GroceryListLocalDataSource>(
        () => GroceryListLocalStore(
      getIt<AppDatabase>(),
    ),
  );

  // -------------------------
  // Grocery List - Repository
  // -------------------------
  getIt.registerLazySingleton<GroceryListRepository>(
        () => LocalGroceryListRepository(
      getIt<GroceryListLocalDataSource>(),
    ),
  );
}