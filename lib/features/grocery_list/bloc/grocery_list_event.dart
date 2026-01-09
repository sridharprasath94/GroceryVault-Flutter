part of 'grocery_list_bloc.dart';

sealed class GroceryListEvent {}

class GroceryListStarted extends GroceryListEvent {}

class GroceryItemToggled extends GroceryListEvent {
  final String id;
  GroceryItemToggled(this.id);
}

class GroceryItemDeleted extends GroceryListEvent {
  final String id;
  GroceryItemDeleted(this.id);
}
