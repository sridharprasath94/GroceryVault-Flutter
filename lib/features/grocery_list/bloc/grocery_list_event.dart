part of 'grocery_list_bloc.dart';

sealed class GroceryListEvent {}

class GroceryListStarted extends GroceryListEvent {}

class GroceryItemToggled extends GroceryListEvent {
  final String itemId;
  GroceryItemToggled(this.itemId);
}

class GroceryItemDeleted extends GroceryListEvent {
  final String itemId;
  GroceryItemDeleted(this.itemId);
}

class GroceryListSyncRequested extends GroceryListEvent {}
