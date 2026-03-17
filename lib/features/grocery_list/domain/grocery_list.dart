import 'grocery_item.dart';

class GroceryList {
  final String id;
  final String title;
  final String? description;
  final bool isDeleted;
  final int? deletedAt;
  final int createdAt;
  final int updatedAt;
  final List<GroceryItem> items;

  const GroceryList({
    required this.id,
    required this.title,
    this.description,
    required this.isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory GroceryList.fromFirestore(
    Map<String, dynamic> json,
    String documentId,
  ) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final listCreatedAt = json['createdAt'] as int? ?? 0;
    final listUpdatedAt = json['updatedAt'] as int? ?? 0;

    return GroceryList(
      id: documentId,
      title: json['title'] as String,
      description: json['description'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: json['deletedAt'] as int?,
      createdAt: listCreatedAt,
      updatedAt: listUpdatedAt,
      items: itemsJson
          .map(
            (e) => GroceryItem.fromFirestore(
              json: Map<String, dynamic>.from(e as Map),
              listId: documentId,
              listCreatedAt: listCreatedAt,
              listUpdatedAt: listUpdatedAt,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'items': items.map((i) => i.toFirestore()).toList(),
    };
  }

  GroceryList copyWith({
    List<GroceryItem>? items,
  }) {
    return GroceryList(
      id: id,
      title: title,
      description: description,
      isDeleted: isDeleted,
      deletedAt: deletedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      items: items ?? this.items,
    );
  }
}

