import 'package:equatable/equatable.dart';
import 'package:cashier_pos/features/category/domain/entities/category.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final List<Category> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryLoaded extends CategoryState {
  final Category category;

  const CategoryLoaded(this.category);

  @override
  List<Object?> get props => [category];
}

class CategoryCreated extends CategoryState {
  final Category category;

  const CategoryCreated(this.category);

  @override
  List<Object?> get props => [category];
}

class CategoryUpdated extends CategoryState {
  final Category category;

  const CategoryUpdated(this.category);

  @override
  List<Object?> get props => [category];
}

class CategoryDeleted extends CategoryState {
  final String categoryId;

  const CategoryDeleted(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
