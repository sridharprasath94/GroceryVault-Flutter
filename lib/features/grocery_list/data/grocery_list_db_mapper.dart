import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/grocery_item.dart';
import '../domain/grocery_list.dart';

/// ------------------------------
/// Drift → Domain mapping
/// ------------------------------
GroceryList groceryListFromDb(
    GroceryListTableData list,
    List<GroceryItemTableData> items,
    ) {
  return GroceryList(
    id: list.id,
    title: list.title,
    description: list.description,
    isDeleted: list.isDeleted,
    deletedAt: list.deletedAt,
    createdAt: list.createdAt,
    updatedAt: list.updatedAt,
    items: items
        .map(
          (i) => GroceryItem(
        id: i.id,
        listId: i.listId,
        name: i.name,
        isChecked: i.isChecked,
        sortOrder: i.sortOrder,
        createdAt: i.createdAt,
        updatedAt: i.updatedAt,
      ),
    )
        .toList(),
  );
}

/// ------------------------------
/// GroceryList ↔ Drift mapping
/// ------------------------------
extension GroceryListDbMapper on GroceryList {
  GroceryListTableCompanion toDb() {
    return GroceryListTableCompanion.insert(
      id:  id,
      title: title,
      description:  Value(description),
      isDeleted:  Value(isDeleted),
      deletedAt:  Value(deletedAt),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension GroceryItemDbMapper on GroceryItem {
  GroceryItemTableCompanion toDb() {
    return GroceryItemTableCompanion.insert(
      id: id,
      listId: listId,
      name: name,
      isChecked:  Value(isChecked),
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// ------------------------------
/// Drift → Domain mapping
/// ------------------------------
extension GroceryListFromDb on GroceryList {
  GroceryList fromDb(
      GroceryListTableData list,
      List<GroceryItemTableData> items,
      ) {
    return GroceryList(
      id: list.id,
      title: list.title,
      description: list.description,
      isDeleted: list.isDeleted,
      deletedAt: list.deletedAt,
      createdAt: list.createdAt,
      updatedAt: list.updatedAt,
      items: items
          .map(
            (i) => GroceryItem(
          id: i.id,
          listId: i.listId,
          name: i.name,
          isChecked: i.isChecked,
          sortOrder: i.sortOrder,
          createdAt: i.createdAt,
          updatedAt: i.updatedAt,
        ),
      )
          .toList(),
    );
  }
}