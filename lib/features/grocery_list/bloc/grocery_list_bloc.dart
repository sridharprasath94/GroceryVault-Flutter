import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:groceryVault/features/grocery_list/domain/grocery_list.dart';

import '../../../app/core/failure/failure.dart';
import '../repository/grocery_list_repository.dart';

part 'grocery_list_event.dart';

part 'grocery_list_state.dart';

class GroceryListBloc extends Bloc<GroceryListEvent, GroceryListState> {
  final GroceryListRepository _repository;

  GroceryListBloc(this._repository) : super(const GroceryListLoading()) {
    on<GroceryListStarted>(_onStarted);
    on<GroceryItemToggled>(_onToggled);
    on<GroceryItemDeleted>(_onDeleted);
    on<GroceryListSyncRequested>(_onSyncRequested);
  }

  Future<void> _onStarted(
    GroceryListStarted event,
    Emitter<GroceryListState> emit,
  ) async {
    emit(const GroceryListLoading());

    await emit.forEach<Either<GroceryFailure, List<GroceryList>>>(
      _repository.watchGroceries(),
      onData: (either) => either.match(
        (failure) => GroceryListFailure(failure),
        (groceries) => GroceryListLoaded(groceries),
      ),
      onError: (_, __) => const GroceryListFailure(GroceryNetworkFailure()),
    );
  }

  Future<void> _onToggled(
    GroceryItemToggled event,
    Emitter<GroceryListState> emit,
  ) async {
    await _repository.toggleCompleted(event.itemId).run();
  }

  Future<void> _onDeleted(
    GroceryItemDeleted event,
    Emitter<GroceryListState> emit,
  ) async {
    await _repository.deleteGrocery(event.itemId).run();
  }

  void _onSyncRequested(
    GroceryListSyncRequested event,
    Emitter<GroceryListState> emit,
  ) {
    // 🔜 Later: trigger Firestore sync service
  }
}
