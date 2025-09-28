import '../../domain/entities/category.dart';

class CategoryModel {
  final String? id;
  final String name;
  final String? description;
  final String? parentId;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    this.id,
    required this.name,
    this.description,
    this.parentId,
    this.imageUrl,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String?,
      parentId: map['parent_id'] as String?,
      imageUrl: map['image_url'] as String?,
      isActive: map['is_active'] == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'parent_id': parentId,
      'image_url': imageUrl,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? parentId,
    String? imageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert to entity
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      parentId: parentId,
      imageUrl: imageUrl,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
