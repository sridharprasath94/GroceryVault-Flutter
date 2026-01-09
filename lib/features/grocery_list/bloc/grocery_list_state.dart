part of 'grocery_list_bloc.dart';

sealed class GroceryListState {
  const GroceryListState();
}

class GroceryListLoading extends GroceryListState {
  const GroceryListLoading();
}

class GroceryListLoaded extends GroceryListState {
  final List<GroceryList> groceries;

  const GroceryListLoaded(this.groceries);
}

class GroceryListFailure extends GroceryListState {
  final GroceryFailure failure;

  const GroceryListFailure(this.failure);
}