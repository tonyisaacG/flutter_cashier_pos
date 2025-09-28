import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashier_pos/features/category/domain/entities/category.dart';
import 'package:cashier_pos/features/category/domain/usecases/create_category.dart';
import 'package:cashier_pos/features/category/domain/usecases/update_category.dart';
import 'package:cashier_pos/features/category/domain/usecases/delete_category.dart';
import 'package:cashier_pos/features/category/domain/usecases/get_categories.dart';
import 'package:cashier_pos/features/category/domain/usecases/get_category.dart';

// Events
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  const LoadCategories();
}

class LoadCategory extends CategoryEvent {
  final String id;

  const LoadCategory(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateCategoryEvent extends CategoryEvent {
  final Category category;

  const CreateCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateCategoryEvent extends CategoryEvent {
  final Category category;

  const UpdateCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class DeleteCategoryEvent extends CategoryEvent {
  final String id;

  const DeleteCategoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

// States
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

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CreateCategory createCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;
  final GetCategories getCategories;
  final GetCategory getCategory;

  CategoryBloc({
    required this.createCategory,
    required this.updateCategory,
    required this.deleteCategory,
    required this.getCategories,
    required this.getCategory,
  }) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadCategory>(_onLoadCategory);
    on<CreateCategoryEvent>(_onCreateCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final categories = await getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onLoadCategory(
    LoadCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final category = await getCategory(event.id);
      emit(CategoryLoaded(category));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onCreateCategory(
    CreateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final category = await createCategory(event.category);
      emit(CategoryCreated(category));
      // Reload categories after creation
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final category = await updateCategory(event.category);
      emit(CategoryUpdated(category));
      // Reload categories after update
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await deleteCategory(event.id);
      emit(CategoryDeleted(event.id));
      // Reload categories after deletion
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
