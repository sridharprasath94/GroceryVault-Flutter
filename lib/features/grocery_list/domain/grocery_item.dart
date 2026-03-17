import 'package:uuid/uuid.dart';

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

  /// Firestore → Domain
  factory GroceryItem.fromFirestore({
    required Map<String, dynamic> json,
    required String listId,
    required int listCreatedAt,
    required int listUpdatedAt,
  }) {
     final id = json['id'] as String? ?? const Uuid().v4();

    return GroceryItem(
      id: id,
      listId: listId,
      name: json['name'] as String,
      isChecked: json['isChecked'] as bool? ?? false,
      sortOrder: json['sortOrder'] as int? ?? 0,
      createdAt: json['createdAt'] as int? ?? listCreatedAt,
      updatedAt: json['updatedAt'] as int? ?? listUpdatedAt,
    );
  }

  /// Domain → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'isChecked': isChecked,
      'sortOrder': sortOrder,
    };
  }

  GroceryItem copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      listId: listId,
      name: name,
      isChecked: isChecked,
      sortOrder: sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
