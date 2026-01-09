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

  GroceryList copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDeleted,
    int? deletedAt,
    int? createdAt,
    int? updatedAt,
    List<GroceryItem>? items,
  }) {
    return GroceryList(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }

  factory GroceryList.fromFirestore(
    Map<String, dynamic> json,
    String documentId,
  ) {
    final itemsJson = (json['items'] as List<dynamic>? ?? []);

    return GroceryList(
      id: documentId,
      title: json['title'] as String,
      description: json['description'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: json['deletedAt'] as int?,
      createdAt: json['createdAt'] as int? ?? 0,
      updatedAt: json['updatedAt'] as int? ?? 0,
      items: itemsJson.asMap().entries.map((entry) {
        final index = entry.key;
        final map = Map<String, dynamic>.from(entry.value as Map);

        // Firestore items do NOT have ids → generate deterministic one
        final itemId = map['id'] as String? ??
            '${documentId}_item_$index';

        return GroceryItem.fromFirestore(
          map,
          itemId: itemId,
          listId: documentId,
        );
      }).toList(),
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
}