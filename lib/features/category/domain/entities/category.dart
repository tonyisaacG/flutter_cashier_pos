import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String? id;
  final String name;
  final String? description;
  final String? parentId;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Category({
    this.id,
    required this.name,
    this.description,
    this.parentId,
    this.imageUrl,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, description, parentId, imageUrl, isActive, createdAt, updatedAt];

  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? parentId,
    String? imageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
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
}
