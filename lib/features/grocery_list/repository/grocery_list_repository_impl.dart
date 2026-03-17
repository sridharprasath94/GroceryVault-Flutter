import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../app/core/failure/failure.dart';
import '../domain/grocery_list.dart';
import '../data/grocery_list_store.dart';
import 'grocery_list_repository.dart';

class GroceryListRepositoryImpl implements GroceryListRepository {
  final GroceryListStore _local;

  GroceryListRepositoryImpl(this._local);

  @override
  Stream<Either<GroceryFailure, List<GroceryList>>> watchGroceries() {
    return _local.watchAll().map<Either<GroceryFailure, List<GroceryList>>>(
      (lists) => right<GroceryFailure, List<GroceryList>>(lists),
    );
  }

  @override
  TaskEither<GroceryFailure, Unit> addGrocery(GroceryList grocery) {
    return TaskEither.tryCatch(() async {
      await _local.upsert(grocery);
      return unit;
    }, (_, __) => const GroceryNetworkFailure());
  }

  @override
  TaskEither<GroceryFailure, Unit> deleteGrocery(String id) {
    return TaskEither.tryCatch(() async {
      await _local.deleteById(id);
      return unit;
    }, (_, __) => const GroceryNetworkFailure());
  }

  @override
  TaskEither<GroceryFailure, Unit> toggleCompleted(String id) {
    return TaskEither.tryCatch(() async {
      await _local.toggleCompleted(id);
      print('Toggled completed for item with id: $id');
      return unit;
    }, (_, __) => const GroceryNetworkFailure());
  }
}
