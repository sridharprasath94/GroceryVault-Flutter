
class GroceryItem {
  final String id;
  final String listId;
  final String name;
  final bool isChecked;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;

  const GroceryItem({
    required this.id,
    required this.listId,
    required this.name,
    required this.isChecked,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  GroceryItem copyWith({
    String? id,
    String? listId,
    String? name,
    bool? isChecked,
    int? sortOrder,
    int? createdAt,
    int? updatedAt,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      name: name ?? this.name,
      isChecked: isChecked ?? this.isChecked,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory GroceryItem.fromFirestore(
    Map<String, dynamic> json, {
    required String itemId,
    required String listId,
  }) {
    return GroceryItem(
      id: itemId,
      listId: listId,
      name: json['name'] as String,
      isChecked: json['isChecked'] as bool? ?? false,
      sortOrder: json['sortOrder'] as int? ?? 0,
      createdAt: json['createdAt'] as int? ?? 0,
      updatedAt: json['updatedAt'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'listId': listId,
      'name': name,
      'isChecked': isChecked,
      'sortOrder': sortOrder,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}